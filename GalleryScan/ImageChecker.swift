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
  var batchIds: Set<String> = []
  var processedBatchIds: Set<String> = []
  let batchOperatingQueue = OperationQueue()
  let imageFetcher = ImageFetcher()
  let imageSaver = BadImageCoreDataController(completion: nil)
  var imageProviders = [ImageProvider]()
  let imageQueue = OperationQueue()

  init() {
    batchOperatingQueue.maxConcurrentOperationCount = 1
//    imageQueue.maxConcurrentOperationCount = 1
  }
  func checkImages() {
    imageSaver.fetchAllsavedImages()
    let identifiers = imageFetcher.assetsFromLibrary()
    for identifier in identifiers {
      imageQueue.addOperation(ImageProvider(imageId: identifier, idc: imageSaver, completion: { batchId in
        self.batchOperatingQueue.addOperation({
          self.batchIds.insert("\(batchId)+\(arc4random_uniform(101))")
          print(self.batchIds.count)
        })
      }))
    }

    


  }

}
