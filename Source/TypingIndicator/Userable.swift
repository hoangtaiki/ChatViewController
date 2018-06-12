//
//  Userable.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/12/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Foundation

public protocol Userable {

    var id: String { get set }
    var name: String { get set }
}

extension Userable {

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
