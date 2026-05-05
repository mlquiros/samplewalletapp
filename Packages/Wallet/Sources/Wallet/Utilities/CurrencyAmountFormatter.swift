//
//  CurrencyAmountFormatter.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Foundation

final class CurrencyAmountFormatter: NumberFormatter {
  
  /// - Parameters:
  ///   - currencyCode: The ISO 4217 currency code in which the amount is
  ///     denominated, e.g. "PHP" or "USD".
  init(currencyCode: String = "PHP") {
    super.init()
    numberStyle = .currency
    minimumFractionDigits = 2
    maximumFractionDigits = 2
    self.currencyCode = currencyCode
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Using a shared instance
  
  static let shared = CurrencyAmountFormatter()
  
  static func shared(
    usingCurrencyCode currencyCode: String
  ) -> CurrencyAmountFormatter {
    shared.currencyCode = currencyCode
    return shared
  }
  
}
