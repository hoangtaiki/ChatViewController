//
//  MediaProcesser.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 12/8/18.
//

import UIKit
import Photos
import AVFoundation

class MediaProcesser {
    
    /// Creates an output path and removes the file in temp folder if existing
    ///
    /// - Parameters:
    ///   - temporaryFolder: Save to the temporary folder or somewhere else like documents folder
    ///   - suffix: the file name wothout extension
    static func makeVideoPathURL(withPathExtension pathExtension: String) -> URL {
        let timestamp = Int(Date().timeIntervalSince1970)
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let outputURL = tempDirectory.appendingPathComponent("\(timestamp)").appendingPathExtension(pathExtension)

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: outputURL.path) {
            do {
                try fileManager.removeItem(atPath: outputURL.path)
            } catch {
                print("VideoProcessor -> Can't remove the file for some reason.")
            }
        }
        
        return outputURL
    }
    
    static func storeVideoToURL(videoAsset: PHAsset, completion: @escaping (_ videoPath: URL?, _ error: Error?) -> Void) {
        let options = PHVideoRequestOptions()
        options.version = .current
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        
        let imageManager = PHCachingImageManager()
        imageManager.requestAVAsset(forVideo: videoAsset, options: options) { (asset, _, _) in
            guard let avURLAsset = asset as? AVURLAsset else {
                return
            }
            do {
                let pathExtension = avURLAsset.url.pathExtension
                let outputPath = makeVideoPathURL(withPathExtension: pathExtension)
                try FileManager.default.copyItem(at: avURLAsset.url, to: outputPath)
                completion(outputPath, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
    
    static func storeImage(imageAsset: PHAsset, completion: @escaping (_ imagePath: URL?, _ error: Error?) -> Void) {
        let options = PHImageRequestOptions()
        options.version = .current
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat

        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: imageAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { result, info in
            guard let image = result else {
                return
            }
            
            guard let data = image.jpegData(compressionQuality: 1.0) else { return }
            let timestamp = Int(Date().timeIntervalSince1970)
            let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            let photoPath = tempDirectory.appendingPathComponent("\(timestamp)").appendingPathExtension("jpeg")

            do {
                try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
                try data.write(to: photoPath, options: Data.WritingOptions.atomic)
                
                completion(photoPath, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
    
    static func getVideoDuration(videoAsset: PHAsset, completion: @escaping (_ duration: Double?, _ error: Error?) -> Void) {
        let options = PHVideoRequestOptions()
        options.version = .current
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .fastFormat
        
        let imageManager = PHCachingImageManager()
        imageManager.requestAVAsset(forVideo: videoAsset, options: options) { (asset, _, _) in
            guard let duration = asset?.duration  else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Can't get asset"])
                completion(nil, error)
                return
            }
            completion(Double(CMTimeGetSeconds(duration)), nil)
        }
    }

    
}


