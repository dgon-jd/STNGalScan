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
  var batchIdsToProcess: Set<String> = []
  var processedBatchIds: Set<String> = []
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
    imageSaver.fetchAllsavedImages()
    let identifiers = imageFetcher.assetsFromLibrary()
    for identifier in identifiers {
      let operation = ImageProvider(imageId: identifier, idc: imageSaver)
      operation.completionBlock = {
        if let id = operation.batchId, !self.processedBatchIds.contains(id) {
          self.batchOperatingQueue.addOperation({
            self.batchIdsToProcess.insert(id)
          })
        }
        print(self.batchIdsToProcess.count)
      }
      imageQueue.addOperation(operation)
    }
  }

  @objc func checkBatches() {
    print("Processing batches: \(self.batchIdsToProcess)")
    if batchIdsToProcess.isEmpty {
      processedBatchIds.removeAll()
    }
    for batchId in batchIdsToProcess {
      let operation = BatchLoadOperation(id: batchId)
      operation.completionBlock = {
        self.batchOperatingQueue.addOperation {
          self.batchIdsToProcess.remove(batchId)
          self.processedBatchIds.insert(batchId)
          print("Done batches: \(self.processedBatchIds)")
        }
      }
      batchOperatingQueue.addOperation(operation)
    }
  }
}
