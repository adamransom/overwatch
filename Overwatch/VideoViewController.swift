//
//  VideoViewController.swift
//  Overwatch
//
//  Created by adam on 10/18/15.
//  Copyright (c) 2015 Adam Ransom. All rights reserved.
//

import Cocoa
import WebKit

class VideoViewController: NSViewController {
  // The URL to be loaded into the WKWebView
  var url: NSURL?
  // The delegate that will handle mouse movement
  weak var delegate: VideoViewControllerDelegate?
  // MARK: Private Variables
  private var webView_: WKWebView?

  // MARK: - Overrides
  override func loadView() {
    self.webView_ = WKWebView()
    view = self.webView_!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let trackingArea = NSTrackingArea(
      rect: self.view.bounds,
      options: [.MouseEnteredAndExited, .ActiveAlways, .InVisibleRect],
      owner: self,
      userInfo: nil
    )
    self.view.addTrackingArea(trackingArea)

    if (url != nil) {
      let req = NSURLRequest(URL: url!)
      self.webView_?.loadRequest(req)
    }
  }

  override func mouseEntered(theEvent: NSEvent) {
    self.delegate?.mouseEntered()
  }

  override func mouseExited(theEvent: NSEvent) {
    self.delegate?.mouseExited()
  }
}