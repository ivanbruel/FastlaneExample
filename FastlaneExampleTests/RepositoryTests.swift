//
//  FastlaneExampleTests.swift
//  FastlaneExampleTests
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import XCTest
import ObjectMapper

class RepositoryTests: XCTestCase {

  lazy var repositories: [Repository] = {
    guard let jsonString = JSONReader.string(fromFile: "ivanbruel") else { return [] }
    return (try? Mapper<Repository>().mapArray(JSONString: jsonString)) ?? []
  }()

  lazy var fastlaneExample: Repository = {
    return self.repositories.first { repository -> Bool in
      return repository.name == "FastlaneExample"
      }!
  }()

  lazy var fastlane: Repository = {
    return self.repositories.first { repository -> Bool in
      return repository.name == "fastlane"
      }!
  }()

  func testIsSwift() {
    XCTAssert(fastlaneExample.isSwift)
  }

  func testIsNotSwift() {
    XCTAssert(!fastlane.isSwift)
  }

}
