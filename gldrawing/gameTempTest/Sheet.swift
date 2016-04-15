//
//  Sheet.swift
//  gameTempTest
//
//  Created by Andrew Nadlman on 7/31/15.
//  Copyright © 2015 accretion. All rights reserved.
//

import UIKit

class Sheet {
  private var paths:[Path] = []
  private var index:Int = -1
  private var currentPath:Path? = nil

  var pathCount:Int = 0

  var erase:Bool = false
  var currentColor:UIColor = UIColor.blackColor()
  var currentWidth:Double = 0.7 //mm
  var fixedWidth:Bool = true
  var twoFingerErase:Bool = true

  func beginPath(began: Double) {
    paths.append(Path(began: began, color: currentColor, width: currentWidth, fixed: fixedWidth, duo: twoFingerErase))
    index++
    pathCount++

  }

  func extendPath(t:Double, x:Double, y:Double) {
    let currentPath = paths[index]
    currentPath.x.append(x)
    currentPath.y.append(y)
    currentPath.t.append(t)
    currentPath.pointIndex++
    currentPath.extendStrip()
    /*
    dispatch_async(dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)) {
      //do work in the background
      currentPath.extendStrip()
      /*
      dispatch_async(dispatch_get_main_queue()) {
      //do work back on the main thread here
      }
      */
    }
    */

  }

  func calculatePath() {

  }

  func renderPath() {

  }

  func clear() {
    //clears the sheet
  }

}
