//
//  SendMoney.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Foundation

enum SendMoney {
  
  struct Parameters {
    let amountToSend: CurrencyAmount
    let walletBalance: CurrencyAmount
  }
  
  struct Success {
    let amountSent: CurrencyAmount
    let walletBalance: CurrencyAmount
  }
  
  /// Imitates a web service request to send money.
  /// For demo purposes, this proxy function always succeeds.
  static func dataTaskSuccess(
    withParameters parameters: Parameters
  ) async throws -> Success {
    
    // Fake the response time from a web service.
    try await Task.sleep(nanoseconds: 2_000_000_000)
    
    // Compute the new wallet balance.
    let newWalletBalance = CurrencyAmount(
      amount: parameters.walletBalance.amount - parameters.amountToSend.amount,
      currencyCode: parameters.walletBalance.currencyCode)
    
    // Create a success result.
    let success = Success(
      amountSent: parameters.amountToSend,
      walletBalance: newWalletBalance)
    return success
  }
  
  
  
  // MARK: - Errors
  
}
