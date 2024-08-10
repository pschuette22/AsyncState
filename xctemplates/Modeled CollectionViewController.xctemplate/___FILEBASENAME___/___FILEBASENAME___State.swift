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
    private(set) var sections: [Section] = [
        .replaceMe
    ]
    
    /// Map of items per section
    private(set) var sectionItems: [Section: [Items]] = [
        .replaceMe: [.replaceMe]
    ]
}

extension ___FILEBASENAME___ {
    /// Compute the snapshot based on collection state
    var snapshot: NSDiffableDataSourceSnapshot<Sections, Items> {
        // TODO: Fix this
        let snapshot = sections.reduce(into: NSDiffableDataSourceSnapshot<Sections, Items>()) { snapshot, section
            snapshot.add(section: section)
            if let items = sectionItems[section] {
                snapshot.append(items, to: section)
            }
        }
        // Add additional customizations as needed
        return snapshot
    }
}
