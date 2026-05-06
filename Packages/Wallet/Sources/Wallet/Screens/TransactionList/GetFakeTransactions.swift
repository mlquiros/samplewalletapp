//
//  GetFakeTransactions.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation
import CoreWebAPI

/// Wraps the iTunes Search API and converts search results into mock transaction data.
enum GetFakeTransactions: DataTaskService {
  
  
  
  // MARK: - Creating a request
  
  struct Parameters {
    let limit: Int
    
    // We hide the below parameters because they aren't finance-related values.
    // Still, they will be sent in a request to the iTunes Search API.
    
    fileprivate let term = "rock"
    fileprivate let media = "music"
    fileprivate let entity = "album"
  }
  
  static func request(withParameters parameters: Parameters) throws -> URLRequest {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "itunes.apple.com"
    components.path = "/search"
    components.queryItems = [
      URLQueryItem(name: "term", value: parameters.term),
      URLQueryItem(name: "media", value: parameters.media),
      URLQueryItem(name: "entity", value: parameters.entity),
      URLQueryItem(name: "limit", value: "\(parameters.limit)")
    ]
    
    guard let url = components.url else {
      throw InvalidURLComponents(components: components)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    return request
  }
  
  
  
  // MARK: - Decoding the response
  
  private struct ResponseBody: Decodable {
    let results: [Result]
    struct Result: Decodable {
      let collectionType: String?
      let collectionPrice: Decimal?
      let releaseDate: String?
      let collectionViewUrl: String?
    }
  }
  
  
  // MARK: - Generating a success
  
  struct Success {
    
    let transactions: [Transaction]
    
    struct Transaction {
      let id: String
      let date: Date
      let amount: Decimal
      let currencyCode = "PHP" // a simplification
    }
    
  }
  
  static func success(fromData data: Data, response: URLResponse) throws -> Success {
    try ensureHTTPResponseAndStatusCode200(response)
    let responseBody = try JSONDecoder().decode(ResponseBody.self, from: data)
    let formatter = ISO8601DateFormatter()
    // Convert each result into a fake transaction.
    let transactions: [Success.Transaction] = responseBody.results.compactMap {
      
      // Ignore the results that don't have the required values.
      guard $0.collectionType?.lowercased() == "album",
            let collectionPrice = $0.collectionPrice,
            let dateString = $0.releaseDate,
            let date = formatter.date(from: dateString),
            let urlString = $0.collectionViewUrl
      else { return nil }
      
      return Success.Transaction(
        id: urlString,
        date: date,
        amount: collectionPrice
      )
    }
    
    let success = Success(transactions: transactions)
    return success
  }
  
  
}
