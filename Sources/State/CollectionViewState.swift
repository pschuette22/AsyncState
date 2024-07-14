//
//  CollectionViewState.swift
//
//
//  Created by Peter Schuette on 7/1/24.
//

#if canImport(UIKit)
    import Foundation
    import UIKit

    public protocol CollectionViewState: ViewState {
        associatedtype Sections: Hashable, Sendable
        associatedtype Items: Hashable, Sendable

        var snapshot: NSDiffableDataSourceSnapshot<Sections, Items> { get }
    }
#endif
