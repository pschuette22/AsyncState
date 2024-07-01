//
//  ConfigurableSupplementaryView.swift
//
//
//  Created by Peter Schuette on 7/1/24.
//

#if canImport(UIKit)
    import Foundation
    import UIKit

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
        func dequeueSupplementaryView<SupplementaryView: ConfigurableSupplementaryView>(
            withConfiguration _: SupplementaryView.Configuration,
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
            return view
        }
    }
#endif
