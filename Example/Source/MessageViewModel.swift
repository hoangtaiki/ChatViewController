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

enum BubbleStyle {
    case facebook

    var description: String {
        switch self {
        case .facebook:
            return "Facebook"
        }
    }

}

enum ImagePickerType {
    case insideChatBar

    var description: String {
        switch self {
        case .insideChatBar:
            return "Embed inside Chat Bar"
        }
    }
}

class MessageViewModel {

    var isRefreshing: Bool = false
    var users: [User] = []
    var messages: [Message] = []
    var currentUser: User?
    var pagination: Pagination?
    var bubbleStyle: BubbleStyle = .facebook

    init(bubbleStyle: BubbleStyle) {
        self.bubbleStyle = bubbleStyle
        currentUser = User(id: 2, name: "Harry Tran", avatarURL: URL(string: "https://i.imgur.com/LIe72Gc.png"))
        getUserData()
    }

    func firstLoadData(completion: @escaping (() -> ())) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.getDataFromFile(fileName: "conversation") { (messageResponse: [Message], pagi) in
                self?.messages = self!.handleDataSource(messages: messageResponse).reversed()
                self?.pagination = pagi
                completion()
            }
        }
    }

    func loadMoreData(completion: @escaping ((_ indexPathWillAdds: [IndexPath]) -> ())) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.getDataFromFile(fileName: "conversation_older") { (messageResponse: [Message], pagi) in
                let indexPathWillAdds = self!.getIndexPathWillAdds(newDataSize: messageResponse.count)
                self?.messages.append(contentsOf: self!.handleDataSource(messages: messageResponse).reversed())
                self?.pagination = pagi
                completion(indexPathWillAdds)
            }
        }
    }

    fileprivate func getUserData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.getDataFromFile(fileName: "user") { (userResponse: [User], _) in
                self?.users = userResponse
            }
        }
    }

    fileprivate func getDataFromFile<T>(fileName: String, completion: (_ data: [T], _ pagination: Pagination) -> ()) where T: Mappable {
        guard let jsonData = Data.dataFromJSONFile(fileName) else { return }

        do {
            let jsonObj = try JSON(data: jsonData)
            guard let dictionObject = jsonObj.dictionaryObject else { return }

            guard let listReponse = Mapper<ListResponseObject<T>>().map(JSON: dictionObject) else {
                return
            }

            completion(listReponse.data, listReponse.pagination!)
        } catch {
            print("Error \(error)")
            return
        }
    }
}

extension MessageViewModel {

    func getUserFromID(_ id: Int) -> User {
        let index = users.index(where: { $0.id == id })
        return users[index!]
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

    fileprivate func getIndexPathWillAdds(newDataSize: Int) -> [IndexPath] {
        let currentNumberMessage = messages.count
        let newNumberMessage = messages.count + newDataSize
        var indexPathWillAdds: [IndexPath] = []
        for index in currentNumberMessage..<newNumberMessage {
            indexPathWillAdds.append(IndexPath(row: index, section: 0))
        }

        return indexPathWillAdds
    }

}
