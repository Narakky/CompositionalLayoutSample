import UIKit

final class InsetItemsGridViewController: UIViewController {
    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>

    private var dataSource: DataSource!
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
}

extension InsetItemsGridViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        view.addSubview(collectionView)
    }

    private func makeLayout() -> UICollectionViewLayout {
        // MARK: Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

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

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.reuseIdentifier, for: indexPath) as? TextCell else { return UICollectionViewCell() }

            cell.label.text = "\(item)"
            cell.contentView.backgroundColor = .blue
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.black.cgColor
            cell.label.textAlignment = .center
            cell.label.font = .preferredFont(forTextStyle: .title1)
            cell.label.textColor = .white

            return cell
        }

        // MARK: Initial Data

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0...100))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
