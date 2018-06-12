//
//  ImagePickerCollectionView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import Photos

@objc protocol ImagePickerCollectionViewDelegate {
    @objc optional func didSelectImage(with localIdentifer: String)
}

final class ImagePickerCollectionView: UICollectionView {

    var takePhoto: (() -> ())?
    var showCollection: (() -> ())?

    weak var pickerDelegate: ImagePickerCollectionViewDelegate?

    fileprivate var photoDataManager: PhotoDataManager!

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    func commonInit() {
        delegate = self
        dataSource = self

        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }

        backgroundColor = UIColor.black
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false


        register(ImagePickerCollectionCell.self,
                 forCellWithReuseIdentifier: ImagePickerCollectionCell.reuseIdentifier)
        register(ImagePickerCollectionHeader.self,
                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                 withReuseIdentifier: ImagePickerCollectionHeader.reuseIdentifier)

        createPhotoManager()
    }

    func createPhotoManager() {
        let options = PhotoDataManagerOptions(contentMode: .aspectFill,
                                              requestOption: nil,
                                              preloadLength: 5)
        photoDataManager = PhotoDataManager(with: options, delegate: self)
    }

    deinit {
        photoDataManager.stopRequestAndCaching()
    }
}

extension ImagePickerCollectionView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataManager.photoCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionCell.reuseIdentifier, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: ImagePickerCollectionHeader.reuseIdentifier,
                                                                         for: indexPath) as! ImagePickerCollectionHeader

        headerView.delegate = self
        headerView.spaceBetweenButtons = 60

        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        photoDataManager.requestImage(for: indexPath) { (image, indexPath) in
            guard let image = image else { return }
            guard collectionView.indexPathsForVisibleItems.contains(indexPath) else { return }
            guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCollectionCell else { return }

            cell.imageView.image = image
        }
    }

}

extension ImagePickerCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let localIdentifer = photoDataManager.photoIdentifier(for: indexPath.row)

        pickerDelegate?.didSelectImage?(with: localIdentifer)
    }

}

extension ImagePickerCollectionView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startCacheImages()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate != true else {
            return
        }

        startCacheImages()
    }
}

extension ImagePickerCollectionView {

    func startCacheImages() {
        guard let indexPath = self.indexPathsForVisibleItems.sorted().last else {
            return
        }
        photoDataManager.cacheImage(for: indexPath)
    }
}

extension ImagePickerCollectionView: PhotoDataManagerDelegate {

    func photoDataManagerDidUpdate() {
        performBatchUpdates({ [weak self] in
            self?.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
    }

    func targetSize(for indexPath: IndexPath) -> CGSize {
        let cell = cellForItem(at: indexPath)
        let height = cell?.bounds.size.height ?? bounds.height
        return CGSize(width: height * UIScreen.main.scale,
                      height: height * UIScreen.main.scale)
    }
}

extension ImagePickerCollectionView: ImagePickerCollectionHeaderDelegate {

    func showCollection(_ headerView: ImagePickerCollectionHeader) {
        showCollection?()
    }

    func takePhoto(_ headerView: ImagePickerCollectionHeader) {
        takePhoto?()
    }

}
