//
//  Pagination.swift
//  iOS Example
//
//  Created by Hoangtaiki on 7/13/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Foundation

struct Pagination: Decodable {

    let page: Int
    let pageSize: Int
    let total: Int

    private enum CodingKeys: String, CodingKey {
        case page
        case pageSize = "page_size"
        case total
    }

    func hasMore() -> Bool {
        return page * pageSize < total
    }
}
