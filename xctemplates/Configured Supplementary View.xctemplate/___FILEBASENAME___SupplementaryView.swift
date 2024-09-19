// ___FILEHEADER___

import AsyncState
import Foundation
import UIKit

final class ___FILEBASENAMEASIDENTIFIER___: UICollectionReusableView, ConfigurableSupplementaryView {
    static let reuseIdentifier = "\(Bundle.main.bundleIdentifier ?? "").___FILEBASENAMEASIDENTIFIER___"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
       // initialize what is needed
    }

    @available(*, unavailable, message: "Storyboards are not supported. Use ``init(frame:)``")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Subview
extension ___FILEBASENAMEASIDENTIFIER___ {
    // TODO: Define transactions
    struct Configuration: ViewConfiguration {

    }

    func setupSubviews() {
        // TODO: Setup Subviews
    }

    func apply(_ configuration: Configuration) {
        // Apply the layout configuration
    }
}
