//
//  Message.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

enum MessageType: Int {
    case text = 0
    case image
}

struct Message {

    var type: MessageType = .text
    var text: String?
    var image: UIImage?
    var sendByID: String
    var createdAt: Date
    var updatedAt: Date?

    init(type: MessageType, sendByID: String, createdAt: Date) {
        self.type = type
        self.sendByID = sendByID
        self.createdAt = createdAt
    }

    /// Initialize text message
    init(type: MessageType, sendByID: String, createdAt: Date, text: String) {
        self.init(type: type, sendByID: sendByID, createdAt: createdAt)
        self.text = text
    }

    /// Initialize image message
    init(type: MessageType, sendByID: String, createdAt: Date, image: UIImage) {
        self.init(type: type, sendByID: sendByID, createdAt: createdAt)
        self.image = image
    }
}
