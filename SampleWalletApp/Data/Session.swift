//
//  Session.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Wallet

/// The session credentials of the currently authenticated user.
struct Session: Codable {
  
  let username: String
  let token: String
  
  /// Converts this model to the type for the Wallet domain.
  func convertToWalletType() -> Wallet.Session {
    return .init(username: username, token: token)
  }
  
}
