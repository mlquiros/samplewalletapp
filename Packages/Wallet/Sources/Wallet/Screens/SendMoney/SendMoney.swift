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
  
  static func dataTaskSuccess(
    withParameters parameters: Parameters
  ) async throws -> Success {
    
    // Fake a network latency
    try await Task.sleep(nanoseconds: 2_000_000)
    
    // Perform proxy logic for a web service for sending money.
    // First, validate.
    
    // Currencies must match.
    guard parameters.amountToSend.currencyCode ==
            parameters.walletBalance.currencyCode
    else {
      throw CurrencyMismatch(
        amountCurrencyCode: parameters.amountToSend.currencyCode,
        walletCurrencyCode: parameters.walletBalance.currencyCode)
    }
    
    // The user must have enough balance.
    guard parameters.walletBalance.amount >= parameters.amountToSend.amount else {
      throw InsufficientBalance()
    }
    
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
  
  private struct CurrencyMismatch: LocalizedError {
    let amountCurrencyCode: String
    let walletCurrencyCode: String
    var errorDescription: String? {
      "Currency mismatch: Sending \(amountCurrencyCode) from wallet in \(walletCurrencyCode)"
    }
  }
  
  private struct InsufficientBalance: LocalizedError {
    var errorDescription: String? { "Insufficient balance" }
  }
  
}
