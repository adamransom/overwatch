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

  func testThatItSetsOpacityOfWindowsWhenChanged() {
    let subject = VideoWindowsDisplay()

    if let window = VideoWindow(url: "") {
      let newOpacity: Float = 0.5

      XCTAssertNotEqual(window.opacity, newOpacity)
      subject.add(window)
      subject.opacity = newOpacity
      XCTAssertEqual(window.opacity, newOpacity)
    }
  }

  func testThatItSetsOpacityOfWindowWhenAdded() {
    let subject = VideoWindowsDisplay()

    if let window = VideoWindow(url: "") {
      let newOpacity: Float = 0.5

      subject.opacity = newOpacity
      XCTAssertNotEqual(window.opacity, newOpacity)
      subject.add(window)
      XCTAssertEqual(window.opacity, newOpacity)
    }
  }

  func testThatItSetsOpaqueOnHoverOfWindowsWhenChanged() {
    let subject = VideoWindowsDisplay()

    if let window = VideoWindow(url: "") {
      XCTAssertNotEqual(window.opaqueOnHover, true)
      subject.add(window)
      subject.opaqueOnHover = true
      XCTAssertEqual(window.opaqueOnHover, true)
    }
  }

  func testThatItSetsOpaqueOnHoverOfWindowsWhenAdded() {
    let subject = VideoWindowsDisplay()

    if let window = VideoWindow(url: "") {
      subject.opaqueOnHover = true
      XCTAssertNotEqual(window.opaqueOnHover, true)
      subject.add(window)
      XCTAssertEqual(window.opaqueOnHover, true)
    }
  }

  func testThatItSetsAppearOnAllSpacesOfWindowsWhenChanged() {
    let subject = VideoWindowsDisplay()

    if let window = VideoWindow(url: "") {
      XCTAssertNotEqual(window.appearOnAllSpaces, true)
      subject.add(window)
      subject.appearOnAllSpaces = true
      XCTAssertEqual(window.appearOnAllSpaces, true)
    }
  }

  func testThatItSetsAppearOnAllSpacesOfWindowsWhenAdded() {
    let subject = VideoWindowsDisplay()

    if let window = VideoWindow(url: "") {
      subject.appearOnAllSpaces = true
      XCTAssertNotEqual(window.appearOnAllSpaces, true)
      subject.add(window)
      XCTAssertEqual(window.appearOnAllSpaces, true)
    }
  }
}
