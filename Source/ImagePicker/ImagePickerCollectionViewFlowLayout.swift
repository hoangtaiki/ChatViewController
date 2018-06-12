//
//  ImagePickerCollectionViewFlowLayout.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

class ImagePickerCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        setup()
    }

    private func setup() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: collectionView!.bounds.height, height: collectionView!.bounds.height)
        headerReferenceSize = CGSize(width: 90, height: collectionView!.bounds.height)
        minimumLineSpacing = 2
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
}
