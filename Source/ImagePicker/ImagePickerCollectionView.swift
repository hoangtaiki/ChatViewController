//
//  ImagePickerCollectionView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import Photos

/// Image picker result
@objc public protocol ImagePickerResultDelegate {
    @objc optional func didSelectImage(url: URL?)
    @objc optional func didSelectVideo(url: URL?)
}

public final class ImagePickerCollectionView: UICollectionView {

    var takePhoto: (() -> ())?
    var showCollection: (() -> ())?

    weak var pickerDelegate: ImagePickerResultDelegate?

    fileprivate var nColumns = 1
    fileprivate var spacing: CGFloat = 2
    fileprivate var cellSize: CGSize = .zero
    fileprivate var lastHeight: CGFloat = 0
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

    func resetUI() {
        if photoDataManager.photoCount() > 0 {
            scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }

    func updateUI() {
        if lastHeight != bounds.height {
            lastHeight = bounds.height
            calculateProperties()
            layoutSubviews()
            reloadData()
        }
    }

    fileprivate func commonInit() {
        delegate = self
        dataSource = self

        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }

        backgroundColor = UIColor.black
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

        register(ImagePickerCollectionCell.self,
                 forCellWithReuseIdentifier: ImagePickerCollectionCell.reuseIdentifier)
        register(ImagePickerCollectionHeader.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: ImagePickerCollectionHeader.reuseIdentifier)

        createPhotoManager()
    }

    fileprivate func createPhotoManager() {
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

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataManager.photoCount()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionCell.reuseIdentifier, for: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: ImagePickerCollectionHeader.reuseIdentifier,
                                                                         for: indexPath) as! ImagePickerCollectionHeader

        headerView.delegate = self
        headerView.spaceBetweenButtons = 60
        headerView.layoutIfNeeded()

        return headerView
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let asset = photoDataManager.getAsset(for: indexPath) else {
            return
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.photoDataManager.requestImage(for: asset, at: indexPath) { (image, indexPath) in
                guard let image = image else { return }
                guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCollectionCell else { return }
                
                cell.imageView.image = image
            }
        }
        
        if asset.mediaType == .video {
            MediaProcesser.getVideoDuration(videoAsset: asset) { (duration, error) in
                if let videoDuration = duration {
                    DispatchQueue.main.async {
                        guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCollectionCell else { return }
                        cell.bindVideoDuration(duration: videoDuration)
                    }
                }
            }
        }
    }

}

extension ImagePickerCollectionView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 90, height: bounds.height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return nColumns == 2 ? spacing : 0
    }

}

extension ImagePickerCollectionView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let asset = photoDataManager.getAsset(for: indexPath) else {
            return
        }
        
        switch asset.mediaType {
        case .video:
            MediaProcesser.storeVideoToURL(videoAsset: asset) { [weak self] (url, error) in
                self?.pickerDelegate?.didSelectVideo?(url: url)
            }
        case .image:
            MediaProcesser.storeImage(imageAsset: asset) { [weak self] (url, error) in
                self?.pickerDelegate?.didSelectImage?(url: url)
            }
        default: break
        }
    }

}

extension ImagePickerCollectionView: UIScrollViewDelegate {

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startCacheImages()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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

    public func photoDataManagerDidUpdate() {
        performBatchUpdates({ [weak self] in
            self?.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
    }

    public func targetSize(for indexPath: IndexPath) -> CGSize {
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

extension ImagePickerCollectionView {

    private func calculateProperties() {
        if Utils.shared.isGreaterThanMaxHeight {
            nColumns = 2
            let cellWidth = (bounds.height - spacing) / CGFloat(nColumns)
            cellSize = CGSize(width: cellWidth, height: cellWidth)
        } else {
            nColumns = 1
            cellSize = CGSize(width: bounds.height, height: bounds.height)
        }
    }
}

