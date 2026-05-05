//
//  DashboardViewController.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import UIKit
import SwiftUI
import Combine

/// Manages a dashboard view for the wallet of the current user.
public final class DashboardViewController: UIViewController {
  
  public weak var delegate: DashboardViewControllerDelegate?
  
  /// Creates a new view controller.
  ///
  /// - Parameters:
  ///   - session: Session credentials of the currently authenticated user, or nil.
  public init(
    session: Session?
  ) {
    self.modelController = DashboardViewModelController(session: session)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Lifecycle events
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    if hostingController == nil {
      let vc = makeHostingController()
      hostingController = vc
      embedHostingController(vc)
    }
  }
  
  private var hasAppearedBefore = false
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Perform tasks on first-time appearance.
    if hasAppearedBefore == false {
      hasAppearedBefore = true
      reloadContent(forSession: model.session)
    }
  }
  
  
  
  // MARK: - Initializing the custom root view
  
  private var hostingController: UIHostingController<DashboardView>?
  
  private func makeHostingController() -> UIHostingController<DashboardView> {
    let view = DashboardView(
      modelController: modelController,
      callbacks: makeDashboardViewCallbacks()
    )
    let hostingController = UIHostingController(rootView: view)
    return hostingController
  }
  
  private func makeDashboardViewCallbacks() -> DashboardView.Callbacks {
    return .init(
      
      didTapLogin: { [weak self] in
        guard let self else { return }
        self.delegate?.dashboardViewControllerDidTapLogin(self)
      },
      
      didTapLogout: { [weak self] in
        guard let self else { return }
        self.delegate?.dashboardViewControllerDidTapLogout(self)
      },
      
      didTapSendMoney: { [weak self] in
        self?.presentSendMoneyModal()
      }
    )
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
  
  private let modelController: DashboardViewModelController
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
  
  
  
  // MARK: - Reloading the session
  
  public func reloadContent(forSession session: Session?) {
    modelController.setSession(session)
    modelController.attemptFetchingWalletInfo()
  }
  
  
  
  // MARK: - Sending money
  
  private func presentSendMoneyModal() {
    guard let walletInfo = model.walletInfo else { return }
    let sendMoneyVC = SendMoneyViewController(walletBalance: walletInfo.balance)
    let modal = UINavigationController(rootViewController: sendMoneyVC)
    present(modal, animated: true)
  }
  
}
