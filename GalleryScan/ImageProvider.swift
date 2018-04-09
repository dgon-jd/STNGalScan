//
//  ImageProvider.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit
class ImageProvider: AsyncOperation {

  private var operationQueue = OperationQueue ()
  let imageId: String
  let imageSaver = BadImageCoreDataController(completion: nil)
  var imageCoreDataController: BadImageCoreDataController!
  var batchId: String?

  init(imageId: String, idc: BadImageCoreDataController) {
    imageCoreDataController = idc
    self.imageId = imageId
    operationQueue.maxConcurrentOperationCount = 1
  }

  override func main() {
    let imageFetcher = ImageFetchOperation(imageId: imageId)
    let dataLoad = ImageLoadOperation()
    let fetchLoadAdapter = BlockOperation {
      dataLoad.inputImage = imageFetcher.image
    }
    fetchLoadAdapter.addDependency(imageFetcher)
    dataLoad.addDependency(fetchLoadAdapter)

    let saveOperation = BadImageSaveOperation(idc: imageCoreDataController, image: nil, success: nil)
    let loadSaveAdapter = BlockOperation {
      saveOperation.inputImage = imageFetcher.image
      saveOperation.batchId = dataLoad.batchId
      self.batchId = dataLoad.batchId
    }
    loadSaveAdapter.addDependency(dataLoad)
    saveOperation.addDependency(imageFetcher)
    saveOperation.addDependency(loadSaveAdapter)
    let finishOperation = BlockOperation {
      self.state = .finished
    }

    finishOperation.addDependency(saveOperation)
    let operations = [imageFetcher, fetchLoadAdapter, dataLoad, loadSaveAdapter,saveOperation, finishOperation ]
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
