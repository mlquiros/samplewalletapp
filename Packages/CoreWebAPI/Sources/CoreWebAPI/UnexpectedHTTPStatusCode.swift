//
//  UnexpectedHTTPStatusCode.swift
//  CoreWebAPI
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

public struct UnexpectedHTTPStatusCode: LocalizedError {
  
  public let httpResponse: HTTPURLResponse
  
  public var errorDescription: String? {
    "Unexpected HTTP status code: \(httpResponse.statusCode)"
  }
  
}
