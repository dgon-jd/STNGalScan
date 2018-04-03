//
//  ImageLoadOperation.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePass {
  var image: STNImageObj? { get }
}

public class ImageLoadOperation: AsyncOperation {
  private var url: URL? = URL(string: "http://imageUrl.com")
  private let _inputImage: STNImageObj?

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

  public init(image: STNImageObj? = nil) {
    _inputImage = image
    super.init()
  }

  override public func main() {
    if self.isCancelled { return}
    guard let imageURL = url else {return}
    let urlRequest = URLRequest(url: imageURL)
    guard let image = inputImage?.image else {
      return
    }

    let task = URLSession.shared.uploadTask(with: urlRequest, from: UIImagePNGRepresentation(image)) { (data, response, error) in
      if self.isCancelled { return }
      print("Loaded")
      self.state = .finished

    }
    task.resume()
  }
}
