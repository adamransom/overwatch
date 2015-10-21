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

  var url: NSURL?
  private var webView: WKWebView?

  override func loadView() {
    webView = WKWebView()
    view = webView!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if (url != nil) {
      let req = NSURLRequest(URL: url!)
      webView?.loadRequest(req)
    }
  }
}
