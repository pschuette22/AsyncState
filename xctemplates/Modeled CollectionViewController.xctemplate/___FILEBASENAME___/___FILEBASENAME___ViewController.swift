// ___FILEHEADER___

import AsyncState
import Foundation
import UIK

@Modeled(___VARIABLE_productName:identifier___State.self, ___VARIABLE_productName:identifier___ViewModel.self)
final class ___FILEBASENAME___: UIViewController, ModeledViewController {
    // TODO: Apply frame and layout
    private lazy var collectionView = UICollectionView()
    
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
        // TODO: Add subviews
        view.addSubview(collectionView)
        
        // Auto layout? Manual framing?
    }

    @MainActor
    func render(_ state: State) {
        // TODO: Apply any new state changes
        // layout.render(snapshot)
    }
}
