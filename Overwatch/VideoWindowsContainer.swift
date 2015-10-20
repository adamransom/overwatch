//
//  VideoWindowsContainer.swift
//  Overwatch
//
//  Created by adam on 10/20/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Foundation
import Cocoa

/**
  Keeps track of all the video windows currently loaded.
*/
class VideoWindowsContainer : VideoWindowDelegate {
  /// List of windows in the container
  var windows: [VideoWindow] {
    return self.windows_
  }

  private var windows_ = [VideoWindow]()

  func windowWillClose(window: VideoWindow) {
    // Find the window and remove it, thus releasing the underlying
    // NSWindow and NSWindowController
    if let index = self.windows_.indexOf(window) {
      self.windows_.removeAtIndex(index)
    }
  }

  /**
    Adds a window to the container, automatically showing it on the screen.

    - Parameter window: The video window to be added.
  */
  func add(window: VideoWindow) {
    window.index = self.windows_.count
    window.delegate = self
    self.windows_.append(window)
    window.show()
  }
}