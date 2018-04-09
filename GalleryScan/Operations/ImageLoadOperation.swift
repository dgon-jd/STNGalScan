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
  public var inputImage: STNImageObj?
  public var batchId: String?
  
  public init(image: STNImageObj? = nil) {
    inputImage = image
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
      let id = "someBathId+\(arc4random_uniform(101))"
      self.batchId = id
      self.state = .finished
    }
    task.resume()
  }
}

public class BatchLoadOperation: AsyncOperation {
  private var url: URL? = URL(string: "http://imageUrl.com")
  public var batchId: String
  public var imageResults: [String : String]?
  public init(id: String) {
    batchId = id
    super.init()
  }

  override public func main() {
    if self.isCancelled { return}
    guard let batchURL = url else {return}
    let urlRequest = URLRequest(url: batchURL)
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      if self.isCancelled { return }

      self.imageResults = ["sdfdf": "true",
                     "sdfdgdd": "false"]
      self.state = .finished
    }
    task.resume()
  }
}
