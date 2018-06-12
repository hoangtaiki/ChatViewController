//
//  ImagePickerView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import Photos

public final class ImagePickerView: UIView {

    public var pickImageResult: ((_ image: UIImage?, _ imagePath: URL?, _ error: Error?) -> ())?

    var collectionView: ImagePickerCollectionView!
    var imagePickerHelper: ImagePickerHelper!
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

    func setUI() {
        collectionView = ImagePickerCollectionView(frame: .zero, collectionViewLayout: ImagePickerCollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.87)
        collectionView.pickerDelegate = self
        addSubview(collectionView)

        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        imagePickerHelper = ImagePickerHelper()
        collectionView.takePhoto = { [weak self] in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self?.imagePickerHelper.accessPhoto(from: .camera)
            }
        }

        collectionView.showCollection = { [weak self] in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self?.imagePickerHelper.accessPhoto(from: .photoLibrary)
            }
        }

        imagePickerHelper.pickImageResult = { [weak self] image, imagePath, error in
            if error != nil {
                self?.pickImageResult?(nil, nil, error!)
                return
            }
            self?.pickImageResult?(image, imagePath!, nil)
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
