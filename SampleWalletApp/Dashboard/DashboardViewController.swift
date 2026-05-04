//
//  DashboardViewController.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import UIKit
import SwiftUI
import Combine

class DashboardViewController: UIViewController {
  
  // MARK: - Lifecycle events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if hostingController == nil {
      let vc = makeHostingController()
      hostingController = vc
      embedHostingController(vc)
    }
  }
  
  private var hasAppearedBefore = false
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Perform tasks on first-time appearance.
    if hasAppearedBefore == false {
      hasAppearedBefore = true
      modelController.reloadSession()
    }
  }
  
  
  
  // MARK: - Initializing the custom root view
  
  private var hostingController: UIHostingController<DashboardView>?
  
  private func makeHostingController() -> UIHostingController<DashboardView> {
    let view = DashboardView(modelController: modelController)
    let hostingController = UIHostingController(rootView: view)
    return hostingController
  }
  
  private func embedHostingController(
    _ viewController: UIHostingController<some View>
  ) {
    guard let hostedView = viewController.view else { return }
    
    addChild(viewController)
    view.addSubview(viewController.view)
    viewController.didMove(toParent: self)
    
    hostedView.translatesAutoresizingMaskIntoConstraints = false
    hostedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    hostedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    hostedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    hostedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
  
  
  // MARK: - View state
  
  private lazy var modelController = DashboardViewModelController()
  private var model: DashboardViewModel { modelController.model }
  
  
  // MARK: - Observing the view model
  
  private var observations = Set<AnyCancellable>()
  
  private func observeViewModel() {
    model.$session
      .receive(on: DispatchQueue.main)
      .sink { [weak self] session in
        guard let self else { return }
        if session == nil {
          // Present login here
        }
      }
      .store(in: &observations)
  }
  
}
