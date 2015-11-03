//
//  VideoWindowsDisplay.swift
//  Overwatch
//
//  Created by adam on 10/20/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Foundation
import Cocoa

/**
  Handles displaying all the video windows
*/
class VideoWindowsDisplay : VideoWindowDelegate {
  /// List of windows in the container
  var windows: [VideoWindow] {
    return self.windows_
  }
  /// The opacity of the display
  var opacity: Float = 1.0 {
    didSet {
      for window in self.windows {
        window.opacity = self.opacity
      }
    }
  }
  /// Whether or not to become opaque on hover
  var opaqueOnHover = false {
    didSet {
      for window in self.windows {
        window.opaqueOnHover = self.opaqueOnHover
      }
    }
  }
  /// Whether or not to show viedos on all Spaces
  var appearOnAllSpaces = false {
    didSet {
      for window in self.windows {
        window.appearOnAllSpaces = self.appearOnAllSpaces
      }
    }
  }
  // MARK: Private Variables
  private var windows_ = [VideoWindow]()

  // MARK: - Initialisation

  init() {
    let defaults = NSUserDefaults.standardUserDefaults()

    self.appearOnAllSpaces = defaults.boolForKey(DefaultsKeys.AppearOnAllSpaces)
    self.opaqueOnHover = defaults.boolForKey(DefaultsKeys.OpaqueOnHover)
    self.opacity = defaults.floatForKey(DefaultsKeys.VideoOpacity)
  }

  // MARK: - Public Functions

  /**
    Adds a window to the display, automatically showing it on the screen.

    - Parameter window: The video window to be added.
  */
  func add(window: VideoWindow) {
    window.index = self.windows_.count
    window.delegate = self
    window.opacity = self.opacity
    window.opaqueOnHover = self.opaqueOnHover
    window.appearOnAllSpaces = self.appearOnAllSpaces

    self.windows_.append(window)
    window.show()
    // Activate the app to give the new window focus (this is questionable and might become an option later).
    NSRunningApplication.currentApplication().activateWithOptions(.ActivateIgnoringOtherApps)
  }

  // MARK: - VideoWindowDelegate Functions

  func windowWillClose(window: VideoWindow) {
    // Find the window and remove it, thus releasing the underlying
    // NSWindow and NSWindowController
    if let index = self.windows_.indexOf(window) {
      self.windows_.removeAtIndex(index)
    }
  }
}
