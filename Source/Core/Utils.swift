//
//  Utils.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/20/18.
//

import Foundation

class Utils {

    static let shared = Utils()

    let maxCollectionImageCellHeight: CGFloat = 226

    var isGreaterThanMaxHeight: Bool {
        get {
            return getCacheKeyboardHeight() > maxCollectionImageCellHeight
        }
    }

    func getCacheKeyboardHeight() -> CGFloat {
        let keyboardHeight = UserDefaults.standard.integer(forKey: "ChatViewController.KeyboardHeight")
        guard keyboardHeight != 0 else {
            return getDefaultKeyboardHeight()
        }

        return CGFloat(keyboardHeight)
    }

    func cacheKeyboardHeight(_ keyboardHeight: CGFloat) {
        UserDefaults.standard.set(keyboardHeight, forKey: "ChatViewController.KeyboardHeight")
    }

    private func getDefaultKeyboardHeight() -> CGFloat {
        if UIDevice.isIphone6P && UIDevice.isIphoneX {
            return 226
        }

        return 216
    }
}

