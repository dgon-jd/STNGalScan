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
    imageSaver.fetchAllsavedImages()
    let assets = imageFetcher.assetsFromLibrary()
    let identifiers = imageFetcher.assetIdentifiers(fetchResult: assets)
    for identifier in identifiers {
      imageQueue.addOperation(ImageProvider(imageId: identifier, idc: imageSaver))
    }

    


  }

}
