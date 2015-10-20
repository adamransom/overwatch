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

  var videoWindows = VideoWindowsContainer()

  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let icon = NSImage(named: "StatusIcon")
    icon?.template = true

    statusItem.image = icon
    statusItem.menu = statusMenu
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
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
        }
      }
    }

    return true
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
          createWindow(parser.url()!)
        }
      }
    }
  }

  @IBAction func actionResetPositions(sender: NSMenuItem) {
    for window in videoWindows.windows {
      window.resetPosition()
    }
  }

  @IBAction func actionQuit(sender: NSMenuItem) {
    NSApplication.sharedApplication().terminate(self)
  }

  /*
   * Create a new video window
   */
  func createWindow(url: String) {
    if let window = VideoWindow(url: url) {
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

}

