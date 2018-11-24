//
//  UIDevice.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/18/18.
//

import Foundation

extension UIDevice {

    static let isRetina = UIScreen.main.scale >= 2.0

    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(screenWidth, screenHeight)

    static let isIphone5 = current.userInterfaceIdiom == .phone && screenMaxLength == 568
    static let isIphone6 = current.userInterfaceIdiom == .phone && screenMaxLength == 667
    static let isIphone6P = current.userInterfaceIdiom == .phone && screenMaxLength == 736
    static let isIphoneX = current.userInterfaceIdiom == .phone && screenMaxLength == 812
}
