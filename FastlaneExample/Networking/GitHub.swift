import Foundation
import Moya

enum GitHub {
  case userProfile(String)
  case userRepositories(String)
}

extension GitHub: TargetType {

  var baseURL: URL { return URL(string: "https://api.github.com")! }

  var path: String {
    switch self {
    case .userProfile(let name):
      return "/users/\(name.urlEscaped)"
    case .userRepositories(let name):
      return "/users/\(name.urlEscaped)/repos"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var parameters: [String: Any]? {
    switch self {
    case .userRepositories(_):
      return ["sort": "pushed"]
    default:
      return nil
    }
  }

  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  var task: Task {
    return .request
  }

  var validate: Bool {
    return false
  }

  var sampleData: Data {
    switch self {
    case .userProfile(let name):
      return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
    case .userRepositories(_):
      return JSONReader.data(fromFile: "ivanbruel") ?? Data()
    }
  }
}
