//
//  DashboardView.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import SwiftUI

struct DashboardView: View {
  
  let modelController: DashboardViewModelController
  @ObservedObject private var viewModel: DashboardViewModel
  
  private let didTapLogin: (() -> Void)?
  private let didTapLogout: (() -> Void)?
  
  
  init(
    modelController: DashboardViewModelController,
    didTapLogin: (() -> Void)? = nil,
    didTapLogout: (() -> Void)? = nil
  ) {
    self.modelController = modelController
    self._viewModel = ObservedObject(wrappedValue: modelController.model)
    self.didTapLogin = didTapLogin
    self.didTapLogout = didTapLogout
  }
  
  var body: some View {
    VStack {
      if let session = viewModel.session {
        Text("Hello, \(session.username)")
      } else {
        Text("No session found")
      }
      
      Button {
        if viewModel.session == nil {
          didTapLogin?()
        } else {
          modelController.setSession(nil)
          didTapLogout?()
        }
      } label: {
        Text(viewModel.session == nil ? "Log in" : "Log out")
      }

    }
  }
  
  
  
}
