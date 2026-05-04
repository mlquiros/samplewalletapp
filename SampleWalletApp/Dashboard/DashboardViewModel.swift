//
//  DashboardViewModel.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Combine

/// The state of the `DashboardView`.
@MainActor
final class DashboardViewModel: ObservableObject {
  
  @Published fileprivate(set) var session: Session?
  
}

/// Manages the state of the `DashboardView`.
final class DashboardViewModelController {
  
  let model = DashboardViewModel()
  
  func reloadSession() {
    model.session = Keychain.shared.session
  }
  
  func logOut() {
    Keychain.shared.session = nil
    reloadSession()
  }
  
}
