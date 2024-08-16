// ___FILEHEADER___

import AsyncState
import Foundation
import UIKit

struct ___FILEBASENAME___: CollectionViewState {
    // TODO: State variables
    // var someVariable: Int
    enum Sections: Hashable, Sendable {
        case replaceMe
    }
    
    enum Items: Hashable, Sendable {
        case replaceMe
    }
    
    /// Ordered array of Sections for current state
    private(set) var sections: [Sections] = [
        .replaceMe
    ]
    
    /// Map of items per section
    private(set) var sectionItems: [Sections: [Items]] = [
        .replaceMe: [.replaceMe]
    ]
}

extension ___FILEBASENAME___ {
    /// Compute the snapshot based on collection state
    var snapshot: NSDiffableDataSourceSnapshot<Sections, Items> {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Items>()
        snapshot.appendSections(sections)
        sectionItems.forEach { section, items in
            guard let items = sectionItems[section] else { return }

            snapshot.appendItems(items, toSection: section)
        }
        // Add additional customizations as needed
        return snapshot
    }
}

extension ___FILEBASENAME___ {
    // TODO: Define transactions
}
