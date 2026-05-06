//
//  DashboardViewControllerDelegate.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

public protocol DashboardViewControllerDelegate: AnyObject {
  
  func dashboardViewControllerDidTapLogin(
    _ dashboardViewController: DashboardViewController
  )
  
  func dashboardViewControllerDidTapLogout(
    _ dashboardViewController: DashboardViewController
  )
  
  /// Asks the delegate whether the app layer has any cached transactions.
  /// The dashboard view controller passes the transactions to the transaction
  /// history view when the latter is pushed into the navigation stack.
  func cachedTransactions(
    for dashboardViewController: DashboardViewController
  ) -> [CachedTransaction]
  
}
