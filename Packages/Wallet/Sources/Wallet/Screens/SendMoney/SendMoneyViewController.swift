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
  
  private let submitBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .action,
    target: self,
    action: #selector(handleTapOnSubmitButton))
  
  private func initializeNavigationItem() {
    navigationItem.title = "Send money"
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .close,
      target: self,
      action: #selector(handleTapOnCloseButton))
    navigationItem.rightBarButtonItem = submitBarButtonItem
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
  }
  
  
  
  // MARK: - Managing view state
  
  private let modelController: SendMoneyViewModelController
  private var model: SendMoneyViewModel { modelController.model }
  private var observations = Set<AnyCancellable>()
  
  private func setupViewModelObservations() {
    model.$walletBalanceLabel
      .receive(on: DispatchQueue.main)
      .sink { [weak self] newValue in
        guard let self else { return }
        self.rootView.walletBalanceLabel.text = newValue
      }
      .store(in: &observations)
  }
  
  
  
  // MARK: - Handling actions
  
  @objc private func handleTapOnCloseButton() {
    dismiss(animated: true)
  }
  
  @objc private func handleTapOnSubmitButton() {
    modelController.attemptSendingMoney(
      completionBlock: { [weak self] result in
        self?.showSendMoneyResultModal(result: result)
      }
    )
  }
  
  
  
  // MARK: -
  
  private func showSendMoneyResultModal(
    result: Result<SendMoney.Success, Error>
  ) {
    let swiftUIView = SendMoneyResultView(
      result: result,
      didTapDismiss: { [weak self] in
        guard let self else { return }
        switch result {
          // If successful, dismiss all the way up to the editor.
        case .success(_):
          self.presentingViewController?.dismiss(animated: true)
          // If failed, return to the send money editor.
        case .failure(let error):
          self.dismiss(animated: true)
        }
      })
    
    let hostingVC = UIHostingController(rootView: swiftUIView)
    let modal = UINavigationController(rootViewController: hostingVC)
    modal.sheetPresentationController?.detents = [.medium()]
    present(modal, animated: true)
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
    if let _ = try? modelController
      .validateCurrencyAmount(fromString: fullText) {
      modelController.setAmountText(fullText)
      return true
    }
    return false
  }
  
}
