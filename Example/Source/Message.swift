//
//  Message.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Foundation

enum MessageType: Int, Decodable {
    case text = 0
    case file
}

struct Message: Decodable {

    let id: String!
    let type: MessageType
    var text: String?
    var file: FileInfo?
    let sendByID: Int!
    let createdAt: Date!
    let updatedAt: Date?
    var isOutgoing: Bool = true

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case text
        case file
        case sendByID = "sender_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: String, type: MessageType, sendByID: Int, createdAt: Date) {
        self.id = id
        self.type = type
        self.sendByID = sendByID
        self.createdAt = createdAt
        self.updatedAt = createdAt
    }

    /// Initialize outgoing text message
    init(id: String, sendByID: Int, createdAt: Date, text: String) {
        self.init(id: id, type: .text, sendByID: sendByID, createdAt: createdAt)
        self.text = text
    }

    /// Initialize outgoing file message
    init(id: String, sendByID: Int, createdAt: Date, file: FileInfo) {
        self.init(id: id, type: .file, sendByID: sendByID, createdAt: createdAt)
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
