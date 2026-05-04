//
//  Keychain.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Foundation

/// Manages values stored in the secure keychain.
///
/// This type cannot be initialized. Use the ``shared`` instance and simply
/// invoke the value that you need.
///
/// For example, to fetch and save a user's session credentials:
///
/// ```swift
/// // Determine whether there is a cached session.
/// if let session = Keychain.shared.session {
///   // Show the account details of the current user.
/// }
///
/// // If there is no session, login then cache the session.
/// else {
///   let session = performLogin()
///   Keychain.shared.session = session
/// }
/// ```
final class Keychain {
  
  static let shared = Keychain()
  private init() { }
  
  static let serviceID = "software.mlq.SampleWalletApp"
  var serviceID: String { Self.serviceID }
  
  static let account = "userSession"
  var account: String { Self.account }
  
}
