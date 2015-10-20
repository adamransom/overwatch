//
//  VideoWindowsContainerTests.swift
//  Overwatch
//
//  Created by adam on 10/20/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Cocoa
import XCTest

@testable import Overwatch

class VideoWindowsContainerTests: XCTestCase {
  var subject: VideoWindowsContainer?

  override func setUp() {
    super.setUp()

    subject = VideoWindowsContainer()
  }

  func testThatItAddsVideoWindow() {
    if let window = VideoWindow(url: "") {
      subject!.add(window)
      XCTAssertEqual(subject!.windows.first, window)
    }
  }
}
