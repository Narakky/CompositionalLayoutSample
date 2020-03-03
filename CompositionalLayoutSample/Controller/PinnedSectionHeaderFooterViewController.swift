import UIKit

final class PinnedSectionHeaderFooterViewController: UIViewController {
    private static let sectionHeaderElementKind = "section-header-element-kind"
    private static let sectionFooterElementKind = "section-footer-element-kind"

    typealias DataSource = UICollectionViewDiffableDataSource<Int, Int>

    private var dataSource: DataSource!
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
}

private extension PinnedSectionHeaderFooterViewController {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self,
                                forSupplementaryViewOfKind: PinnedSectionHeaderFooterViewController.sectionHeaderElementKind,
                                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self,
                                forSupplementaryViewOfKind: PinnedSectionHeaderFooterViewController.sectionFooterElementKind,
                                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    func makeLayout() -> UICollectionViewLayout {
        // MARK: Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // MARK: Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        // MARK: Section
        let section = NSCollectionLayoutSection(group: group)

        // MARK: SectionHeader/SectionFooter
        let sectionHeaderFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1),
                                                             heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderFooterSize,
                                                                        elementKind: PinnedSectionHeaderFooterViewController.sectionHeaderElementKind,
                                                                        alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderFooterSize,
                                                                        elementKind: PinnedSectionHeaderFooterViewController.sectionFooterElementKind,
                                                                        alignment: .bottom)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        // MARK: Layout
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else { return UICollectionViewCell() }
            cell.label.text = "\(indexPath.section) - \(indexPath.row)"
            return cell
        }

        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let headerFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                     withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,
                                                                                     for: indexPath) as? TitleSupplementaryView else { return nil }

            let viewKind = kind == PinnedSectionHeaderFooterViewController.sectionHeaderElementKind ? "Header" : "Footer"
            headerFooter.label.text = "\(viewKind) for section \(indexPath.section)"
            headerFooter.backgroundColor = .lightGray
            headerFooter.layer.borderColor = UIColor.black.cgColor
            headerFooter.layer.borderWidth = 1
            return headerFooter
        }

        let itemPerSection = 5
        let sections = Array(0 ..< 5)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems(Array(itemOffset ..< itemOffset + itemPerSection))
            itemOffset += itemPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PinnedSectionHeaderFooterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
