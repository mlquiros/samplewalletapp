//
//  LoginViewController.swift
//  Authentication
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import UIKit
import SwiftUI

final class LoginViewController: UIViewController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    navigationItem.title = "Login"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Delegation
  
  weak var delegate: LoginViewControllerDelegate?
  
  
  // MARK: - Lifecycle events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    embedSwiftUIView()
  }
  
  
  
  
  // MARK: - Embedding SwiftUI
  
  private var hostingController: UIHostingController<LoginView>?
  
  private func embedSwiftUIView() {
    
    let hostingController = UIHostingController(
      rootView: LoginView(
        modelController: modelController,
        didSucceedLogin: { [weak self] session in
          guard let self else { return }
          self.delegate?.loginViewController(
            self, didSucceedLoginWithSession: session)
        }
      ))
    
    self.hostingController = hostingController
    let hostedView = hostingController.view!
    
    addChild(hostingController)
    view.addSubview(hostedView)
    hostingController.didMove(toParent: self)
    
    hostedView.translatesAutoresizingMaskIntoConstraints = false
    hostedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    hostedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    hostedView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
    hostedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
  
  
  
  
  // MARK: -
  
  private let modelController = LoginViewModelController()
  private var model: LoginViewModel { modelController.model }
  
}
