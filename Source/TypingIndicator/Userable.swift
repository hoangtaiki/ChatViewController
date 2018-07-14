//
//  Userable.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/12/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Foundation

public protocol Userable {

    var idNumber: String { get }
    var displayName: String { get }
}

extension Userable {

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.idNumber == rhs.idNumber
    }
}
