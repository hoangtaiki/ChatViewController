//
//  User.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/12/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import ChatViewController

struct User: Userable {

    var id: String
    var name: String
    var image: UIImage

    init(id: String, name: String, image: UIImage) {
        self.id = id
        self.name = name
        self.image = image
    }
}
