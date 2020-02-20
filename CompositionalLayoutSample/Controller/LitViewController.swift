//
//  LitViewController.swift
//  CompositionalLayoutSample
//
//  Created by Naraki on 2/20/20.
//  Copyright © 2020 i-enter. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
  enum Section {
    case main
  }

  // MARK: - Properties

  private var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
  private lazy var items: [Int] = { (0 ... 300).map { $0 } }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "リスト"

    configureCollectionView()
    configureDataSource()
  }

  // MARK: - Privates

  private func generateLayout() -> UICollectionViewLayout {
    // MARK: Item
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    // MARK: Group
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .absolute(66))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])

    // MARK: Section
    let section = NSCollectionLayoutSection(group: group)

    // MARK: Layout
    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }

  private func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
    view.addSubview(collectionView)
    collectionView.delegate = self
  }

  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else { return UICollectionViewCell() }
      cell.label.text = "\(item)番目のセルです"
      return cell
    }

    let snapshot = snapshotForCurrentState()
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Int> {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    return snapshot
  }
}

extension ListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}
