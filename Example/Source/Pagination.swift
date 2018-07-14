//
//  Pagination.swift
//  iOS Example
//
//  Created by Hoangtaiki on 7/13/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import ObjectMapper

struct Pagination: Mappable {

    private(set) var page: Int = 0
    private(set) var pages: Int = 0
    private(set) var total: Int = 0

    public init?(map: Map) {

    }

    mutating public func mapping(map: Map) {
        page <- map["page"]
        pages <- map["pages"]
        total <- map["total"]
    }
}
