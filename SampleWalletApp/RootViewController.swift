//
//  RootViewController.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import UIKit
import Wallet

final class RootViewController: UINavigationController {
  
  private let walletDelegate: WalletDelegate
  
  init() {
    self.walletDelegate = WalletDelegate()
    let dashboardVC = DashboardViewController(
      session: Keychain.shared.session?.convertToWalletType())
    dashboardVC.delegate = walletDelegate
    super.init(rootViewController: dashboardVC)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
