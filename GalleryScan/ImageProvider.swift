//
//  ImageProvider.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit
class ImageProvider: Operation {

  private var operationQueue = OperationQueue ()
  let imageId: String
  let imageSaver = BadImageCoreDataController(completion: nil)
  var imageCoreDataController: BadImageCoreDataController!
  init(imageId: String, idc: BadImageCoreDataController) {
    imageCoreDataController = idc
    self.imageId = imageId
    operationQueue.maxConcurrentOperationCount = 1
  }

  override func main() {
    let imageFetcher = ImageFetchOperation(imageId: imageId)
    let dataLoad = ImageLoadOperation(image: nil)
    let saveOperation = BadImageSaveOperation(idc: imageCoreDataController, image: nil)
    let operations = [imageFetcher, dataLoad, saveOperation]

    dataLoad.addDependency(imageFetcher)
    saveOperation.addDependency(imageFetcher)
    saveOperation.addDependency(dataLoad)

    operationQueue.addOperations(operations, waitUntilFinished: false)
  }

  override func cancel() {
    operationQueue.cancelAllOperations()
    super.cancel()
  }

}

func ==(lhs: ImageProvider, rhs: ImageProvider) -> Bool {
  return lhs.imageId == rhs.imageId
}
