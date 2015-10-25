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

  @IBOutlet weak var statusMenu: NSMenu!
  @IBOutlet weak var menuOpenClipboard: NSMenuItem!

  var videoWindows = VideoWindowsDisplay()
  var preferencesWindow: NSWindow?

  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

  func applicationWillFinishLaunching(aNotification: NSNotification) {
    // Handle URL scheme (overwatch://)
    let appleEventManager:NSAppleEventManager = NSAppleEventManager.sharedAppleEventManager()
    appleEventManager.setEventHandler(
      self,
      andSelector: "handleGetURLEvent:replyEvent:",
      forEventClass: AEEventClass(kInternetEventClass),
      andEventID: AEEventID(kAEGetURL)
    )
  }

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let icon = NSImage(named: "StatusIcon")
    icon?.template = true

    statusItem.image = icon
    statusItem.menu = statusMenu

    observeUserDefault("video_opacity")
    observeUserDefault("opaque_on_hover")

    // Register user defaults
    let appDefaults = [
      "video_opacity": NSNumber(float: 1.0),
      "opaque_on_hover": false
    ]
    NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


  // MARK: - NSObject Functions

  override func observeValueForKeyPath(
    keyPath: String?,
    ofObject object: AnyObject?,
    change: [String : AnyObject]?,
    context: UnsafeMutablePointer<Void>
  ) {
    if (keyPath != nil && change != nil) {
      switch keyPath! {
      case "video_opacity":
        self.videoWindows.opacity = Float(change!["new"] as! NSNumber)
        break
      case "opaque_on_hover":
        self.videoWindows.opaqueOnHover = change!["new"] as! Bool
        break
      default:
        break
      }
    }
  }

  func handleGetURLEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
    if var url = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
      url = url.stringByReplacingOccurrencesOfString("overwatch://", withString: "")
      let parser = URLParser(urlFragment: url)

      if (parser.isYouTube()) {
        createWindow(parser.url())
      } else {
        let alert = NSAlert();
        alert.messageText = "Sorry, that doesn't seem to be a YouTube video :("
        alert.addButtonWithTitle("OK")
        alert.runModal()
      }
    }
  }

  override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
    // Only enable "Open from Clipboard..." if there is a
    // YouTube URL on the clipboard
    if (menuItem == menuOpenClipboard) {
      let clipboard = NSPasteboard.generalPasteboard();

      if let items = clipboard.pasteboardItems {
        let urlFragment = items[0].stringForType("public.utf8-plain-text")
        if (urlFragment != nil) {
          return URLParser(urlFragment: urlFragment!).isYouTube()
        } else {
          return false
        }
      }
    }

    return true
  }

  @IBAction func actionPreferences(sender: NSMenuItem) {
    if self.preferencesWindow == nil {
      self.preferencesWindow = NSWindow(
        contentRect: NSMakeRect(0, 0, 300, 98),
        styleMask: NSTitledWindowMask | NSClosableWindowMask,
        backing: .Buffered,
        `defer`: true
      )

      if let window = self.preferencesWindow {
        window.center()
        window.releasedWhenClosed = false
        window.title = "Overwatch Preferences"

        if let viewController = PreferencesViewController(nibName: "PreferencesViewController", bundle: nil) {
          window.contentViewController = viewController
          self.preferencesWindow!.contentView = viewController.view
        }
      }
    }

    NSRunningApplication.currentApplication().activateWithOptions(.ActivateIgnoringOtherApps)
    self.preferencesWindow!.makeKeyAndOrderFront(nil)
  }

  @IBAction func actionOpenURL(sender: NSMenuItem) {
    askForURL()
  }

  @IBAction func actionOpenClipboard(sender: NSMenuItem) {
    let clipboard = NSPasteboard.generalPasteboard();

    if let items = clipboard.pasteboardItems {
      let urlFragment = items[0].stringForType("public.utf8-plain-text")
      if (urlFragment != nil) {
        let parser = URLParser(urlFragment: urlFragment!)

        if (parser.isYouTube()) {
          createWindow(parser.url())
        }
      }
    }
  }

  @IBAction func actionResetPositions(sender: NSMenuItem) {
    for window in videoWindows.windows {
      window.resetPosition()
    }
  }

  /*
   * Create a new video window
   */
  func createWindow(url: String?) {
    if (url == nil) { return }

    if let window = VideoWindow(url: url!) {
      videoWindows.add(window)
    }
  }

  func askForURL(invalid invalid: Bool = false, value: String = "") {
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
        createWindow(parser.url()!)
      } else {
        askForURL(invalid: true, value: urlField.stringValue)
      }
    default:
      break
    }
  }

  func observeUserDefault(keyPath: String) {
    NSUserDefaults.standardUserDefaults().addObserver(
      self,
      forKeyPath: keyPath,
      options: .New,
      context: nil
    )
  }

}

