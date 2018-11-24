//
//  Array.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/13/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Foundation

extension Array {

    func item(before index: Int) -> Element? {
        if index < 1 {
            return nil
        }

        if index > count {
            return nil
        }

        return self[index - 1]
    }

    func item(after index: Int) -> Element? {
        if index < -1 {
            return nil
        }

        if index <= count - 2 {
            return self[index + 1]
        }

        return nil
    }
}
