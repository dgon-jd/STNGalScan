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
  
  func assetsFromLibrary(startModificationDate: Date? = nil) -> [String] {
    let fetchOptionsC = PHFetchOptions()
    let fetchOptions = PHFetchOptions()
    var identifiers = [String]()

    if let date = startModificationDate {
      fetchOptions.predicate = NSPredicate(format: "modificationDate > %@", argumentArray: [date])
    } else {
      fetchOptions.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: true)]
    }
    let collections:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptionsC)
    let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
    collections.enumerateObjects { (collection, count, stop) in
//      let fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
      fetchResult.enumerateObjects { (asset, count, stop) in
        identifiers.append(asset.localIdentifier)
      }
    }

    return identifiers
  }

  func assetIdentifiers(fetchResult: PHFetchResult<PHAsset>) -> [String] {
    var identifiers = [String]()
    fetchResult.enumerateObjects { (asset, count, stop) in
      identifiers.append(asset.localIdentifier)
    }
    return identifiers
  }

}
