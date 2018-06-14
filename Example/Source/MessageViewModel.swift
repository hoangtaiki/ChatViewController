//
//  MessageViewModel.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

class MessageViewModel {

    var users: [User] = []
    var messages: [Message] = []
    var currentUser: User!

    init() {
        /// Init user array
        let bob = User(id: 1.description, name: "Bob", image: #imageLiteral(resourceName: "ic_boy"))
        let anna = User(id: 2.description, name: "Anna", image: #imageLiteral(resourceName: "ic_girl"))
        users.append(bob)
        users.append(anna)

        currentUser = bob

        /// Initalize message array
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "Hello", isOutgoingMessage: false))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "What does the datetime stamp represent?",
                                isOutgoingMessage: true))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "Is it a point in time *before* they started speaking? I like how your nose is in the middle of your face. That’s really cute",
                                isOutgoingMessage: true))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "You are now talking on",
                                isOutgoingMessage: false))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "I hope you’re having a nice day 🙂",
                                isOutgoingMessage: false))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "Hello. Also, you are amazing",
                                isOutgoingMessage: true))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "What does the datetime stamp represent?",
                                isOutgoingMessage: true))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "WSaw your profile and just had to say hi.",
                                isOutgoingMessage: true))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "I will always tell you when you have something in your teeth. That’s just the kind of person I am.",
                                isOutgoingMessage: false))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "I like how your nose is in the middle of your face. That’s really cute.",
                                isOutgoingMessage: false))

        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "Nope, I'm New York, born and raised.",
                                isOutgoingMessage: false))

        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "Ah, all right. So you know all the secret places the tourists and I can only guess about.",
                                isOutgoingMessage: true))
        messages.append(Message(type: .text, sendByID: bob.id, createdAt: Date(),
                                text: "Right now or originally?",
                                isOutgoingMessage: true))

    }

    func getUserFromID(_ id: String) -> User {
        let index = users.index(where: { $0.id == id })
        return users[index!.hashValue]
    }

    func getRoundStyleForMessageAtIndex(_ index: Int) -> RoundedViewType {
        let message = messages[index]
        if let beforeItemMessage = messages.item(before: index),
            let afterItemMessage = messages.item(after: index) {
            if beforeItemMessage.isOutgoingMessage == message.isOutgoingMessage
                && message.isOutgoingMessage == afterItemMessage.isOutgoingMessage {
                return .centerGroup
            }

            if beforeItemMessage.isOutgoingMessage == message.isOutgoingMessage {
                return .bottomGroup
            }

            if message.isOutgoingMessage == afterItemMessage.isOutgoingMessage {
                return .topGroup
            }

            return .single
        }

        if let beforeItemMessage = messages.item(before: index) {
            if beforeItemMessage.isOutgoingMessage == message.isOutgoingMessage {
                return .bottomGroup
            }
            return .single
        }

        if let afterItemMessage = messages.item(after: index) {
            if afterItemMessage.isOutgoingMessage == message.isOutgoingMessage {
                return .topGroup
            }

            return .single
        }

        return .single
    }
}
