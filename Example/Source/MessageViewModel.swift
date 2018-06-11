//
//  MessageViewModel.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

class MessageViewModel {

    var messages: [Message] = []

    init() {
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "Hello"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "What does the datetime stamp represent?"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "Is it a point in time *before* they started speaking?"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "You are now talking on"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "I hope you’re having a nice day 🙂"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "Hello. Also, you are amazing"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "What does the datetime stamp represent?"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "WSaw your profile and just had to say hi."))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "I will always tell you when you have something in your teeth. That’s just the kind of person I am."))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "I like how your nose is in the middle of your face. That’s really cute."))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "Hello. Also, you are amazing"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "What does the datetime stamp represent?"))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "WSaw your profile and just had to say hi."))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "I will always tell you when you have something in your teeth. That’s just the kind of person I am."))
        messages.append(Message(type: .text, sendByID: "", createdAt: Date(),
                                text: "I like how your nose is in the middle of your face. That’s really cute."))


    }
}
