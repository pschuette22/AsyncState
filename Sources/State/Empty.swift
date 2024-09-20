//
//  Empty.swift
//
//
//  Created by Peter Schuette on 9/19/24.
//

import Foundation

public struct Empty: ObjectState {
    public init() {}
    
    static var state = Empty()
}
