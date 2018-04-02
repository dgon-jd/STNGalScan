//
//  ImageChecker.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 3/28/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit

class ImageChecker {
  let imageFetcher = ImageFetcher()
  let imageSaver = BadImageCoreDataController(completion: nil)

  func checkImages() {
    let assets = imageFetcher.assetsFromLibrary()
    let identifiers = imageFetcher.assetIdentifiers(fetchResult: assets)
 
    for identifier in identifiers {
      let queue = DispatchQueue(label: "ImageProcessing" + identifier)

      queue.async { [weak self] in
         let  queueName = String(cString: __dispatch_queue_get_label(nil), encoding: .utf8)
        self?.imageFetcher.asset(identifier: identifier, success: { [weak self] asset in
          print("\(asset) from \(String(describing: queueName))")
          self?.imageSaver.saveAsset(id: asset.localIdentifier)
          self?.imageFetcher.image(asset: asset, targetSize: CGSize(width: 100, height: 100), success: { [weak self] image in
            print("\(image) from \(String(describing: queueName))")
          })
        })
      }
    }

//    imageSaver.fetchAllsavedImages()

  }

}
