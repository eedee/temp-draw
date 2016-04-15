//
//  ViewController.swift
//  gltesting
//
//  Created by Andrew Nadlman on 8/7/15.
//  Copyright © 2015 accretion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBAction func Left(sender: AnyObject) {
    let glview = self.view as! customGLKView
    glview.translateX -= 1.0
    glview.update()
    glview.setNeedsDisplay()
  }
  @IBAction func Right(sender: AnyObject) {
    let glview = self.view as! customGLKView
    glview.translateX += 1.0
    glview.update()
    glview.setNeedsDisplay()
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    let glview = self.view as! customGLKView
    print(glview.bounds.size.width)
    print(glview.bounds.size.height)
    glview.setup()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

