//
//  UserDefaults+Controller.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation
import Wallet

extension UserDefaults {
  
  /// An object that performs tasks to keep the local cache updated.
  final class Controller {
    
    static let shared = Controller()
    
    private init() {
      observeWalletDidUpdate()
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
