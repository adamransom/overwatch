//
//  OverwatchTests.swift
//  OverwatchTests
//
//  Created by adam on 10/18/15.
//  Copyright (c) 2015 Adam Ransom. All rights reserved.
//

import Cocoa
import XCTest

@testable import Overwatch

class URLParserTests: XCTestCase {
  let fragments = [
    "https://www.youtube.com/watch?autoplay=1&v=Fb6xOVdkaLM": "Fb6xOVdkaLM",
    "https://www.youtube.com/watch?v=Fb6xOVdkaLM": "Fb6xOVdkaLM",
    "https://www.youtube.com/watch?v=wrAVXKkIK_A": "wrAVXKkIK_A",
    "http://www.youtube.com/watch?v=qgszsGqevtk": "qgszsGqevtk",
    "https://www.youtube.com/embed/lvReN-poqDY": "lvReN-poqDY",
    "www.youtube.com/watch?v=qYOr8TlnqsY": "qYOr8TlnqsY",
    "youtube.com/watch?v=aemNes9y-3c": "aemNes9y-3c",
    "https://youtu.be/wpDmZVYC8KU?t=49": "wpDmZVYC8KU",
    "https://youtu.be/2CHV44WpKw4": "2CHV44WpKw4",
    "http://youtu.be/s2f9zFL0g1A": "s2f9zFL0g1A",
    "youtu.be/lKDHXolazEU": "lKDHXolazEU",
    "Xw2bTpyHGCE": "Xw2bTpyHGCE"
  ]

  // MARK: - YouTube Tests

  func testThatItAcceptsValidYouTubeURL() {
    // Test each YouTube URL type
    for (fragment, _) in fragments {
      let subject = URLParser(urlFragment: fragment)
      let isYouTube = subject.isYouTube();

      XCTAssertTrue(isYouTube)
    }
  }

  func testThatItRejectsInvalidYouTubeURL() {
    // Test a few invalid URLs
    let invalidFragments = [
      "https://vimeo.com/141812811",
      "justarandomstring"
    ]

    for fragment in invalidFragments {
      let subject = URLParser(urlFragment: fragment)
      let isYouTube = subject.isYouTube();

      XCTAssertFalse(isYouTube)
    }
  }

  func testThatItReturnsYouTubeEmbedURL() {
    // Test each YouTube URL type
    for (fragment, code) in fragments {
      let subject = URLParser(urlFragment: fragment)
      let url = subject.url();

      XCTAssertEqual(url, "https://www.youtube.com/embed/\(code)?autoplay=1&iv_load_policy=3&modestbranding=1&fs=0&showinfo=0")
    }
  }
}
