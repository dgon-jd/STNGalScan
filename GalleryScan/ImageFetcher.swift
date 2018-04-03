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

}
