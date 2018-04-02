//
//  ViewController.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 3/27/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
let imageChecker = ImageChecker()
    override func viewDidLoad() {
    super.viewDidLoad()
      imageChecker.checkImages()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

