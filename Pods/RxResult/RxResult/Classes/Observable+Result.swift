//
//  Observable+Result.swift
//
//  Created by Ivan Bruel on 03/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift
import Result

public protocol RxResultError: Error {
  static func failure(from error: Error) -> Self
}

public extension ObservableType {
  
  public func mapResult<U: RxResultError>(_ errorType: U.Type) -> Observable<Result<E, U>> {
    return self.map(Result<E, U>.success)
      .catchError{ error in
        if let error = error as? U {
            return .just(Result.failure(error))
        }
        return .just(Result.failure(U.failure(from: error))) }
    }
}

public extension ObservableType where E: ResultProtocol {

  public func `do`(onSuccess: (@escaping (Self.E.Value) throws -> Void))
    -> Observable<E> {
      return `do`(onNext: { (value) in
        guard let successValue = value.value else {
          return
        }
        try onSuccess(successValue)
      })
  }

  public func `do`(onFailure: (@escaping (Self.E.Error) throws -> Void))
    -> Observable<E> {
      return `do`(onNext: { (value) in
        guard let failureValue = value.error else {
          return
        }
        try onFailure(failureValue)
      })
  }

  public func subscribeResult(onSuccess: ((Self.E.Value) -> Void)? = nil,
                              onFailure: ((Self.E.Error) -> Void)? = nil) -> Disposable {
    return subscribe(onNext: { value in

      if let successValue = value.value {
        onSuccess?(successValue)
      } else if let errorValue = value.error {
        onFailure?(errorValue)
      }
    })
  }
}
