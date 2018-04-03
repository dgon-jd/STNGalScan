//
//  ImageFetcher.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 3/27/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import Photos

open class ImageFetcher {
  
  func assetsFromLibrary(startModificationDate: Date? = nil) -> PHFetchResult<PHAsset> {
    let fetchOptions = PHFetchOptions()
    if let date = startModificationDate {
      fetchOptions.predicate = NSPredicate(format: "modificationDate > %@", argumentArray: [date])
    } else {
      fetchOptions.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: true)]
    }
    
    let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
    return fetchResult
  }

  func assetIdentifiers(fetchResult: PHFetchResult<PHAsset>) -> [String] {
    var identifiers = [String]()
    fetchResult.enumerateObjects { (asset, count, stop) in
      identifiers.append(asset.localIdentifier)
    }
    return identifiers
  }

  class func asset(identifier: String, success: @escaping ((_ asset: PHAsset) ->Void)) {
      let savedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
      if let asset = savedAssets.firstObject {
        success(asset)
      }
  }


  func image(asset: PHAsset, targetSize: CGSize, success: @escaping ((_ image: UIImage) -> Void)) {
      let requestOptions = PHImageRequestOptions()
      requestOptions.resizeMode = .fast
      requestOptions.deliveryMode = .fastFormat
      requestOptions.isSynchronous = true

      let imageManager = PHImageManager.default()
      imageManager.requestImage(for: asset,
                                targetSize: targetSize,
                                contentMode: PHImageContentMode.default,
                                options: requestOptions,
                                resultHandler: { (image, info) in
                                  autoreleasepool {
                                    if let image = image {
                                      success(image)
                                    }
                                  }
      })
  }

}
