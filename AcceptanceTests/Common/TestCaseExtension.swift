//
//  TestCaseExtension.swift
//  AcceptanceTests
//
//  Created by German on 5/28/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import UIKit
import KIF

extension KIFTestCase {
  
  func checkDisabledButton(withAccessibilityLabel label: String) {
    do {
      try tester().tryFindingView(withAccessibilityLabel: label)
      do {
        try tester().tryFindingTappableView(withAccessibilityLabel: label)
        XCTFail("Could not find tappable view with identifier: " + label)
      } catch {
        return
      }
    } catch {
      XCTFail("Could not find view with identifier: " + label)
    }
  }
  
  func showErrorMessage() {
    tester().waitForView(withAccessibilityLabel: "Error")
    tester().tapView(withAccessibilityLabel: "Ok")
  }
}
