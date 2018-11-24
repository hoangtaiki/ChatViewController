//
//  ImagePickerCollectionHeader.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

@objc protocol ImagePickerCollectionHeaderDelegate {
    @objc optional func takePhoto(_ headerView: ImagePickerCollectionHeader)
    @objc optional func showCollection(_ headerView: ImagePickerCollectionHeader)
}

class ImagePickerCollectionHeader: UICollectionReusableView {

    static let reuseIdentifier = "ImagePickerCollectionHeader"

    var takePhotoButton: UIButton!
    var showCollectionButton: UIButton!
    var delegate: ImagePickerCollectionHeaderDelegate?
    var topLayoutContraint: NSLayoutConstraint!
    var bottomLayoutContraint: NSLayoutConstraint!
    var takePhotoButtonHeightContraint: NSLayoutConstraint!
    var showCollectionButtonHeightContraint: NSLayoutConstraint!
    var buttonHeight: CGFloat = 23 {
        didSet {
            updateContraints()
        }
    }
    var spaceBetweenButtons: CGFloat = 48 {
        didSet {
            updateContraints()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    fileprivate func setupUI() {
        takePhotoButton = UIButton()
        let photoImage = UIImage(named: "ic_camera", in: Bundle.chatBundle, compatibleWith: nil)
        takePhotoButton.setImage(photoImage, for: UIControl.State())
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.addTarget(self, action: #selector(takePhotoTapped(_:)), for: .touchUpInside)
        takePhotoButton.imageView?.contentMode = .scaleAspectFit

        showCollectionButton = UIButton()
        let collectionImage = UIImage(named: "ic_collection", in: Bundle.chatBundle, compatibleWith: nil)
        showCollectionButton.setImage(collectionImage, for: UIControl.State())
        showCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        showCollectionButton.addTarget(self, action: #selector(showCollection(_:)), for: .touchUpInside)
        showCollectionButton.imageView?.contentMode = .scaleAspectFit


        addSubview(takePhotoButton)
        addSubview(showCollectionButton)

        takePhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topLayoutContraint = takePhotoButton.topAnchor.constraint(equalTo: topAnchor)
        topLayoutContraint.isActive = true
        takePhotoButtonHeightContraint = takePhotoButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        takePhotoButtonHeightContraint.isActive = true

        showCollectionButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        showCollectionButtonHeightContraint = showCollectionButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        showCollectionButtonHeightContraint.isActive = true
        bottomLayoutContraint = showCollectionButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomLayoutContraint.isActive = true
    }

    fileprivate func updateContraints() {
        let inset = bounds.height - buttonHeight * 2 - spaceBetweenButtons
        topLayoutContraint.constant = inset * 0.5
        bottomLayoutContraint.constant = -inset * 0.5

        takePhotoButtonHeightContraint.constant = buttonHeight
        showCollectionButtonHeightContraint.constant = buttonHeight
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateContraints()
    }

    @objc fileprivate func takePhotoTapped(_ sender: Any) {
        delegate?.takePhoto?(self)
    }

    @objc fileprivate func showCollection(_ sender: Any) {
        delegate?.showCollection?(self)
    }
}
