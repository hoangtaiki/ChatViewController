//
//  ImagePickerHelper.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import MobileCoreServices

/// Protocol use to specify standard for ImagePickerHelper
public protocol ImagePickerHelperable {
    // We new a variable to store parent view controller to present ImagePickerController
    var parentViewController: UIViewController? { get set }
    // Open camera
    func accessCamera()
    // Open photo library
    func accessLibrary()
}

public class ImagePickerHelper: NSObject, ImagePickerHelperable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public weak var parentViewController: UIViewController?
    public weak var delegate: ImagePickerResultDelegate?

    public func accessPhoto(from sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]

        parentViewController?.present(imagePicker, animated: true, completion: nil)
    }
    
    /// Show Action Sheet to select
    public func takeOrChoosePhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.accessCamera()
        }
        alert.addAction(takePhoto)
        
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [weak self] _ in
            self?.accessLibrary()
        }
        alert.addAction(choosePhoto)
        
        parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true, completion: nil)
        }

        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeImage:
            guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }
            if #available(iOS 11.0, *) {
                guard let imagePath = info[UIImagePickerController.InfoKey.imageURL] as? String else {
                    return
                }
                delegate?.didSelectImage?(url: URL(string: imagePath))
            } else {
                DispatchQueue.main.async {
                    originalImage.storeToTemporaryDirectory(completion: { [weak self] (imagePath, error) in
                        guard let imageURL = imagePath else {
                            return
                        }
                        self?.delegate?.didSelectImage?(url: imageURL)
                    })
                }
            }
            
        case kUTTypeMovie:
            guard let videoPath = info[UIImagePickerController.InfoKey.mediaURL] as? String else {
                return
            }
            delegate?.didSelectVideo?(url: URL(string: videoPath))
        default: break
        }
    }
    
    public func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            accessPhoto(from: .camera)
        }
    }
    
    public func accessLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            accessPhoto(from: .photoLibrary)
        }
    }
    
}
