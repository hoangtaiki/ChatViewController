//
//  ImagePickerCollectionCell.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

public final class ImagePickerCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "ImagePickerCollectionCell"

    public var imageView: UIImageView!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    public func setupUI() {
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
