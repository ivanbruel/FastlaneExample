//
//  JSONSerialization+Transpilers.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import Foundation
import ObjectMapper

class JSONReader {

  class func string(withData jsonData: Data?) -> String? {
    guard let jsonData = jsonData else { return nil }
    return String(data: jsonData, encoding: .utf8)
  }

  class func data(fromFile filename: String) -> Data? {
    guard let path = Bundle(for: self).path(forResource: filename, ofType: "json") else {
      return nil
    }
    return try? Data(contentsOf: URL(fileURLWithPath: path),
                     options: NSData.ReadingOptions.mappedIfSafe)
  }

  class func string(fromFile filename: String) -> String? {
    return JSONReader.string(withData: data(fromFile: filename))
  }
}
