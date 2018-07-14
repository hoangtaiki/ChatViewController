//
//  ListReponseObject.swift
//  iOS Example
//
//  Created by Hoangtaiki on 7/13/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Foundation
import ObjectMapper

struct ListResponseObject<T: Mappable>: Mappable {

    private(set) var data: [T] = []
    private(set) var pagination: Pagination?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        data <- map["data"]
        pagination <- map["meta.pagination"]
    }

}
