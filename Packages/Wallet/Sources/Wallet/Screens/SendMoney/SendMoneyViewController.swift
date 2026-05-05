//
//  SendMoneyViewController.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import UIKit

final class SendMoneyViewController: UIViewController {
  
  
  init() {
    super.init(nibName: nil, bundle: nil)
    navigationItem.title = "Send money"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Customizing the root view
  
  private lazy var rootView = SendMoneyView(frame: .zero)
  override func loadView() {
    view = rootView
  }
  
  
  
  // MARK: -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    rootView.amountTextField.delegate = self
  }
  
}

extension SendMoneyViewController: UITextFieldDelegate {
  
  
}
