//
//  ChatViewConfiguration.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 8/19/18.
//

import Foundation

public enum ChatBarStyle {
    case `default`
    case slack
    case other

    public var description: String {
        switch self {
        case .default:
            return "Default"
        case .slack:
            return "Slack"
        default:
            return ""
        }
    }
}

public struct ChatViewConfiguration {

    public var chatBarStyle: ChatBarStyle = .default
    public var maxChatBarHeight: CGFloat = 200

    public static var `default`: ChatViewConfiguration { return ChatViewConfiguration() }
}
