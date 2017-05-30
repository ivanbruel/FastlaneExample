//
//  RepositoriesViewModel.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import Foundation
import RxSwift
import RxResult
import Moya_ObjectMapper
import Result

struct RepositoriesViewModel {

  // MARK: - Private Properties
  fileprivate let networking: GitHubNetworking
  fileprivate let _items: Variable<[RepositoryItemViewModel]>

  // MARK: - Public Properties
  var items: Observable<[RepositoryItemViewModel]> {
    return _items.asObservable()
  }

  // MARK: - Initializer
  init(networking: GitHubNetworking) {
    self.networking = networking
    self._items = Variable([])
  }
}

// MARK: - Networking
extension RepositoriesViewModel {

  func getRepositories(username: String?) -> Observable<Result<Void, RepositoriesError>> {
    guard let username = username, !username.isEmpty else {
      return Observable.error(RepositoriesError.emptyUsername)
    }
    return networking.request(.userRepositories(username))
      .filterSuccessfulStatusCodes()
      .mapArray(Repository.self)
      .map { repositories in
        return repositories.sorted(by: { (lhs, rhs) -> Bool in
          return lhs.stargazersCount > rhs.stargazersCount
        })
      }
      .do(onNext: { self._items.value = $0.map { RepositoryItemViewModel(repository: $0) } })
      .map { _ in Void() }
      .mapResult(RepositoriesError.self)
  }
}
