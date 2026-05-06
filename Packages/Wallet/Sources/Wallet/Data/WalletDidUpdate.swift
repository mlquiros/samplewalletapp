//
//  WalletDidUpdate.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

/// Namespace for the `Foundation.Notification` that is posted when
/// the wallet balance is updated.
///
/// Observe the ``notificationName`` if you want to receive the wallet's
/// balance whenever it is changed, e.g. after a send money transaction or when
/// a component in the Wallet package fetches the latest balance from a web service.
///
/// The published notification's `userInfo` dictionary will contain a value
/// of type ``UserInfo`` keyed by ``userInfoKey``.
///
/// ```swift
/// // Observe the notification.
/// NotificationCenter.default
///   .addObserver(self,
///       selector: #selector(handleNotification),
///       name: WalletDidUpdate.notificationName,
///       object: nil)
///
/// // Receive the notification.
/// @objc func handleNotification(_ notification: Notification) {
///
///   // Extract the user info from the payload.
///   guard notification.name == WalletDidUpdate.notificationName,
///     let userInfo = notification.userInfo?[WalletDidUpdate.userInfoKey]
///       as? WalletDidUpdate.UserInfo
///   else { return }
///   
///   // Use the notification payload.
///   print("New wallet balance: \(userInfo.balance)")
/// }
/// ```
public enum WalletDidUpdate {
  
  /// The name of the posted notification.
  public static let notificationName = Notification.Name("WalletDidUpdateNotification")
  
  /// The key to use for retrieving the notification user info.
  public static let userInfoKey = "WalletDidUpdateNotification.userInfoKey"
  
  /// A typed container for the notification user info.
  public struct UserInfo {
    /// The wallet's updated balance.
    public let balance: Decimal
    /// Identifies the currency that the wallet is denominated in.
    public let currencyCode: String
  }
  
}
