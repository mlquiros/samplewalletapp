//
//  UserDefaults+Controller.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation
import Wallet


import OSLog
private let logger = Logger(subsystem: "UserDefaults", category: "Controller")

extension UserDefaults {
  
  /// An object that performs tasks to keep the local cache updated.
  final class Controller {
    
    static let shared = Controller()
    
    private init() {
      observeWalletDidSendMoney()
      observeWalletDidUpdate()
    }
    
    
    // MARK: - Caching send money transactions
    
    private func observeWalletDidSendMoney() {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleWalletDidSendMoney(_:)),
        name: WalletDidSendMoney.notificationName,
        object: nil)
    }
    
    @objc private func handleWalletDidSendMoney(_ notification: Notification) {
      guard let userInfo = notification.userInfo?[WalletDidSendMoney.userInfoKey]
              as? WalletDidSendMoney.UserInfo
      else { return }
      
      // Create a new entry.
      let newTransaction = Transaction(
        ID: UUID().uuidString,
        date: userInfo.date,
        amount: userInfo.amount,
        currencyCode: userInfo.currencyCode)
      
      // Append the new entry to the cache, then save.
      var transactions = UserDefaults.standard.transactions
      transactions.append(newTransaction)
      UserDefaults.standard.transactions = transactions
      
      logger.debug("\(UserDefaults.standard.transactions)")
    }
    
    
    
    // MARK: - Wallet info
    
    private func observeWalletDidUpdate() {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleWalletDidUpdate),
        name: WalletDidUpdate.notificationName,
        object: nil)
    }
    
    @objc private func handleWalletDidUpdate(_ notification: Notification) {
      guard let userInfo = notification.userInfo?[WalletDidUpdate.userInfoKey]
              as? WalletDidUpdate.UserInfo
      else { return }
      
      // Persist the new balance.
      UserDefaults.standard.walletInfo = .init(
        balance: userInfo.balance,
        currencyCode: userInfo.currencyCode)
    }
    
  }
  
}
