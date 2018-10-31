//
//  UIImage+Extensions.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

extension UIImage {

    /// Store image into temporary directory
    /// - parameter completion: return imageURL and error if it exists
    func storeToTemporaryDirectory(completion: @escaping (_ imagePath: URL?, _ error: Error?) -> Void) {
        guard let data = jpegData(compressionQuality: 1.0) else { return }

        let timestamp = Int(Date().timeIntervalSince1970)
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let photoPath = tempDirectory.appendingPathComponent("\(timestamp)").appendingPathExtension("jpeg")

        do {
            try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
            try data.write(to: photoPath, options: Data.WritingOptions.atomic)

            completion(photoPath, nil)
        } catch {
            print(error.localizedDescription)
            completion(nil, error)
        }
    }
}
