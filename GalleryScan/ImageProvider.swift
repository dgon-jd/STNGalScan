//
//  ImageProvider.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit
class ImageProvider {

  private var operationQueue = OperationQueue ()
  let imageId: String
  let imageSaver = BadImageCoreDataController(completion: nil)
  init(imageId: String, completion: @escaping (_ success: Bool) -> (), idc: BadImageCoreDataController) {
    self.imageId = imageId
    operationQueue.maxConcurrentOperationCount = 1

    let imageFetcher = ImageFetchOperation(imageId: imageId)
    let dataLoad = ImageLoadOperation(image: nil)
    let saveOperation = BadImageSaveOperation(idc: idc, image: nil)

    let output = ImageOutputOperation(completion: completion)

    let operations = [imageFetcher, dataLoad, saveOperation]

    dataLoad.addDependency(imageFetcher)
    saveOperation.addDependency(imageFetcher)
    saveOperation.addDependency(dataLoad)
//    output.addDependency(dataLoad)


    operationQueue.addOperations(operations, waitUntilFinished: false)
  }

  func cancel() {
    operationQueue.cancelAllOperations()
  }

}


func ==(lhs: ImageProvider, rhs: ImageProvider) -> Bool {
  return lhs.imageId == rhs.imageId
}
