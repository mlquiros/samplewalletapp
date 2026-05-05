//
//  CurrencyAmount.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Foundation

struct CurrencyAmount {
  
  let amount: Decimal
  
  /// The three-letter ISO 4217 currency code that the amount is
  /// denominated in, e.g. "PHP" or "USD".
  let currencyCode: String
  
}
