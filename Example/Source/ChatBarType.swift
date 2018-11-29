//
//  ChatBarType.swift
//  iOS Example
//
//  Created by Hoangtaiki on 11/28/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import ChatViewController

extension ChatBarStyle {
    
    var description: String {
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
