//
//  FastlaneExampleUITests.swift
//  FastlaneExampleUITests
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import XCTest

class FastlaneExampleUITests: XCTestCase {

  override func setUp() {
    super.setUp()
    continueAfterFailure = false

    let app = XCUIApplication()
    app.launchEnvironment = ["UI_TESTING": "true"]
    app.launch()
  }

  func testTableView() {
    let app = XCUIApplication()

    let fastlaneExample = app.tables.staticTexts["FastlaneExample"]
    XCTAssert(fastlaneExample.exists)

    XCTAssert(app.tables.cells.count == 30)
  }

  func testTitle() {
    let app = XCUIApplication()

    let title = app.navigationBars.staticTexts["ivanbruel"]
    XCTAssert(title.exists)
  }

}
