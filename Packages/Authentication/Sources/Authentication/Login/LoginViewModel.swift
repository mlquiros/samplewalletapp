//
//  LoginViewModel.swift
//  Authentication
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
  
  @Published fileprivate(set) var username = ""
  @Published fileprivate(set) var password = ""
  @Published fileprivate(set) var showsPassword = false
  
  @Published fileprivate(set) var error: Error?
  @Published fileprivate(set) var isProcessing = false
  
}

final class LoginViewModelController {
  
  @MainActor
  let model: LoginViewModel
  
  @MainActor
  init() {
    model = LoginViewModel()
  }
  
  deinit {
    currentTask?.cancel()
  }
  
  @MainActor
  func setUsername(_ username: String) {
    model.username = username
  }
  
  @MainActor
  func setPassword(_ password: String) {
    model.password = password
  }
  
  @MainActor
  func setShowsPassword(_ showsPassword: Bool) {
    model.showsPassword = showsPassword
  }
  
  
  
  
  
  
  
  private var currentTask: Task<Void, Never>?
  
  @MainActor
  func attemptLoggingIn(
    successBlock: (@MainActor (_ session: Session) -> Void)? = nil
//    failureBlock: (@MainActor (_ error: Error) -> Void)? = nil
  ) {
    guard model.isProcessing == false else { return }
    
    model.isProcessing = true
    let username = model.username
    
    currentTask = Task {
      do {
        // Proxy code for performing field validation.
        try Self.validateUsername(username)
        
        // Proxy code for performing a login API request and saving the session.
        let username = username
        let sessionToken = UUID().uuidString
        
        await MainActor.run { [weak self] in
          guard let self else { return }
          self.model.isProcessing = false
          self.model.error = nil
          successBlock?(Session(username: username, token: sessionToken))
        }
      } catch {
        await MainActor.run { [weak self] in
          guard let self else { return }
          self.model.isProcessing = false
          self.model.error = error
//          failureBlock?(error)
        }
      }
    }
    
  }
  
  
  
  
  // MARK: - Validation
  
  private static func validateUsername(_ username: String) throws {
    let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
    guard trimmed.count > 0 else {
      throw EmptyUsername()
    }
    
    // Only allow alphanumeric characters, one or more
    let pattern = "^[A-Za-z0-9]+$"
    let regex = try NSRegularExpression(pattern: pattern)
    let fullRange = NSRange(location: 0, length: (trimmed as NSString).length)
    let matches = regex.firstMatch(in: trimmed, range: fullRange) != nil

    guard matches else {
      throw InvalidUsername()
    }
  }
  
  struct EmptyUsername: LocalizedError {
    var errorDescription: String? { "Username is empty." }
  }
  
  struct InvalidUsername: LocalizedError {
    var errorDescription: String? { "Username must contain only letters and numbers." }
  }
  
}
