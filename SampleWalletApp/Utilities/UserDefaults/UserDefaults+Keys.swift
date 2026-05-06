//
//  UserDefaults+Keys.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

extension UserDefaults {
  
  enum Key: String, CaseIterable {
    case walletInfo
  }
  
  
  
  // MARK: - Logging out
  
  func clearAllKeys() {
    Key.allCases.forEach {
      UserDefaults.standard.removeObject(forKey: $0.rawValue)
    }
  }
  
}
