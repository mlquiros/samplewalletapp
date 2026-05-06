//
//  UserDefaults+Wallet.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

extension UserDefaults {
  
  var walletInfo: WalletInfo? {
    
    get {
      guard let data = data(forKey: Key.walletInfo.rawValue),
            let walletInfo = try? JSONDecoder().decode(WalletInfo.self, from: data)
      else { return nil }
      return walletInfo
    }
    
    set {
      if let newValue {
        guard let data = try? JSONEncoder().encode(newValue) else { return }
        set(data, forKey: Key.walletInfo.rawValue)
      } else {
        removeObject(forKey: Key.walletInfo.rawValue)
      }
    }
    
  }
  
}
