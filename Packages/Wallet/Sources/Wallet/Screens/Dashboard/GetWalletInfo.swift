//
//  GetWalletInfo.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

/// Emulates a web service to fetch info about the current user's wallet.
enum GetWalletInfo {
  
  struct Parameters {
    let username: String
    let sessionToken: String
    let cachedWalletInfo: WalletInfo?
  }
  
  typealias Success = WalletInfo
  
  static func dataTaskSuccess(
    withParameters parameters: Parameters
  ) async throws -> Success {
    
    // Introduce a delay to mock latency and execution time from a web service.
    try await Task.sleep(nanoseconds: 2_000_000_000)
    
    // Produce the success result.
    if let cachedWalletInfo = parameters.cachedWalletInfo {
      return cachedWalletInfo
    }
    let walletInfo = WalletInfo(
      balance: .init(amount: 1000, currencyCode: "PHP"))
    return walletInfo
  }
  
}
