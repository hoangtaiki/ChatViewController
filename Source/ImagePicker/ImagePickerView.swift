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
        imagePickerHelper.delegate = self
        
        return imagePickerHelper
    }()
    
    public var collectionView: ImagePickerCollectionView!
    
    public weak var pickerDelegate: ImagePickerResultDelegate?

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
        imagePickerHelper.accessCamera()
    }
    
    open func openLibrary() {
        imagePickerHelper.accessLibrary()
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

extension ImagePickerView: ImagePickerResultDelegate {
    
    public func didSelectImage(url: URL?) {
        pickerDelegate?.didSelectImage?(url: url)
    }
    
    public func didSelectVideo(url: URL?) {
        pickerDelegate?.didSelectVideo?(url: url)
    }
}
