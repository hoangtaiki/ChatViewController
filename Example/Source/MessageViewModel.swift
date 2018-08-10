//
//  MessageViewModel.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class MessageViewModel {

    var isRefreshing: Bool = false
    var users: [User] = []
    var messages: [Message] = []
    var currentUser: User?

    init() {

        getUserData()

        if let firstUser = users.first {
            currentUser = firstUser
        }
    }

    func getMessageData(completion: (() -> ())) {
        guard let jsonData = Data.dataFromJSONFile("conversation") else {
            return
        }

        do {
            let jsonObj = try JSON(data: jsonData)
            guard let dictionObject = jsonObj.dictionaryObject else {
                return
            }

            guard let listReponse = Mapper<ListResponseObject<Message>>().map(JSON: dictionObject) else {
                return
            }

            messages = self.handleDataSource(messages: listReponse.data).reversed()
            completion()
        } catch {
            print("Error \(error)")
            return
        }
    }

    func getUserData() {
        guard let jsonData = Data.dataFromJSONFile("user") else {
            return
        }

        do {
            let jsonObj = try JSON(data: jsonData)
            guard let dictionObject = jsonObj.dictionaryObject else {
                return
            }

            guard let listReponse = Mapper<ListResponseObject<User>>().map(JSON: dictionObject) else {
                return
            }

            users = listReponse.data
        } catch {
            print("Error \(error)")
            return
        }
    }
}

extension MessageViewModel {

    func getUserFromID(_ id: Int) -> User {
        let index = users.index(where: { $0.id == id })
        return users[index!.hashValue]
    }

    func getRoundStyleForMessageAtIndex(_ index: Int) -> RoundedViewType {
        let message = messages[index]
        if let beforeItemMessage = messages.item(before: index),
            let afterItemMessage = messages.item(after: index) {
            if beforeItemMessage.isOutgoing == message.isOutgoing
                && message.isOutgoing == afterItemMessage.isOutgoing {
                return .centerGroup
            }

            if beforeItemMessage.isOutgoing == message.isOutgoing {
                return .bottomGroup
            }

            if message.isOutgoing == afterItemMessage.isOutgoing {
                return .topGroup
            }

            return .single
        }

        if let beforeItemMessage = messages.item(before: index) {
            if beforeItemMessage.isOutgoing == message.isOutgoing {
                return .bottomGroup
            }
            return .single
        }

        if let afterItemMessage = messages.item(after: index) {
            if afterItemMessage.isOutgoing == message.isOutgoing {
                return .topGroup
            }

            return .single
        }

        return .single
    }

    fileprivate func handleDataSource(messages: [Message]) -> [Message] {
        let modifiedArray = messages.map { msg -> Message in
            var m = msg
            m.isOutgoing = self.isOutgoingMessage(m)
            return m
        }

        return modifiedArray
    }

    fileprivate func isOutgoingMessage(_ message: Message) -> Bool {
        guard let user = currentUser else {
            return false
        }

        return message.sendByID == user.id
    }
}
