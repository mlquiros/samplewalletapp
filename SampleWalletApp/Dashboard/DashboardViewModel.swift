//
//  DashboardViewModel.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
  
  @Published fileprivate(set) var session: Session?
  
}

final class DashboardViewModelController {
  
  let model = DashboardViewModel()
  
  func reloadSession() {
    model.session = Keychain.shared.session
  }
  
}
