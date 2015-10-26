//
//  AppDelegate.swift
//  Overwatch
//
//  Created by adam on 10/18/15.
//  Copyright (c) 2015 Adam Ransom. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  // MARK: IB Outlets
  @IBOutlet private weak var statusMenu_: NSMenu!
  @IBOutlet private weak var menuOpenClipboard_: NSMenuItem!
  // MARK: Private Variables
  private var videoDisplay_ = VideoWindowsDisplay()
  private var preferencesWindow_: NSWindow?
  private let statusItem_ = NSStatusBar.systemStatusBar()
                                       .statusItemWithLength(NSSquareStatusItemLength)

  // MARK: - NSApplicationDelegate Methods

  func applicationWillFinishLaunching(aNotification: NSNotification) {
    setupURLScheme()
  }

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    setupStatusMenu()
    setupUserDefaults()
  }

  // MARK: - Overrides

  override func observeValueForKeyPath(
    keyPath: String?,
    ofObject object: AnyObject?,
    change: [String : AnyObject]?,
    context: UnsafeMutablePointer<Void>
  ) {
    if (keyPath != nil && change != nil) {
      switch keyPath! {
      case "video_opacity":
        self.videoDisplay_.opacity = Float(change!["new"] as! NSNumber)
        break
      case "opaque_on_hover":
        self.videoDisplay_.opaqueOnHover = change!["new"] as! Bool
        break
      case "appear_on_all_spaces":
        self.videoDisplay_.appearOnAllSpaces = change!["new"] as! Bool
        break
      default:
        break
      }
    }
  }

  override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
    // Only enable "Open from Clipboard..." if there is a
    // YouTube URL on the clipboard
    if (menuItem == menuOpenClipboard_) {
      if let urlFragment = getClipboardString() {
        return URLParser(urlFragment: urlFragment).isYouTube()
      } else {
        return false
      }
    }

    return true
  }

  // MARK: - IB Actions

  @IBAction func actionPreferences(sender: NSMenuItem) {
    createPreferencesWindow()
  }

  @IBAction func actionOpenURL(sender: NSMenuItem) {
    askForURL()
  }

  @IBAction func actionOpenClipboard(sender: NSMenuItem) {
    if let urlFragment = getClipboardString() {
      let parser = URLParser(urlFragment: urlFragment)
      if (parser.isYouTube()) {
        createVideoWindow(parser.url())
      }
    }
  }

  @IBAction func actionResetPositions(sender: NSMenuItem) {
    for window in videoDisplay_.windows {
      window.resetPosition()
    }
  }

  // MARK: - Private Functions

  /**
    Set up the user prefences (defaults).
  */
  private func setupUserDefaults() {
    // Specify user defaults
    let appDefaults = [
      "video_opacity": NSNumber(float: 1.0),
      "opaque_on_hover": false,
      "appear_on_all_spaces": false
    ]

    // Register the defaults
    NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)

    // Observe the defaults
    for (keyPath, _) in appDefaults {
      observeUserDefault(keyPath)
    }
  }

  /**
    Setup the status menu.
  */
  private func setupStatusMenu() {
    if let icon = NSImage(named: "StatusIcon") {
      icon.template = true
      statusItem_.image = icon
    }

    statusItem_.menu = statusMenu_
  }
  
  /**
    Add handling for URL scheme `overwatch://`.
  */
  private func setupURLScheme() {
    let appleEventManager = NSAppleEventManager.sharedAppleEventManager()

    appleEventManager.setEventHandler(
      self,
      andSelector: "handleGetURLEvent:replyEvent:",
      forEventClass: AEEventClass(kInternetEventClass),
      andEventID: AEEventID(kAEGetURL)
    )
  }

  /**
    Add a new observer for a specific user default in order
    to receive changes.
  */
  func observeUserDefault(keyPath: String) {
    NSUserDefaults.standardUserDefaults().addObserver(
      self,
      forKeyPath: keyPath,
      options: .New,
      context: nil
    )
  }

  /**
    Create a new video window.
  */
  private func createVideoWindow(url: String?) {
    if (url == nil) { return }

    if let window = VideoWindow(url: url!) {
      videoDisplay_.add(window)
    }
  }

  /**
    Show the preferences window (creates once and reuses).
  */
  private func createPreferencesWindow() {
    if self.preferencesWindow_ == nil {
      self.preferencesWindow_ = NSWindow(
        contentRect: NSMakeRect(0, 0, 300, 98),
        styleMask: NSTitledWindowMask | NSClosableWindowMask,
        backing: .Buffered,
        `defer`: true
      )

      if let window = self.preferencesWindow_ {
        window.center()
        window.releasedWhenClosed = false
        window.title = "Overwatch Preferences"

        if let viewController = PreferencesViewController(nibName: "PreferencesViewController", bundle: nil) {
          window.contentViewController = viewController
          window.contentView = viewController.view
        }
      }
    }

    NSRunningApplication.currentApplication().activateWithOptions(.ActivateIgnoringOtherApps)
    self.preferencesWindow_?.makeKeyAndOrderFront(nil)
  }

  /**
    Show a popup asking the user to input a video URL.

    - Parameter invalid: Whether this popup is being shown after a previous invalid entry
    - Parameter value: The previously entered URL after an invalid entry
  */
  private func askForURL(invalid invalid: Bool = false, value: String = "") {
    let urlField = NSTextField(frame: CGRectMake(0, 0, 300, 20))
    let input = NSAlert()
    let message: String

    if (invalid) {
      message = "Sorry, that doesn't seem to be a YouTube video. Maybe try again?"
      urlField.stringValue = value
    } else {
      message = "Enter the URL of the YouTube video you want to watch:"
    }

    input.messageText = message
    input.addButtonWithTitle("OK")
    input.addButtonWithTitle("Cancel")
    input.accessoryView = urlField

    let result = input.runModal()
    switch(result) {
    case NSAlertFirstButtonReturn:
      let parser = URLParser(urlFragment: urlField.stringValue)

      if (parser.isYouTube()) {
        createVideoWindow(parser.url())
      } else {
        askForURL(invalid: true, value: urlField.stringValue)
      }
    default:
      break
    }
  }

  /**
    Handles the `overwatch://` URL scheme by checking the URL received is valid and then opening
    a window.
  */
  private func handleGetURLEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
    if var url = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
      url = url.stringByReplacingOccurrencesOfString("overwatch://", withString: "")
      let parser = URLParser(urlFragment: url)

      if (parser.isYouTube()) {
        createVideoWindow(parser.url())
      } else {
        let alert = NSAlert();
        alert.messageText = "Sorry, that doesn't seem to be a YouTube video :("
        alert.addButtonWithTitle("OK")
        alert.runModal()
      }
    }
  }

  /**
    Gets a string from the clipboard (if available).

    - Returns: The first string on the clipboard or nil.
  */
  private func getClipboardString() -> String? {
    if let items = NSPasteboard.generalPasteboard().pasteboardItems {
      return items.first?.stringForType("public.utf8-plain-text")
    } else {
      return nil
    }
  }
}

