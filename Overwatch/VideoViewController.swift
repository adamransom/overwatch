//
//  VideoViewController.swift
//  Overwatch
//
//  Created by adam on 10/18/15.
//  Copyright (c) 2015 Adam Ransom. All rights reserved.
//

import Cocoa
import WebKit

class VideoViewController: NSViewController, WKNavigationDelegate {
  // The URL to be loaded into the WKWebView
  var url: NSURL?
  // The delegate that will handle mouse movement
  weak var delegate: VideoViewControllerDelegate?
  // MARK: Private Variables
  private var webView_: WKWebView?
  private var optionPressed_ = false
  private var optionTimer_: NSTimer?

  // MARK: - Overrides
  override func loadView() {
    self.webView_ = WKWebView()
    self.webView_!.navigationDelegate = self
    self.webView_!.hidden = true

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
    // Start to the timer for polling the option key and then
    // fire immediately to check if the option key was held whilst
    // entering the window.
    optionTimer_ = NSTimer.scheduledTimerWithTimeInterval(
      0.1,
      target: self,
      selector: "pollOptionKey:",
      userInfo: nil,
      repeats: true
    )
    optionTimer_!.fire()
  }

  override func mouseExited(theEvent: NSEvent) {
    self.delegate?.mouseExited()
    optionReleased()
    optionTimer_?.invalidate()
  }

  // MARK: - Public Functions

  /**
    Cleans up anything which holds a reference to this
    view controller.
  */
  func cleanUp() {
    // The NSTimer holds a strong reference to the target, which in
    // this case is `self`, so it needs to be invalidated.
    self.optionTimer_?.invalidate()
  }

  /**
    Checks to see whether the option key is pressed each time the
    timer fires.

    - Parameter timer: The timer that fired.
  */
  func pollOptionKey(timer: NSTimer) {
    if (!optionPressed_ && NSEvent.modifierFlags().contains(.AlternateKeyMask)) {
      optionPressed()
    } else if (optionPressed_ && !NSEvent.modifierFlags().contains(.AlternateKeyMask)) {
      optionReleased()
    }
  }

  // MARK: - WKNavigationDelegate Functions

  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    self.webView_?.hidden = false
  }

  // MARK: - Private Functions

  /**
    Sets the option pressed state and notifies delegates.
  */
  private func optionPressed() {
    optionPressed_ = true
    self.delegate?.optionPressed()
  }

  /**
    Sets the option released state and notifies delegates.
  */
  private func optionReleased() {
    optionPressed_ = false
    self.delegate?.optionReleased()
  }
}