//
//  ImagePickerView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import Photos

open class ImagePickerView: UIView {
    
    /// Image Picker Helper
    open lazy var imagePickerHelper: ImagePickerHelperable = {
        let imagePickerHelper = ImagePickerHelper()
        
        return imagePickerHelper
    }()
    
    public var pickImageResult: ((_ image: UIImage?, _ imagePath: URL?, _ error: Error?) -> ())?

    public var collectionView: ImagePickerCollectionView!
    
    /// Parent View Controller
    weak var parentViewController: UIViewController? {
        didSet {
            imagePickerHelper.parentViewController = parentViewController
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        frame = bounds

        setUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
    }
    
    open func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerHelper.accessCamera()
        }
    }
    
    open func openLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerHelper.accessLibrary()
        }
    }
    
    private func setUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.87)

        collectionView = ImagePickerCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pickerDelegate = self
        addSubview(collectionView)

        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Pass actions to collection view
        collectionView.takePhoto = { [weak self] in
            self?.openCamera()
        }

        collectionView.showCollection = { [weak self] in
            self?.openLibrary()
        }
    }
}

extension ImagePickerView: ImagePickerCollectionViewDelegate {

    func didSelectImage(with localIdentifer: String) {
        guard let asset = PhotoDataManager.fetchAsset(with: localIdentifer) else { return }

        PhotoDataManager.requestImage(with: asset) { [weak self] image in
            DispatchQueue.global().async {
                image?.storeToTemporaryDirectory(completion: { (imagePath, error) in
                    if error != nil {
                        self?.pickImageResult?(nil, nil, error!)
                        return
                    }
                    self?.pickImageResult?(image, imagePath!, nil)
                })
            }
        }
    }
}

extension ImagePickerView: ImagePickerHelperResultDelegate {
    
    public func didFinishPickingMediaWithInfo(_ image: UIImage?, _ imagePath: URL?, _ error: Error?) {
        if error != nil {
            pickImageResult?(nil, nil, error!)
            return
        }
        pickImageResult?(image, imagePath!, nil)
    }
}
