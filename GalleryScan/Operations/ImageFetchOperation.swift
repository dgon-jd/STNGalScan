//
//  ImageFetchOperation.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit
import Photos

public class ImageFetchOperation : AsyncOperation {

  var outputImage: STNImageObj?

  private let _imageId: String
  public init(imageId: String) {
    _imageId = imageId
    super.init()
  }

  override public func main() {
    if self.isCancelled { return }
    let savedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [_imageId], options: nil)
    if self.isCancelled { return }
    if let asset = savedAssets.firstObject {
      self.image(asset: asset, targetSize: CGSize(width: 100, height: 100), success: { image in
        if self.isCancelled { return }
        self.outputImage = STNImageObj(im: image, asId: self._imageId)
        self.state = .finished
        print(image)

      })
    }
  }

  func image(asset: PHAsset, targetSize: CGSize, success: @escaping ((_ image: UIImage) -> Void)) {
    if self.isCancelled { return }
    let requestOptions = PHImageRequestOptions()
    requestOptions.resizeMode = .fast
    requestOptions.deliveryMode = .fastFormat
    requestOptions.isSynchronous = true

    let imageManager = PHImageManager.default()
    imageManager.requestImage(for: asset,
                              targetSize: targetSize,
                              contentMode: PHImageContentMode.default,
                              options: requestOptions,
                              resultHandler: { (image, info) in
                                if self.isCancelled { return }
                                autoreleasepool {
                                  if let image = image {
                                    success(image)
                                  }
                                }
    })
  }
}


extension ImageFetchOperation: ImagePass {
  var image: STNImageObj? {
    return outputImage
  }
}
