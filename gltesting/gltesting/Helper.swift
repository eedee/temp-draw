//
//  Helper.swift
//  gameTempTest
//
//  Created by Andrew Nadlman on 8/4/15.
//  Copyright © 2015 accretion. All rights reserved.
//

import UIKit

let queue = dispatch_queue_create("serial-drawing", DISPATCH_QUEUE_SERIAL)

//var pixelsPerInch:Double = 0.0 //pixels per millimeter
var pixelsPerMillimeter:Double = 0.0 //pixels per millimeter
var millimetersPerPoint:Double = 0.0 //millimeters per apple point

func getPixelsPerInch()->Double {
  var width = UIScreen.mainScreen().bounds.width * UIScreen.mainScreen().scale
  var height = UIScreen.mainScreen().bounds.height * UIScreen.mainScreen().scale
  if width > height { swap(&width, &height) }

  //override the pixelsPerMillimeter calculation if working in the simulator
  if(UIDevice.currentDevice().name == "iPhone Simulator") { return 113.0 }

  return {
    switch (width, height) {
    case (1536.0, 2048.0): return 264.0 //iPad 3, iPad 4, iPad Air, iPad Air 2
    case  (768.0, 1024.0): return 132.0 //iPad 1, iPad 2
    case  (768.0, 1024.0): return 163.0 //iPad Mini 1
    case (1536.0, 2048.0): return 326.0 //iPad Mini 2, iPad Mini 3
    case (1242.0, 2208.0): return 401.0 //iphone 6 Plus
    case  (750.0, 1334.0): return 326.0 //iphone 6
    case  (640.0, 1136.0): return 326.0 //iPhone 5, iPhone 5C, iPhone 5S, iPod Touch 5g, iPod Touch 6g
    case  (640.0,  960.0): return 326.0 //iPhone 4, iPhone 4S, iPod Touch 4g
    case  (320.0,  480.0): return 163.0 //older iPhone models
    default:               return 113.0 //unknown device
    }
    }()
}

func getPixelsPerMillimeter()->Double {
  return (getPixelsPerInch() / 25.4)
}

func getPointsPerMillimeter()->Double {
  return (getPixelsPerMillimeter() / Double(UIScreen.mainScreen().scale))
}

struct vector2 {
  var x:Double = 0.0
  var y:Double = 0.0
}

func error() {
  let err = glGetError()
  if err != 0 {
    print(err.description)
  }
}

/*
func io(what:String, xy:vector2) {
var x:String = String(round(xy.x*10)/10)
while(x.characters.count < 6) { x = " " + x }
var y:String = String(round(xy.y*10)/10)
while(y.characters.count < 5) { y = " " + y }
print("x: \(x), y: \(y), \(what)")
}
*/