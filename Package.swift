// swift-tools-version:4.2
//
//  Package.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 12/06/18.
//  Copyright © 2018 toprating. All rights reserved.
//
import PackageDescription

let package = Package(
    name: "ChatViewController",
    products: [
        .library(
            name: "ChatViewController",
            targets: ["ChatViewController"])
    ],
    dependencies: [
        .package(url: "https://github.com/hoangtaiki/PlaceholderUITextView", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "ChatViewController",
            dependencies: [.product(name: "PlaceholderUITextView", package: "PlaceholderUITextView")],
            path: "Source/"
        )
    ],
    swiftLanguageVersions: [.v4_2]
)
