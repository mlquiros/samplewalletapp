//
//  SendMoneyViewController.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import UIKit
import Combine
import SwiftUI

final class SendMoneyViewController: UIViewController {
  
  
  
  // MARK: - Initialization
  
  init(
    walletBalance: CurrencyAmount
  ) {
    self.modelController = SendMoneyViewModelController(
      walletBalance: walletBalance)
    super.init(nibName: nil, bundle: nil)
    initializeNavigationItem()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Navigation items
  
  private func initializeNavigationItem() {
    navigationItem.title = "Send money"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .close,
      target: self,
      action: #selector(handleTapOnCloseButton))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action,
      target: self,
      action: #selector(handleTapOnSubmitButton))
  }
  
  
  
  // MARK: - Customizing the root view
  
  private lazy var rootView = SendMoneyView(frame: .zero)
  override func loadView() {
    view = rootView
  }
  
  
  
  // MARK: - Lifecycle events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    rootView.amountTextField.delegate = self
    setupViewModelObservations()
    
    // Control interactive dismissal.
    navigationController?.presentationController?.delegate = self
  }
  
  
  
  // MARK: - View state
  
  private let modelController: SendMoneyViewModelController
  private var model: SendMoneyViewModel { modelController.model }
  private var observations = Set<AnyCancellable>()
  
  private func setupViewModelObservations() {
    
    // Update the wallet balance label.
    model.$walletBalanceLabel
      .receive(on: DispatchQueue.main)
      .sink { [weak self] newValue in
        guard let self else { return }
        self.rootView.walletBalanceLabel.text = newValue
      }
      .store(in: &observations)
    
    
    // When the form is submitted, disable some views and show the
    // proper loading state.
    model.$isProcessing
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isProcessing in
        guard let self else { return }
        
        navigationItem.leftBarButtonItem?.isEnabled = !isProcessing
        navigationItem.rightBarButtonItem?.isEnabled = !isProcessing
        rootView.amountTextField.isEnabled = !isProcessing
        
        if isProcessing {
          rootView.progressView.startAnimating()
        } else {
          rootView.progressView.stopAnimating()
        }
      }
      .store(in: &observations)
  }
  
  
  
  // MARK: - Handling actions
  
  @objc private func handleTapOnCloseButton() {
    dismiss(animated: true)
  }
  
  @objc private func handleTapOnSubmitButton() {
    view.endEditing(true)
    modelController.attemptSendingMoney(
      completionBlock: { [weak self] result in
        guard let self else { return }
        
        // Show the result modal.
        self.showResultModal(result: result)
        
        // Post the success notifications.
        if case .success(let success) = result {
          self.postSendMoneySuccessNotifications(success: success)
        }
        
      }
    )
  }
  
  private func postSendMoneySuccessNotifications(success: SendMoney.Success) {
    
    NotificationCenter.default.post(
      name: WalletDidSendMoney.notificationName,
      object: nil,
      userInfo: [
        WalletDidSendMoney.userInfoKey: WalletDidSendMoney.UserInfo(
          amount: success.amountSent.amount,
          currencyCode: success.amountSent.currencyCode,
          date: Date())
      ]
    )
    
    NotificationCenter.default.post(
      name: WalletDidUpdate.notificationName,
      object: nil,
      userInfo: [
        WalletDidUpdate.userInfoKey: WalletDidUpdate.UserInfo(
          balance: success.walletBalance.amount,
          currencyCode: success.walletBalance.currencyCode)
      ])
    
  }
  
  
  
  // MARK: - Result modal
  
  private func showResultModal(
    result: Result<SendMoney.Success, Error>
  ) {
    let swiftUIView = SendMoneyResultView(
      result: result,
      didTapDismiss: { [weak self] in
        self?.dismissResultModal(relativeTo: result)
      })
    
    let hostingVC = UIHostingController(rootView: swiftUIView)
    let modal = UINavigationController(rootViewController: hostingVC)
    modal.sheetPresentationController?.detents = [.medium()]
    
    // If the modal is a success popup, don't let the user dismiss
    // via swipe-down. They must tap the check button.
    if case .success(_) = result {
      modal.isModalInPresentation = true
    }
    
    present(modal, animated: true)
  }
  
  private func dismissResultModal(
    relativeTo result: Result<SendMoney.Success, Error>
  ) {
    switch result {
      // If successful, dismiss all the way up to the editor.
    case .success(_):
      self.presentingViewController?.dismiss(animated: true)
      
      // If failed, return to the send money editor.
    case .failure(let error):
      self.dismiss(animated: true)
      rootView.amountTextField.becomeFirstResponder()
    }
  }
  
}



// MARK: - UITextFieldDelegate

extension SendMoneyViewController: UITextFieldDelegate {
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    
    let fullText = ((textField.text ?? "") as NSString)
      .replacingCharacters(in: range, with: string)
    if let _ = try? modelController.validateAmountString(fullText) {
      modelController.setAmountText(fullText)
      return true
    }
    return false
  }
  
}

extension SendMoneyViewController: UIAdaptivePresentationControllerDelegate {
  
  func presentationControllerShouldDismiss(
    _ presentationController: UIPresentationController
  ) -> Bool {
    return model.isProcessing == false
  }
  
}
