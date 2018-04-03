//
//  BadImageSaveOperation.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation

class BadImageSaveOperation: ImageTakeOperation {
  var badImageCoreDataController: BadImageCoreDataController


  init(idc: BadImageCoreDataController, image: STNImageObj?) {
    badImageCoreDataController = idc
    super.init(image: image)
  }

  override func main() {
    if let id = self.inputImage?.assetId {
      badImageCoreDataController.saveAsset(id: id)
    }
  }
}

protocol AssetPass {
  var assetId: String? { get }
}
