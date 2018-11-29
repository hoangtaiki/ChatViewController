//
//  ImagePickerType.swift
//  iOS Example
//
//  Created by Hoangtaiki on 11/28/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import ChatViewController

extension ImagePickerType {
    
    var description: String {
        switch self {
        case .slack:
            return "Slack"
        case .actionSheet:
            return "Action Sheet"
        }
    }
}

