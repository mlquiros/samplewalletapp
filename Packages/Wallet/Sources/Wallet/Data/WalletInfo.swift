//
//  WalletInfo.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Foundation

struct WalletInfo {
  
  struct Balance {
    let amount: Decimal
    let iso4217CurrencyCode: String
  }
  let balance: Balance
  
}
