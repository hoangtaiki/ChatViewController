//
//  PhotoDataManager.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import Photos

/// PhotoDataManagerDelegate
protocol PhotoDataManagerDelegate: class {
    // Trigger whenever PhotoDataManager update
    func photoDataManagerDidUpdate()
    // Image size need export
    func targetSize(for indexPath: IndexPath) -> CGSize
}

/// Options for PhotoDataManager
struct PhotoDataManagerOptions {
    // Content mode for Image
    let contentMode: PHImageContentMode
    let requestOption: PHImageRequestOptions?
    // Number image need preload
    let preloadLength: Int
}

final class PhotoDataManager: NSObject {

    weak var delegate: PhotoDataManagerDelegate?

    private let imageManager: PHCachingImageManager
    private let options: PhotoDataManagerOptions
    // Array to store PHImage is being requested
    // We store to can cancel everytime we need
    private var requestIDs = [PHImageRequestID]()
    fileprivate var photoAssets: PHFetchResult<PHAsset>? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.photoDataManagerDidUpdate()
            }
        }
    }

    init(with options: PhotoDataManagerOptions, delegate: PhotoDataManagerDelegate) {
        self.options = options
        imageManager = PHCachingImageManager()
        self.delegate = delegate
        super.init()

        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.loadAssets()
                PHPhotoLibrary.shared().register(self)
            default:
                break
            }
        }
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func cacheImage(for indexPath: IndexPath) {
        guard
            let photoAssets = photoAssets,
            let targetSize = delegate?.targetSize(for: indexPath)
            else {
                return
        }

        var endIndex = indexPath.item + options.preloadLength
        if endIndex > photoAssets.count - 1 {
            endIndex = photoAssets.count - 1
        }
        let indexSet = IndexSet(integersIn: indexPath.item..<endIndex)
        let assets = photoAssets.objects(at: indexSet)
        imageManager.startCachingImages(for: assets, targetSize: targetSize, contentMode: options.contentMode, options: options.requestOption)
    }

    func requestImage(for indexPath: IndexPath, completion: @escaping (UIImage?, IndexPath) -> ()) {
        guard
            let photoAssets = photoAssets,
            indexPath.row < photoAssets.count,
            let targetSize = delegate?.targetSize(for: indexPath)
            else {
                completion(nil, indexPath)
                return
        }

        let asset = photoAssets.object(at: indexPath.row)
        let requestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: options.contentMode, options: options.requestOption) { (image, _) in
            completion(image, indexPath)
        }

        requestIDs.append(requestID)
    }

    func stopRequestAndCaching() {
        requestIDs.forEach { [unowned self] requestID in
            self.imageManager.cancelImageRequest(requestID)
        }

        imageManager.stopCachingImagesForAllAssets()
    }

    func photoCount() -> Int {
        return photoAssets?.count ?? 0
    }

    func photoIdentifier(for index: Int) -> String {
        guard
            let photoAssets = photoAssets,
            index < photoAssets.count else { return "" }
        let asset = photoAssets.object(at: index)
        return asset.localIdentifier
    }

    private func loadAssets() {
        imageManager.allowsCachingHighQualityImages = true
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        photoAssets = PHAsset.fetchAssets(with: options)
    }

    private func removeRequestID(_ requestID: PHImageRequestID) {
        if let index = requestIDs.index(where: { $0 == requestID }) {
            requestIDs.remove(at: index)
        }
    }
}

extension PhotoDataManager {

    // Request UIImage with PHAsset
    class func requestImage(with asset: PHAsset, completion: @escaping (_ image: UIImage?) -> Void) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.deliveryMode = .fastFormat
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize,
                             contentMode: .aspectFill, options: options) { (image, info) in
            completion(image)
        }
    }

    // Get PHAsset from localIdentifer
    class func fetchAsset(with localIdentifer: String ) -> PHAsset? {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifer], options: options).firstObject else {
            return nil
        }

        return asset
    }
}

extension PhotoDataManager: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard
            let photoAssets = photoAssets,
            let changeDetails = changeInstance.changeDetails(for: photoAssets)
            else {
                return
        }

        self.photoAssets = changeDetails.fetchResultAfterChanges
    }
}
