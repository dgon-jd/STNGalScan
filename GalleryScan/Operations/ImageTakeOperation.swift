//
//  ImageTakeOperation.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 4/3/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import UIKit

protocol OperationObjectPass {
  associatedtype O
  var item: O? { get }
}

open class STNImageObj {
  var image: UIImage?
  var assetId: String?

  init(im: UIImage?, asId: String?) {
    image = im
    assetId = asId
  }
}



open class QueueOperation<Input, Output>: AsyncOperation {
  private let _input: Input?
  var output: Output?

  public init(input: Input? = nil) {
    _input = input
    super.init()
  }

  public var input: Input? {
    var inputObj: Input?
    if let input = _input {
      inputObj = input
    } else if let op = dependencies
      .filter({ $0 is QueueOperation<Any, Input> })
      .first as? QueueOperation<Any, Input> {
      inputObj = op.output
    }
    return inputObj
  }
}

extension QueueOperation: OperationObjectPass {
  typealias O = Output
  var item: O? {
    return output
  }
}


