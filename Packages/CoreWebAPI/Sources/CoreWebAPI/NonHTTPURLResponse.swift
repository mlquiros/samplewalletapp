//
//  NonHTTPURLResponse.swift
//  CoreWebAPI
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

public struct NonHTTPURLResponse: LocalizedError {
  
  public let response: URLResponse
  
  public var errorDescription: String? { "Server response is not a valid HTTP response." }
  
}
