//
//  URLParser.swift
//  Overwatch
//
//  Created by adam on 10/19/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Foundation

/**
  Takes a URL fragment of a video (a URL with or without http, www, etc.) and produces
  a full URL pointing to the video embed.
*/
class URLParser {
  // MARK: Private Variables
  private let codePattern_ = "[A-Za-z0-9_-]{11}"
  private var urlFragment_: String

  // MARK: - Initiation

  init(urlFragment: String) {
    self.urlFragment_ = urlFragment
  }

    // MARK: - Public Functions

  /**
    Checks whether the URL is from YouTube.

    - Returns: True if the URL is from YouTube, false if not.
  */
  func isYouTube() -> Bool {
    let pattern = "(((http(s?)://)?(www.)?((youtube.com/watch\\?(.*)v=)|youtu.be/|youtube.com/embed/)\(codePattern_))|^\(codePattern_)$)"

    let regex = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    let matches = regex.numberOfMatchesInString(self.urlFragment_,
      options: NSMatchingOptions(rawValue: 0),
      range: NSMakeRange(0, self.urlFragment_.characters.count)
    )

    return matches > 0;
  }

  /**
    Creates the full URL for the intial URL fragment.

    - Returns: A string of the full URL to the video.
  */
  func url() -> String? {
    // Create regex for pulling out video code
    let regex = try! NSRegularExpression(pattern: codePattern_, options: .CaseInsensitive)
    let match = regex.rangeOfFirstMatchInString(
      self.urlFragment_,
      options: NSMatchingOptions(rawValue: 0),
      range: NSMakeRange(0, self.urlFragment_.characters.count)
    )

    // If a match is found, grab the code
    if (match.location != NSNotFound) {
      // Convert to NSString for easy substring (we wont be using emojis)
      let string = self.urlFragment_ as NSString
      let videoCode = string.substringWithRange(match)

      return "https://www.youtube.com/embed/\(videoCode)?autoplay=1&iv_load_policy=3&modestbranding=1&fs=0&showinfo=0"
    }

    return nil
  }
}
