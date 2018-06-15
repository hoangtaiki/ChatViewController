//
//  FileInfo.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/14/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

enum FileType: Int {
    case image
    case attachment
}

struct FileInfo {

    var id: String
    var type: FileType = .image
    var originalURL: URL?
    var previewURL: URL?
    var createdAt: Date
    var width: CGFloat
    var height: CGFloat
    var caption: String = ""

    /// It is temporary. Because we will use URL at real.
    var image: UIImage?

    init(id: String, type: FileType, originalURL: URL? = nil,
         previewURL: URL?, createdAt: Date,
         width: CGFloat, height: CGFloat, caption: String = "",
         image: UIImage? = nil) {
        self.id = id
        self.type = type
        self.originalURL = originalURL
        self.previewURL = previewURL
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.caption = caption
        self.image = image
    }
}
