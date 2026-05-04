//
//  Keychain.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Foundation
import Security

final class Keychain {
  
  static let shared = Keychain()
  private init() { }
  
  private let serviceID = "software.mlq.SampleWalletApp"
  private let account = "userSession"
  
  var session: Session? {
    get {
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: serviceID,
        kSecAttrAccount as String: account,
        kSecReturnData as String: true, // return the data instead of a reference
        kSecMatchLimit as String: kSecMatchLimitOne
      ]
      
      // Perform the query
      var dataTypeRef: AnyObject?
      let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
      
      if status == errSecSuccess,
         let data = dataTypeRef as? Data {
        return try? JSONDecoder().decode(Session.self, from: data)
      }
      return nil
    }
    
    set {
      
    }
  }
  
}
