//
//  ConfigurableCell.swift
//
//
//  Created by Peter Schuette on 7/1/24.
//

#if canImport(UIKit)
    import Foundation
    import UIKit

    /// ``UICollectionViewCell`` that is configured with a ``ViewConfiguration``
    public protocol ConfigurableCell: UICollectionViewCell, Configurable {
        static var reuseIdentifier: String { get }
    }

    // MARK: - Registration

    public extension UICollectionView {
        /// Register a ConfigurableCell type so it can be dequeued
        /// - Parameter configurableCell: Cell type to be dequeued
        func register(_ configurableCell: any ConfigurableCell.Type) {
            register(
                configurableCell.self,
                forCellWithReuseIdentifier: configurableCell.reuseIdentifier
            )
        }
    }

    // MARK: - Dequeueing

    public extension UICollectionView {
        /// Dequeue a ``ConfigurableCell`` with a given ``ConfigurableCell.Configuration``
        /// - Parameters:
        ///   - configuration: ``ViewConfiguration`` describing the contents of the cell
        ///   - indexPath: ``IndexPath`` for this cell
        /// - Returns: Instance of this ``ConfigurableCell``
        func dequeueCell<Cell: ConfigurableCell>(
            withConfiguration configuration: Cell.Configuration,
            for indexPath: IndexPath,
            file: StaticString = #file,
            line: UInt = #line
        ) -> Cell {
            guard let cell = dequeueReusableCell(
                withReuseIdentifier: Cell.reuseIdentifier,
                for: indexPath
            ) as? Cell else {
                fatalError(
                    "Unable to dequeue reusable cell for type \(String(describing: type(of: Cell.self)))! Did you forget to ```register``` this type?",
                    file: file,
                    line: line
                )
            }
            cell.apply(configuration)
            return cell
        }
    }
#endif
