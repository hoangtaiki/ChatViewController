//
//  FileInfo.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/14/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import ObjectMapper

enum FileType: Int {
    case image = 0
    case attachment
}

struct FileInfo: Mappable {

    private(set) var id: String!
    private(set) var type: FileType = .image
    private(set) var originalURL: URL?
    private(set) var previewURL: URL?
    private(set) var createdAt: Date!
    private(set) var width: CGFloat!
    private(set) var height: CGFloat!
    private(set) var caption: String = ""

    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }

    public mutating func mapping(map: Map) {
        id <- map["id"]
        type <- (map["type"], EnumTransform<FileType>())
        originalURL <- (map["url"], URLTransform())
        previewURL <- (map["thumb_url"], URLTransform())
        createdAt <- (map["created_at"], RFC3339DateTransform2())
        width <- map["width"]
        height <- map["height"]
        caption <- map["caption"]
    }
}
