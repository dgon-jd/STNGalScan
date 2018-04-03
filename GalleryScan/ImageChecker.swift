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
  var imageProviders = [ImageProvider]()
  let imageQueue = OperationQueue()

  func checkImages() {
//    imageQueue.maxConcurrentOperationCount = 1
    imageSaver.fetchAllsavedImages()
    let identifiers = imageFetcher.assetsFromLibrary()
    for identifier in identifiers {
      imageQueue.addOperation(ImageProvider(imageId: identifier, idc: imageSaver))
    }

    


  }

}
