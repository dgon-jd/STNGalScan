//
//  ImageOutputOperation.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit

public class ImageOutputOperation: ImageTakeOperation {

  private let completion: (_ success: Bool) -> ()

  public init(completion: @escaping (_ success: Bool) -> ()) {
    self.completion = completion
    super.init(image: nil)
  }

  override public func main() {
    if isCancelled { completion(false)}
    completion(true)
  }
}

