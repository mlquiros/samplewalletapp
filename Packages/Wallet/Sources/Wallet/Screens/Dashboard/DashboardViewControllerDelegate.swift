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
  
}
