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
public protocol PhotoDataManagerDelegate: class {
    // Trigger whenever PhotoDataManager update
    func photoDataManagerDidUpdate()
    // Image size need export
    func targetSize(for indexPath: IndexPath) -> CGSize
}

/// Options for PhotoDataManager
public struct PhotoDataManagerOptions {
    // Content mode for Image
    let contentMode: PHImageContentMode
    let requestOption: PHImageRequestOptions?
    // Number image need preload
    let preloadLength: Int
}

public final class PhotoDataManager: NSObject {

    // Photo Data Manager Delegate
    weak var delegate: PhotoDataManagerDelegate?
    // Photo Caching Image Manager
    private let imageManager: PHCachingImageManager
    // Options for
    private let options: PhotoDataManagerOptions
    // Photo Asset Result For PHCachingImageManager
    private var photoAssets: PHFetchResult<PHAsset>? {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.photoDataManagerDidUpdate()
            }
        }
    }

    public init(with options: PhotoDataManagerOptions, delegate: PhotoDataManagerDelegate) {
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

    /// Cache image for index path with target size from delegate
    public func cacheImage(for indexPath: IndexPath) {
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
    
    /// Stop caching and cancel all image request
    public func stopRequestAndCaching() {
        imageManager.stopCachingImagesForAllAssets()
    }

    /// Request Image for a PHAsset at index path
    /// We use index path to get target size from delegate
    /// - Parameters:
    ///   - asset: PHAsset
    ///   - indexPath: index path for item in stream line
    /// - Callbacks: Return an optional image and index path
    public func requestImage(for asset: PHAsset, at indexPath: IndexPath, completion: @escaping (UIImage?, IndexPath) -> ()) {
        guard
            let targetSize = delegate?.targetSize(for: indexPath)
            else {
                completion(nil, indexPath)
                return
        }
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: options.contentMode, options: options.requestOption) { (image, _) in
            completion(image, indexPath)
        }
    }

    public func photoCount() -> Int {
        return photoAssets?.count ?? 0
    }
}

extension PhotoDataManager {
    
    private func loadAssets() {
        imageManager.allowsCachingHighQualityImages = true
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        photoAssets = PHAsset.fetchAssets(with: options)
    }
}

extension PhotoDataManager {

    public func getAsset(for indexPath: IndexPath) -> PHAsset? {
        guard
            let photoAssets = photoAssets,
            indexPath.row < photoAssets.count else { return nil }
        return photoAssets.object(at: indexPath.row)
    }
    
    // Request UIImage with PHAsset
    public func requestImage(with asset: PHAsset, completion: @escaping (_ image: UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.deliveryMode = .fastFormat
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize,
                                  contentMode: .aspectFill, options: options) { (image, info) in
            completion(image)
        }
    }
    
    // Request player item for video PHAsset
    public func fetchPlayerItem(for video: PHAsset, callback: @escaping (AVPlayerItem) -> Void) {
        let videosOptions = PHVideoRequestOptions()
        videosOptions.deliveryMode = PHVideoRequestOptionsDeliveryMode.automatic
        videosOptions.isNetworkAccessAllowed = true
        imageManager.requestPlayerItem(forVideo: video, options: videosOptions, resultHandler: { playerItem, _ in
            if let playerItem = playerItem {
                callback(playerItem)
            }
        })
    }
}

extension PhotoDataManager: PHPhotoLibraryChangeObserver {

    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard
            let photoAssets = photoAssets,
            let changeDetails = changeInstance.changeDetails(for: photoAssets)
            else {
                return
        }

        self.photoAssets = changeDetails.fetchResultAfterChanges
    }
}
