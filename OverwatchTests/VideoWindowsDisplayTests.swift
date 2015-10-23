//
//  VideoWindowsDisplayTests.swift
//  Overwatch
//
//  Created by adam on 10/20/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Cocoa
import XCTest

@testable import Overwatch

class VideoWindowsDisplayTests: XCTestCase {
  func testThatItAddsVideoWindow() {
    let subject = VideoWindowsDisplay()

    if let window = VideoWindow(url: "") {
      subject.add(window)
      XCTAssertEqual(subject.windows.first, window)
    }
  }

  func testThatItRemovesWhenWindowCloses() {
    let subject = VideoWindowsDisplay()

    if let window = VideoWindow(url: "") {
      subject.add(window)
      subject.windowWillClose(window)
      XCTAssertEqual(subject.windows.count, 0)
    }
  }
}
