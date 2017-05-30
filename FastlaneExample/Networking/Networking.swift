//
//  Networking.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Moya
import Alamofire

protocol NetworkingType {
  associatedtype Target: TargetType
  var provider: RxMoyaProvider<Target> { get }
}

struct GitHubNetworking: NetworkingType {
  typealias Target = GitHub
  let provider: RxMoyaProvider<GitHub>
}

// MARK: - API
extension NetworkingType {
  func request(_ target: Target) -> Observable<Moya.Response> {
    return provider.request(target)
  }
}

extension GitHubNetworking {
  static func newNetworking() -> GitHubNetworking {
    return GitHubNetworking(provider: newProvider(plugins: plugins))
  }

  static func newStubbedNetworking() -> GitHubNetworking {
    return GitHubNetworking(provider: newStubProvider())
  }
}

// MARK: - Private
extension NetworkingType {

  fileprivate static func newProvider<T>(plugins: [PluginType])
    -> RxMoyaProvider<T> where T: TargetType {
      return RxMoyaProvider(
        endpointClosure: endpointClosure(),
        plugins: plugins)
  }

  fileprivate static func newStubProvider<T>() -> RxMoyaProvider<T> where T: TargetType {
    return RxMoyaProvider(endpointClosure: endpointClosure(),
                          stubClosure: MoyaProvider.immediatelyStub)
  }

  private static func endpointClosure<T>()
    -> (T) -> Endpoint<T> where T: TargetType {
      return { target in
        let endpoint = Endpoint<T>(url: target.baseURL.appendingPathComponent(target.path).absoluteString,
                                   sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                   method: target.method,
                                   parameters: target.parameters,
                                   parameterEncoding: target.parameterEncoding)
        return endpoint
      }
  }

  fileprivate static var plugins: [PluginType] {
    return [
      NetworkLoggerPlugin(verbose: true, cURL: true, output: networkPrint, responseDataFormatter: jsonFormatter)
    ]
  }

  private static func jsonFormatter(data: Data) -> Data {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
      return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    } catch {
      return data
    }
  }

  private static func networkPrint(separator: String, terminator: String, items: Any...) {
    items.forEach { item in
      print("\n\(String(describing: item))")
    }
  }
}
