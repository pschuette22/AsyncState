// ___FILEHEADER___

import AsyncState
import Foundation
import UIKit

@Modeled(___VARIABLE_productName:identifier___State.self, ___VARIABLE_productName:identifier___ViewModel.self)
final class ___FILEBASENAME___: UIViewController, ModeledViewController {
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    )
    
    private lazy var collectionViewLayout: UICollectionViewLayout = makeLayout()
    private lazy var dataSource: DataSource = makeDataSource(for: collectionView)
    
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "Storyboards are not supported. Use init(viewModel:)")
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension ___FILEBASENAME___ {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        startObservingState(renderImmediately: true)
    }
}

// MARK: - Subviews

extension ___FILEBASENAME___ {
    ///  Prepare subviews for state rendering
    private func setupSubviews() {
        // TODO: Setup additional subviews

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }

    @MainActor
    func render(_ state: State) {
        // TODO: Apply any new state changes
        // layout.render(snapshot)
        dataSource.apply(state.snapshot, animatingDifferences: true))
    }
}

// MARK: - CollectionView

extension ___FILEBASENAME___ {
    private typealias DataSource = UICollectionViewDiffableDataSource
    typealias Sections = State.Sections
    typealias Items = State.Items
    
    
    @MainActor
    private func makeLayout() -> UICollectionViewLayout {
        // https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout
        // TODO: Update this for your collection view
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout()
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func makeDataSource(for collectionView: UICollectionView) -> DataSource<Sections, Items> {
        DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            // TODO: turn into configured cells
            nil
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ___FILEBASENAME___: UICollectionViewDelegate {
    // TODO: handle delegate functions
}
