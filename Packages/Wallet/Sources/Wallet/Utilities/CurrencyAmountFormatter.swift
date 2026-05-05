//
//  CurrencyAmountFormatter.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Foundation

final class CurrencyAmountFormatter: NumberFormatter {
  
  override init() {
    super.init()
    numberStyle = .currency
    minimumFractionDigits = 2
    maximumFractionDigits = 2
    
    // By default, the locale is set to the Philippines.
    locale = Locale(identifier: "en-ph")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
