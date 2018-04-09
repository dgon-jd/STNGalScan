//
//  ImageChecker.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 3/28/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit

enum BatchStatus {
  case waiting, pending, processed
}

class ImageChecker {
  var batches: [String: BatchStatus] = [:]
  let batchOperatingQueue = OperationQueue()
  let imageFetcher = ImageFetcher()
  let imageSaver = BadImageCoreDataController(completion: nil)
  var imageProviders = [ImageProvider]()
  let imageQueue = OperationQueue()
  var batchTimer: Timer!
  init() {
    batchOperatingQueue.maxConcurrentOperationCount = 1
    batchTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkBatches), userInfo: nil, repeats: true)
//    imageQueue.maxConcurrentOperationCount = 1
  }
  func checkImages() {
    batches.removeAll()
    imageSaver.fetchAllsavedImages()
    let identifiers = imageFetcher.assetsFromLibrary()
    for identifier in identifiers {
      let operation = ImageProvider(imageId: identifier, idc: imageSaver)
      operation.completionBlock = {
        if let id = operation.batchId {
          self.addToWaitList(batchId: id)
        }
        print(self.batches.count)
      }
      imageQueue.addOperation(operation)
    }
  }

  func addToWaitList(batchId: String) {
    if self.batches[batchId] == nil {
      self.batchOperatingQueue.addOperation({
        self.batches[batchId] = .waiting
      })
    }
  }
  @objc func checkBatches() {
    print("Processing batches: \(batches)")
    for (batchId, status) in batches {
      if status == .waiting {
        batches[batchId] = .pending
        let operation = BatchLoadOperation(id: batchId)
        operation.completionBlock = {
          self.batchOperatingQueue.addOperation {
            self.batches[batchId] = operation.batchSucessfullyFinished ? .processed : .waiting
            self.cancelOperationsForBatchId(id: batchId)
            print("Processing batches: \(self.batches)")
          }
        }
        batchOperatingQueue.addOperation(operation)
      }
    }
  }

  func cancelOperationsForBatchId(id: String) {
    let operationsToCancel = batchOperatingQueue.operations
      .filter { $0 is BatchLoadOperation }
      .filter {
        let op = $0 as! BatchLoadOperation
        return op.batchId == id
    }
    for op in operationsToCancel {
      op.cancel()
    }
  }
}
