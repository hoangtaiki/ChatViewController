//
//  User.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/12/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import ObjectMapper
import ChatViewController

struct User: Userable, Mappable {

    var id: Int!
    var name: String = ""
    var avatarURL: URL?

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


    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        avatarURL <- (map["avatar_url"], URLTransform())
    }
}
