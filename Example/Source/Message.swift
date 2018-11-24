//
//  Message.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import ObjectMapper

enum MessageType: Int {
    case text = 0
    case file
}

struct Message: Mappable {

    var id: String!
    var type: MessageType = .text
    var text: String?
    var file: FileInfo?
    var sendByID: Int!
    var createdAt: Date!
    var updatedAt: Date?
    var isOutgoing: Bool = true

    init?(map: Map) {
        if map.JSON["id"] == nil
            || map.JSON["sender_id"] == nil
            || map.JSON["created_at"] == nil {
            return
        }
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        type <- (map["type"], EnumTransform<MessageType>())
        text <- map["text"]
        file <- map["file"]
        sendByID <- map["sender_id"]
        createdAt <- (map["created_at"], RFC3339DateTransform2())
        updatedAt <- (map["updated_at"], RFC3339DateTransform2())
    }

    init(id: String, type: MessageType, sendByID: Int, createdAt: Date) {
        self.id = id
        self.type = type
        self.sendByID = sendByID
        self.createdAt = createdAt
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
