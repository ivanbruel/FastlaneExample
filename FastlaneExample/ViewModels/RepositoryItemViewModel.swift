//
//  RepositoryItemViewModel.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import Foundation

struct RepositoryItemViewModel {

  let name: String
  let stars: String
  let url: URL

  init(repository: Repository) {
    self.name = repository.name
    self.stars = "\(repository.stargazersCount) ⭐️"
    self.url = repository.htmlURL
  }
}
