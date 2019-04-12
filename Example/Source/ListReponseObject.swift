//
//  ListReponseObject.swift
//  iOS Example
//
//  Created by Hoangtaiki on 7/13/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Foundation

struct ListResponseObject<T: Decodable>: Decodable {

    var data: [T]
    var pagination: Pagination?
    
    enum CodingKeys: String, CodingKey {
        case data
        case meta
    }
    
    enum MetaKeys: String, CodingKey {
        case pagination
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decode([T].self, forKey: .data)
        let meta = try values.nestedContainer(keyedBy: MetaKeys.self, forKey: .meta)
        pagination = try meta.decode(Pagination.self, forKey: .pagination)
    }
}
