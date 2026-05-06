//
//  TransactionListViewController.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import UIKit

final class TransactionListViewController: UIViewController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    navigationItem.title = "Transaction history"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Custom root view
  
  private lazy var rootView = TransactionListView(frame: .zero)
  private var collectionView: UICollectionView { rootView.collectionView }
  
  override func loadView() {
    view = rootView
  }
  
  
  
  // MARK: - Lifecycle events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
