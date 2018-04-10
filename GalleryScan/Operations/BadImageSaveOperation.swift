//
//  BadImageSaveOperation.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit

class BadImageSaveOperation: AsyncOperation {
  var badImageCoreDataController: BadImageCoreDataController
  public var inputImage: STNImageObj?

  init(idc: BadImageCoreDataController, image: STNImageObj?) {
    badImageCoreDataController = idc
    inputImage = image
  }

  override func main() {
    if (self.inputImage?.assetId) != nil {
      badImageCoreDataController.saveAsset(item: inputImage!, success: {
        self.state = .finished
      })
    }
  }
}

protocol AssetPass {
  var assetId: String? { get }
}
