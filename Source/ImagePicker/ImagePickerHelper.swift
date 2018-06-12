//
//  ImagePickerHelper.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

public class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var parentViewController: UIViewController?
    var pickImageResult: ((_ image: UIImage?, _ imagePath: URL?, _ error: Error?) -> ())?

    public func accessPhoto(from sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType

        parentViewController?.present(imagePicker, animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true, completion: nil)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                return
            }

            originalImage.storeToTemporaryDirectory(completion: { (imagePath, error) in
                if error != nil {
                    self.pickImageResult?(nil, nil, error!)
                    return
                }
                self.pickImageResult?(originalImage, imagePath!, nil)
            })
        }
    }
}
