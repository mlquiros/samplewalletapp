//
//  TransactionListViewController.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import UIKit
import Combine

final class TransactionListViewController: UIViewController {
  
  init(
    cachedTransactions: [CachedTransaction]
  ) {
    modelController = TransactionListViewModelController(
      cachedTransactions: cachedTransactions)
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
    
    // Initialize view registrations.
    _ = listItemCell
    
    // Setup the collection view.
    collectionView.collectionViewLayout = makeLayout()
    collectionView.dataSource = dataSource
    collectionView.delegate = self
    
    observeViewModel()
  }
  
  private var hasAppearedBefore = false
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if hasAppearedBefore == false {
      hasAppearedBefore = true
      modelController.attemptFetchingTransactions()
    }
  }
  
  
  
  // MARK: - View state
  
  private let modelController: TransactionListViewModelController
  private var model: TransactionListViewModel { modelController.model }
  
  private var observations = Set<AnyCancellable>()
  
  private func observeViewModel() {
    model.$items
      .receive(on: DispatchQueue.main)
      .sink { [weak self] items in
        guard let self else { return }
        self.determineVisibleSubview()
        self.applySnapshotForCurrentViewModelItems()
      }
      .store(in: &observations)
    
    model.$isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.determineVisibleSubview()
      }
      .store(in: &observations)
    
    model.$error
      .receive(on: DispatchQueue.main)
      .sink { [weak self] error in
        guard let self else { return }
        self.rootView.errorLabel.text = error?.localizedDescription
        self.determineVisibleSubview()
      }
      .store(in: &observations)
    
  }
  
  private func determineVisibleSubview() {
    if model.isLoading {
      rootView.progressView.startAnimating()
    } else {
      rootView.progressView.stopAnimating()
    }
    rootView.collectionView.isHidden = model.isLoading || model.error != nil
    rootView.errorLabel.isHidden = model.isLoading || model.error == nil
  }
  
  
  // MARK: - Data source
  
  private enum Section {
    case list
  }
  private typealias Item = TransactionListViewModel.ListItem
  
  private var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
  
  private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(
    collectionView: rootView.collectionView) {
      [weak self] collectionView, indexPath, itemIdentifier in
      guard let self else {
        preconditionFailure("self cannot be nil")
      }
      return collectionView.dequeueConfiguredReusableCell(
        using: self.listItemCell, for: indexPath, item: itemIdentifier)
    }
  
  
  
  // MARK: - Applying a snapshot
  
  private func applySnapshotForCurrentViewModelItems() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections([.list])
    snapshot.appendItems(model.items)
    dataSource.apply(snapshot)
  }
  
  
  
  
  // MARK: - View registrations
  
  private lazy var listItemCell = UICollectionView
    .CellRegistration<TransactionListItemCell, Item> {
      [weak self] cell, indexPath, item in
      cell.dateLabel.text = item.formattedDate
      cell.amountLabel.text = item.formattedAmount
      cell.idLabel.text = item.id
    }
  
  
  
  // MARK: - Compositional layout
  
  private func makeLayout() -> UICollectionViewLayout {
    
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .vertical
    
    let layout = UICollectionViewCompositionalLayout(
      sectionProvider: { [weak self] sectionIndex, layoutEnvironment in
        guard let self else {
          preconditionFailure("self cannot be nil")
        }
        return self.makeSectionLayout()
      },
      configuration: config
    )
    
    return layout
  }
  
  private func makeSectionLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(100))
    let item = NSCollectionLayoutItem(
      layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: itemSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    
    return section
  }
}



// MARK: -

extension TransactionListViewController: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  
}
