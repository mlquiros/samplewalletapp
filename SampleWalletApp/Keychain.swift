//
//  Keychain.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Foundation
import Security
import OSLog

final class Keychain {
  
  static let shared = Keychain()
  private init() { }
  
  private let serviceID = "software.mlq.SampleWalletApp"
  private let account = "userSession"
  private let logger = Logger(subsystem: "SampleWalletApp", category: "Keychain")
  
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
      
      // Attempt decoding and return the cached session.
      if status == errSecSuccess,
         let data = dataTypeRef as? Data {
        return try? JSONDecoder().decode(Session.self, from: data)
      }
      return nil
    }
    
    set {
      // If setting to nil, delete the cached session.
      guard let newValue else {
        deleteSession()
        return
      }
      
      guard let data = try? JSONEncoder().encode(newValue) else { return }
      
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: serviceID,
        kSecAttrAccount as String: account
      ]
      let attributesToUpdate: [String: Any] = [
        kSecValueData as String: data
      ]
      
      let status = SecItemUpdate(
        query as CFDictionary,
        attributesToUpdate as CFDictionary)
      
      switch status {
        
      case errSecItemNotFound:
        var addQuery = query
        addQuery[kSecValueData as String] = data
        addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
        if addStatus != errSecSuccess {
          logger.debug("Failed to save session to keychain: \(addStatus)")
        }
        
      case errSecSuccess:
        logger.debug("Succeeded saving session to keychain: \(status)")
        
      default:
        logger.debug("Failed to save session to keychain: \(status)")
      }
    }
  }
  
  private func deleteSession() {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceID,
      kSecAttrAccount as String: account
    ]
    SecItemDelete(query as CFDictionary)
  }
  
}
