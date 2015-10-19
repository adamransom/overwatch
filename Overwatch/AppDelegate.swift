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

  var videoWindows = [NSWindow]()
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

  @IBAction func actionOpenURL(sender: NSMenuItem) {
    askForURL()
  }

  @IBAction func actionResetPositions(sender: NSMenuItem) {
    for (index, window) in videoWindows.enumerate() {
      window.setFrame(frameForWindow(index), display: false, animate: true)
    }
  }

  @IBAction func actionQuit(sender: NSMenuItem) {
    NSApplication.sharedApplication().terminate(self)
  }

  /*
   * Create a new video window
   */
  func createWindow(url: String) {
    let windowIndex = videoWindows.count

    // Default position and size for window
    let frame = frameForWindow(windowIndex)

    // Create a new NSWindow with default properties
    let videoWindow = NSWindow(
      contentRect: frame,
      styleMask: NSTitledWindowMask | NSFullSizeContentViewWindowMask | NSResizableWindowMask | NSClosableWindowMask,
      backing: .Buffered,
      `defer`: false
    )

    // Style the window
    videoWindow.titlebarAppearsTransparent = true
    videoWindow.movableByWindowBackground = true
    videoWindow.standardWindowButton(.ZoomButton)?.hidden = true
    videoWindow.standardWindowButton(.MiniaturizeButton)?.hidden = true

    // Create a NSWindowController to manage the window
    let videoWindowController = NSWindowController(window: videoWindow)
    videoWindowController.windowFrameAutosaveName = "overwatch_video_window_\(windowIndex)"

    // If available, restore the last size and position of the window
    videoWindow.setFrameUsingName("overwatch_video_window_\(windowIndex)")

    // Create a new VideoViewController to display the video
    let videoViewController = VideoViewController(nibName: nil, bundle: nil)!
    videoViewController.url = NSURL(string: url)
    videoWindow.contentView!.addSubview(videoViewController.view)
    videoViewController.view.frame = (videoWindow.contentView! as NSView).bounds

    // Add the window the the global list of opened windows
    videoWindows.append(videoWindow)

    // Finally, show the window!
    videoWindow.makeKeyWindow()
    videoWindowController.showWindow(nil)
  }

  /*
   * Get the default position for a particlar window index
   */
  func frameForWindow(index: Int) -> CGRect {
    // Default to a 16:9 ratio for YouTube
    let width: CGFloat = 400
    let height: CGFloat = 225

    // Default to top-right, with multiple windows stacking below
    let padding: CGFloat = 20
    let x = (NSScreen.mainScreen()?.visibleFrame.width)! - width - padding
    let y = (NSScreen.mainScreen()?.visibleFrame.height)! - (height + padding) * CGFloat(index + 1)

    return CGRectMake(x, y, width, height)
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

