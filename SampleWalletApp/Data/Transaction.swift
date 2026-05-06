//
//  Transaction.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

struct Transaction: Codable {
  
  let ID: String
  let date: Date
  let amount: Decimal
  let currencyCode: String
  
}
