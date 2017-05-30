//
//  RepositoryItemViewModelTests.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import XCTest
import ObjectMapper

class RepositoryItemViewModelTests: XCTestCase {

  lazy var repositories: [Repository] = {
    guard let jsonString = JSONReader.string(fromFile: "ivanbruel") else { return [] }
    return (try? Mapper<Repository>().mapArray(JSONString: jsonString)) ?? []
  }()

  lazy var fastlaneExample: Repository = {
    return self.repositories.first { repository -> Bool in
      return repository.name == "FastlaneExample"
      }!
  }()

  lazy var viewModel: RepositoryItemViewModel = {
    return RepositoryItemViewModel(repository: self.fastlaneExample)
  }()

  func testStars() {
    XCTAssert(viewModel.stars == "0 ⭐️")
  }

  func testName() {
    XCTAssert(viewModel.name == "FastlaneExample")
  }

  func testURL() {
    XCTAssert(viewModel.url.absoluteString == "https://github.com/ivanbruel/FastlaneExample")
  }
}
