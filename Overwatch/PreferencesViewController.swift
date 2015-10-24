//
//  PreferencesViewController.swift
//  Overwatch
//
//  Created by adam on 10/23/15.
//  Copyright © 2015 Adam Ransom. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
  @IBAction func actionDone(sender: NSButton) {
    self.view.window?.close()
  }
}