//
//  ObjectMapper.swift
//  iOS Example
//
//  Created by Hoangtaiki on 7/13/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import ObjectMapper

public class RFC3339DateTransform2: TransformType {
    public typealias Object = Date
    public typealias JSON = String

    private let dateFormatter: DateFormatter

    public init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    }

    public func transformFromJSON(_ value: Any?) -> Date? {
        if let timeStr = value as? String {
            return dateFormatter.date(from: timeStr)
        }

        return nil
    }

    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
