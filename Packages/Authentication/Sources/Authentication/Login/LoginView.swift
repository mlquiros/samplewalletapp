//
//  LoginView.swift
//  Authentication
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import SwiftUI

struct LoginView: View {

  
  
  // MARK: - Initializer
  
  init(
    modelController: LoginViewModelController,
    didSucceedLogin: ((_ session: Session) -> Void)? = nil
  ) {
    self.modelController = modelController
    self._model = .init(wrappedValue: modelController.model)
    self.didSucceedLogin = didSucceedLogin
  }
  
  
  
  // MARK: - Managing view state
  
  let modelController: LoginViewModelController
  @ObservedObject private var model: LoginViewModel
  
  private var username: Binding<String> {
    .init(get: {
      model.username
    }, set: { newValue in
      modelController.setUsername(newValue)
    })
  }
  
  private var password: Binding<String> {
    .init(get: {
      model.password
    }, set: { newValue in
      modelController.setPassword(newValue)
    })
  }
  
  
  
  // MARK: - Callbacks
  
  private let didSucceedLogin: ((_ session: Session) -> Void)?
  
  
  
  // MARK: - View body
  
  var body: some View {
    ScrollView {
      VStack {
        TextField("Username", text: username)
        SecureField("Password", text: password)
        
        Button("Log in") {
          modelController.attemptLoggingIn() { session in
            didSucceedLogin?(session)
          }
        }
        .disabled(model.isProcessing)
        
        if let error = model.error {
          Text(error.localizedDescription)
            .foregroundStyle(Color.red)
            .lineLimit(nil)
            .multilineTextAlignment(.center)
        }
        
        Spacer()
      }
      .padding(16)
    }
  }
  
  
}
