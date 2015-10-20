//
//  VideoWindow.swift
//  Overwatch
//
//  Created by adam on 10/20/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Foundation
import Cocoa

/**
  Represents one video, hovering over the desktop. A wrapper around
  NSWindowController and NSWindow.
*/
class VideoWindow {
  /// The URL of the video for the window
  var url: String
  /// The index of the window in its container
  var index: Int? {
    get { return self.index_ }
    set {
      self.index_ = newValue
      self.controller_!.windowFrameAutosaveName = "overwatch_video_\(newValue!)"
      updateFrame();
    }
  }

  private let mask = NSTitledWindowMask |
                     NSFullSizeContentViewWindowMask |
                     NSResizableWindowMask |
                     NSClosableWindowMask

  private var controller_: NSWindowController?
  private var window_: NSWindow?
  private var index_: Int?

  /**
    Creates a new VideoWindow.
    
    - Parameter url: The URL of the video to show in the window.
  */
  init?(url: String) {
    self.url = url

    createWindow()
    createController()

    if (self.window_ == nil || self.controller_ == nil) {
      return nil
    }
  }

  /**
    Shows the window.
  */
  func show() {
    self.window_!.makeKeyWindow()
    self.controller_!.showWindow(nil)
  }

  /**
    Moves the window to its default position.
  */
  func resetPosition() {
    self.window_!.setFrame(defaultFrame(), display: false)
  }

  /**
    Creates and sets up the NSWindow.
  */
  private func createWindow() {
    self.window_ = NSWindow(
      contentRect: defaultFrame(),
      styleMask: self.mask,
      backing: .Buffered,
      `defer`: true
    )

    // Set up the titlebar
    if (self.window_ != nil) {
      self.window_!.titlebarAppearsTransparent = true
      self.window_!.movableByWindowBackground = true
      self.window_!.standardWindowButton(.ZoomButton)?.hidden = true
      self.window_!.standardWindowButton(.MiniaturizeButton)?.hidden = true

      // Add the VideoViewcontroller
      if let viewController = VideoViewController(nibName: nil, bundle: nil) {
        viewController.url = NSURL(string: self.url)
        viewController.view.frame = (self.window_!.contentView! as NSView).bounds
        self.window_!.contentView!.addSubview(viewController.view)
      }
    }
  }

  /**
    Creates and sets up the NSWindowController.
  */
  private func createController() {
    self.controller_ = NSWindowController(window: self.window_)
  }

  /**
    Updates the window frame to the last know position for the windows
    index or the default frame.
  */
  private func updateFrame() {
    if (!self.window_!.setFrameUsingName("overwatch_video_\(self.index_!)")) {
      self.window_!.setFrame(defaultFrame(), display: false)
    }
  }

  /**
    Calculates the default frame based on the window's index.

    - Returns: CGRect representing the default frame.
  */
  private func defaultFrame() -> CGRect {
    // Default to a 16:9 ratio for YouTube
    let width: CGFloat = 400
    let height: CGFloat = 225
    var x: CGFloat = 0
    var y: CGFloat = 0
    let padding: CGFloat = 20

    if (self.index_ != nil) {
      // Default to top-right, with multiple windows stacking below
      if let screen = NSScreen.mainScreen() {
        x = screen.visibleFrame.width - width - padding
        y = screen.visibleFrame.height - (height + padding) * CGFloat(self.index_! + 1)
      }
    }

    return CGRectMake(x, y, width, height)
  }
}
