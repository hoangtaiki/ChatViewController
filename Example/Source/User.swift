//
//  User.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/12/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import ChatViewController

struct User: Userable, Decodable {

    let id: Int
    let name: String
    let avatarURL: URL?

    var idNumber: String {
        get {
            return id.description
        }
    }

    var displayName: String {
        get {
            return name
        }
    }

    init(id: Int, name: String, avatarURL: URL? = nil) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "avatar_url"
    }
}
