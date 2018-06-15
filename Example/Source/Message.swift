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
    case file
}

struct Message {

    var id: String
    var type: MessageType = .text
    var text: String?
    var file: FileInfo?
    var sendByID: String
    var createdAt: Date
    var updatedAt: Date?
    var isOutgoingMessage: Bool = true

    init(type: MessageType, sendByID: String, createdAt: Date, isOutgoingMessage: Bool = true) {
        id = UUID().uuidString
        self.type = type
        self.sendByID = sendByID
        self.createdAt = createdAt
        self.isOutgoingMessage = isOutgoingMessage
    }

    /// Initialize text message
    init(type: MessageType, sendByID: String, createdAt: Date, text: String, isOutgoingMessage: Bool = true) {
        self.init(type: type, sendByID: sendByID, createdAt: createdAt, isOutgoingMessage: isOutgoingMessage)
        self.text = text
    }

    /// Initialize file message
    init(type: MessageType, sendByID: String, createdAt: Date, file: FileInfo , isOutgoingMessage: Bool = true) {
        self.init(type: type, sendByID: sendByID, createdAt: createdAt, isOutgoingMessage: isOutgoingMessage)
        self.file = file
    }

    func cellIdentifer() -> String {
        switch type {
        case .text:
            return MessageTextCell.reuseIdentifier
        case .file:
            return MessageImageCell.reuseIdentifier
        }
    }
}
