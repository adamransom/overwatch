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
class VideoWindowsContainer {
  /// List of windows in the container
  var windows: [VideoWindow] {
    return self.windows_
  }

  private var windows_ = [VideoWindow]()

  /**
    Adds a window to the container, automatically showing it on the screen.

    - Parameter window: The video window to be added.
  */
  func add(window: VideoWindow) {
    window.index = self.windows_.count
    self.windows_.append(window)
    window.show()
  }
}
