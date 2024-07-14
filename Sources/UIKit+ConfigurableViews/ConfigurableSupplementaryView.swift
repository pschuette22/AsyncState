//
//  ConfigurableSupplementaryView.swift
//
//
//  Created by Peter Schuette on 7/1/24.
//

#if canImport(UIKit)
    import Foundation
    import UIKit

    /// ``UICollectionReusableView`` that is configued with a given ``ViewConfiguration``
    public protocol ConfigurableSupplementaryView: UICollectionReusableView, Configurable {
        static var reuseIdentifier: String { get }
    }

    // MARK: - Registration

    public extension UICollectionView {
        /// Register a reusable view type to be dequeued
        /// - Parameters:
        ///   - configurableSupplementaryView: Type of Reusable View being registered
        ///   - kind: Kind this type is registered for
        func register(
            _ configurableSupplementaryView: any ConfigurableSupplementaryView.Type,
            ofKind kind: String
        ) {
            register(
                configurableSupplementaryView.self,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: configurableSupplementaryView.reuseIdentifier
            )
        }
    }

    // MARK: - Dequeueing

    public extension UICollectionView {
        /// Dequeue a ``ConfigurableSupplementaryView`` with a given ``ViewConfiguration``
        /// - Parameters:
        ///   - configuration: Configuration describing the contents of this supplementary view
        ///   - kind: Kind of supplementary view to locate
        ///   - indexPath: Location of this supplementary view in the collection
        /// - Returns: Configured supplementary view for the given kind
        func dequeueSupplementaryView<SupplementaryView: ConfigurableSupplementaryView>(
            withConfiguration configuration: SupplementaryView.Configuration,
            ofKind kind: String,
            for indexPath: IndexPath,
            file: StaticString = #file,
            line: UInt = #line
        ) -> SupplementaryView {
            guard let view = dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SupplementaryView.reuseIdentifier,
                for: indexPath
            ) as? SupplementaryView else {
                fatalError(
                    "Unable to dequeue \(String(describing: type(of: SupplementaryView.self))) of kind \(kind). Did you forget to ```register(:ofKind:)``` this type for this kind?",
                    file: file,
                    line: line
                )
            }
            view.apply(configuration)
            return view
        }
    }
#endif
