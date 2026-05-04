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
  
  init(modelController: DashboardViewModelController) {
    self.modelController = modelController
    self._viewModel = ObservedObject(wrappedValue: modelController.model)
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
          // Show login screen here.
        } else {
          modelController.logOut()
        }
      } label: {
        Text(viewModel.session == nil ? "Log in" : "Log out")
      }

    }
  }
  
  
  
}
