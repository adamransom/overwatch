//
//  VideoWindowDelegate.swift
//  Overwatch
//
//  Created by adam on 10/20/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Foundation

protocol VideoWindowDelegate {
  /**
    Tells the delegate that the window is about to close.

    - Parameter window: The window that is about to close.
  */
  func windowWillClose(window: VideoWindow)
}