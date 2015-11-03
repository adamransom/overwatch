//
//  VideoViewControllerDelegate.swift
//  Overwatch
//
//  Created by adam on 10/21/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Foundation

protocol VideoViewControllerDelegate : class {
  /**
    Tells the delegate that the mouse entered the view.
  */
  func mouseEntered()

  /**
    Tells the delegate that the mouse left the view.
  */
  func mouseExited()

  /**
    Tells the delegate that the Option key was pressed
  */
  func optionPressed()

  /**
    Tells the delegate that the Option key was released
  */
  func optionReleased()
}