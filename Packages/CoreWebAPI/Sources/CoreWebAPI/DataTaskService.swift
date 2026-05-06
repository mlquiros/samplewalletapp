//
//  DataTaskService.swift
//  CoreWebAPI
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Foundation

/// Defines a web service endpoint that is meant to be executed as a `URLSessionDataTask`.
public protocol DataTaskService {
  
  
  
  // MARK: - Creating a request
  
  /// Contains the parameters that will be sent to the request.
  ///
  /// Call sites should not assume how the parameters will be added into the
  /// request. Whether the values will be inserted as inline query items or
  /// within the request body may change over time.
  associatedtype Parameters
  
  /// Creates a fully-assembled `URLRequest` for a `URLSession` to run as a data task.
  static func request(withParameters parameters: Parameters) throws -> URLRequest
  
  
  
  // MARK: - Success result
  
  /// The result produced by this service if a web service request succeeds.
  ///
  /// This type is not necessarily equivalent to the schema of the web
  /// service's JSON response. Often, it contains only information that
  /// the concrete type wishes to expose to its consumers.
  associatedtype Success
  
  /// Creates a success result based on a web service response and its payload.
  static func success(fromData data: Data, response: URLResponse) throws -> Success
  
}

extension DataTaskService {
  
  /// Asserts that the server returns a valid HTTP response with a status code of 200.
  @discardableResult
  public static func ensureHTTPResponseAndStatusCode200(
    _ response: URLResponse
  ) throws -> HTTPURLResponse {
    
    guard let response = response as? HTTPURLResponse else {
      throw NonHTTPURLResponse(response: response)
    }
    
    guard response.statusCode == 200 else {
      throw UnexpectedHTTPStatusCode(httpResponse: response)
    }
    
    return response
  }
  
}
