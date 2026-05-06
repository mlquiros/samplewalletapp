//
//  CachedTransaction.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//


import Foundation

/// A transaction that was cached in the application layer.
public struct CachedTransaction {
  
  public let ID: String
  public let date: Date
  public let amount: Decimal
  public let currencyCode: String
  
  public init(ID: String, date: Date, amount: Decimal, currencyCode: String) {
    self.ID = ID
    self.date = date
    self.amount = amount
    self.currencyCode = currencyCode
  }
  
}
