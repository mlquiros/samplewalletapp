//
//  WalletDidSendMoney.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

public enum WalletDidSendMoney {
  
  public static let notificationName = Notification.Name("WalletDidSendMoneyNotification")
  
  public static let userInfoKey = "WalletDidSendMoneyNotification.userInfoKey"
  
  public struct UserInfo {
    public let amount: Decimal
    public let currencyCode: String
    public let date: Date
  }
  
}
