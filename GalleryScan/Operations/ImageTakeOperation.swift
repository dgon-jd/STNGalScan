//
//  ImageTakeOperation.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit

open class STNImageObj {
  var image: UIImage?
  var assetId: String?

  init(im: UIImage?, asId: String?) {
    image = im
    assetId = asId
  }
}

open class ImageTakeOperation: Operation {
  var outputImage: STNImageObj?
  private let _inputImage: STNImageObj?

  public init(image: STNImageObj? = nil) {
    _inputImage = image
    super.init()
  }

  public var inputImage: STNImageObj? {
    var image: STNImageObj?
    if let inputImage = _inputImage {
      image = inputImage
    } else if let dataProvider = dependencies
      .filter({ $0 is ImagePass })
      .first as? ImagePass {
      image = dataProvider.image
    }
    return image
  }
}

extension ImageTakeOperation: ImagePass {
  var image: STNImageObj? {
    return outputImage
  }
}
