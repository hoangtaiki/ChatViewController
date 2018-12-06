//
//  Package.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 12/06/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "ChatViewController"
    dependencies: [
    	.package(url: "git@github.com:hoangtaiki/PlaceholderUITextView.git", from: "1.1.0")
    ],
    targets: [
    	.target(
    		name: "ChatViewController",
    		dependencies: ["PlaceholderUITextView"]
    	)
    ]
)
