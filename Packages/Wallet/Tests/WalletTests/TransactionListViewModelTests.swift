//
//  TransactionListViewModelTests.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation
import XCTest
@testable import Wallet
import Combine
import CoreWebAPI

final class TransactionListViewModelTests: XCTestCase {
  
  private var cancellables = Set<AnyCancellable>()
  private var modelController: TransactionListViewModelController?
  
  override func setUp() {
    cancellables.forEach { $0.cancel() }
    cancellables = []
    modelController = nil
  }
  
  @MainActor
  func test_ifResponseIs500_thenModelShouldHoldUnexpectedHTTPStatusCodeError() {
    
    // Set up the mock response.
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    let session = URLSession(configuration: config)
    MockURLProtocol.handler = { _ in
      let urlResponse = HTTPURLResponse(
        url: URL(string: "https://sample-url.com")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil)!
      return (nil, urlResponse)
    }
    
    // Prepare the test.
    
    let modelController = TransactionListViewModelController(
      cachedTransactions: [
        .init(ID: "sample-id", date: Date(), amount: 5, currencyCode: "PHP")
      ],
      urlSession: session
    )
    let model = modelController.model
    self.modelController = modelController
    
    let expectation = expectation(description: #function)
    
    model.$error
      .receive(on: DispatchQueue.main)
      .sink { error in
        guard let error else { return }
        XCTAssert(error is UnexpectedHTTPStatusCode)
        XCTAssertEqual(
          500,
          (error as? UnexpectedHTTPStatusCode)?.httpResponse.statusCode
        )
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // Execute the test.
    modelController.attemptFetchingTransactions()
    wait(for: [expectation], timeout: 10)
  }
  
}


// MARK: -

fileprivate final class MockURLProtocol: URLProtocol {
  
  nonisolated(unsafe) static var handler: ((URLRequest) throws -> (Data?, HTTPURLResponse))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    do {
      guard let handler = Self.handler else {
        client?.urlProtocolDidFinishLoading(self)
        return
      }
      
      // Produce response components from handler
      let (data, response) = try handler(request)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      if let data {
        client?.urlProtocol(self, didLoad: data)
      }
      client?.urlProtocolDidFinishLoading(self)
      
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  override func stopLoading() {
    
  }
  
}
