//
//  ViewController.swift
//  CompositionalLayoutSample
//
//  Created by Naraki on 2/20/20.
//  Copyright © 2020 i-enter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  enum Section {
    case main
  }

  enum Item: String, CaseIterable {
    case list = "リスト"
    case grid = "グリッド"
    case insetItemGrid = "グリッド（間隔有）"
    case twoColumnsGrid = "2カラムグリッド"
    case distinctSections = "常に固定のレイアウト"
    case adaptiveSections = "画面サイズに応じたレイアウト"
    case itemBadges = "バッジ"
    case sectionHeaderFooter = "セクションヘッダとセクションフッタ"
    case pinnedSectionHeaders = "固定されたセクションヘッダ"
    case sectionBackgroundDecoration = "セクション背景装飾"
    case nestedGroup = "入れ子グループ"
    case orthogonalSections = "横スクロール可能"
    case orthogonalSectionsBehavior = "横スクロール可能（Behavior）"

    var title: String {
      return rawValue
    }

    var viewController: UIViewController? {
      switch self {
      case .list: return ListViewController()
      case .grid: return GridViewController()
      case .insetItemGrid: return InsetItemsGridViewController()
      case .twoColumnsGrid: return TwoColumnsGridViewController()
      case .distinctSections: return DistinctSectionsViewController()
      case .adaptiveSections: return AdaptiveSectionsViewController()
      case .itemBadges: return nil
      case .sectionHeaderFooter: return nil
      case .pinnedSectionHeaders: return nil
      case .sectionBackgroundDecoration: return nil
      case .nestedGroup: return nil
      case .orthogonalSections: return nil
      case .orthogonalSectionsBehavior: return nil
      }
    }
  }

  private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
  private var collectionView: UICollectionView!
  private lazy var items: [Item] = {
    return Item.allCases
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Compositional Layout Samples"

    configureCollectionView()
    configureDataSource()
  }
}

extension ViewController {
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
      cell.label.text = item.title
      return cell
    }

    let snapshot = snapshotForCurrentState()
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections([Section.main])
    snapshot.appendItems(items)
    return snapshot
  }

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
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    defer {
      collectionView.deselectItem(at: indexPath, animated: true)
    }

    let item = items[indexPath.item]
    guard let viewController = item.viewController else { return }
    viewController.navigationItem.title = item.title
    navigationController?.pushViewController(viewController, animated: true)
  }
}
