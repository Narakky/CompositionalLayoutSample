import UIKit

final class DistinctSectionsViewController: UIViewController {
    enum SectionLayoutKind: Int, CaseIterable {
        case list, grid5, grid3

        var columnCount: Int {
            switch self {
            case .grid3: return 3
            case .grid5: return 5
            case .list: return 1
            }
        }
    }

    typealias DataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Int>

    private var dataSource: DataSource!
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
}

extension DistinctSectionsViewController {
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            let columns = sectionLayoutKind.columnCount

            // MARK: Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)

            // MARK: Group
            let groupHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: columns)

            // MARK: Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = SectionLayoutKind(rawValue: indexPath.section)!

            if section == .list {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell {
                    cell.label.text = "\(item)"
                    return cell
                } else {
                    fatalError()
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.reuseIdentifier, for: indexPath) as? TextCell {
                    cell.label.text = "\(item)"
                    cell.contentView.backgroundColor = .blue
                    cell.contentView.layer.borderColor = UIColor.black.cgColor
                    cell.contentView.layer.borderWidth = 1
                    cell.contentView.layer.cornerRadius = section == .grid5 ? 8 : 0
                    cell.label.textAlignment = .center
                    cell.label.font = .preferredFont(forTextStyle: .title1)

                    return cell
                } else {
                    fatalError()
                }
            }
        }

        // MARK: Initial Data
        let itemsPerSection = 10
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
        SectionLayoutKind.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset ..< itemUpperbound))
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension DistinctSectionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
