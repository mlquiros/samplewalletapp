//
//  Session.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 4/5/26.
//

/// The session credentials of the currently authenticated user.
public struct Session: Codable {
  
  /// The current user's username.
  public let username: String
  
  /// The session's identifier.
  public let token: String
  
  public init(
    username: String,
    token: String
  ) {
    self.username = username
    self.token = token
  }
  
}
