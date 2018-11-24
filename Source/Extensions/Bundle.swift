//
//  Bundle.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Foundation

extension Bundle {

    static var chatBundle: Bundle {
        let frameworkBundle = Bundle(for: ChatBarView.self)

        guard
            let path = frameworkBundle.path(forResource: "ChatViewController", ofType: "bundle"),
            let bundle = Bundle(path: path)
            else {
                return frameworkBundle
        }

        return bundle
    }
}
