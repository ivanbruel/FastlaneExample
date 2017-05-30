//
//  RepositoriesError.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import Foundation
import RxResult

enum RepositoriesError: RxResultError {

  case emptyUsername
  case networkError

  static func failure(from error: Error) -> RepositoriesError {
    return .networkError
  }

  var message: String {
    switch self {
    case .emptyUsername:
      return NSLocalizedString("repositories.error.empty_username", comment: "Empty username error")
    case .networkError:
      return NSLocalizedString("repositories.error.network", comment: "Network error")
    }
  }
}
