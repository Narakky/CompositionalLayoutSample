//
//  GridViewController.swift
//  CompositionalLayoutSample
//
//  Created by Naraki on 2/20/20.
//  Copyright © 2020 i-enter. All rights reserved.
//

import UIKit

final class GridViewController: UIViewController {
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

    configureCollectionView()
    configureDataSource()
  }

  // MARK: - Private

  private func generateLayout() -> UICollectionViewLayout {
    // MARK: Item
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    // MARK: Group
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .fractionalWidth(0.2))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    // MARK: Section
    let section = NSCollectionLayoutSection(group: group)

    // MARK: Layout
    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }

  private func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds,
                                      collectionViewLayout: generateLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
    view.addSubview(collectionView)
    collectionView.delegate = self
  }

  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.reuseIdentifier, for: indexPath) as? TextCell else { return UICollectionViewCell() }
      cell.label.text = item.description
      cell.label.textColor = .black
      cell.contentView.backgroundColor = .yellow
      return cell
    }

    // MARK: Initial Data

    var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
    snapshot.appendSections([.main])
    snapshot.appendItems(Array(0..<100))
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

// MARK: - UICollectionViewDelegate

extension GridViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}
