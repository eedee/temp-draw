//
//  Path.swift
//  gameTempTest
//
//  Created by Andrew Nadlman on 7/31/15.
//  Copyright © 2015 accretion. All rights reserved.
//

import UIKit

class Path {
  let began:Double  //when the path began in absolute time
  let color:UIColor         //the path color
  let width:Double             //the maximum line width
  let fixed:Bool
  let duo:Bool

  var x:[Double] = []
  var y:[Double] = []
  var t:[Double] = []
  var pointIndex:Int = -1 //index of most recently added point data

  var strip:[GLfloat] = []
  var stripIndex:Int = -1 //index of most recently added opengl vertex

  var duration:Double = 0       //the duration in seconds, redundant with the last t

  init(began:Double, color:UIColor, width:Double, fixed:Bool = false, duo:Bool = false) {
    self.began = began
    self.color = color
    self.width = width
    self.fixed = fixed
    self.duo = duo
  }

  func extendStrip() {
    //first point (pointIndex = 0)
    //go ahead and draw a full circle cenered at the touch point

    //second point (pointIndex = 1)
    //override the first point strip data (strip = 0)
    //draw a half circle end cap aligned to the line slope

    //not first point (pointIndex > 0)
    //overwrite the end cap strip points
    //draw the bezier paths and another half circle end cap
    //store the index BEFORE the last half circle for the next pass



    //print("extendStrip")
    /*
    let s = CGPoint(x: 0.0, y: 0.0)
    let c = CGPoint(x: 20.0, y: 100.0)
    let e = CGPoint(x: 40.0, y: 0.0)

    let step:CGFloat = 0.005

    var t:CGFloat
    for t = 0; t <= 1; t += step {
      let a = 1.0 - t
      let a2 = a * a
      let x = a2*s.x + 2*a*t*c.x + t*t*e.x
      let y = a2*s.y + 2*a*t*c.y + t*t*e.y
      let z = 0.0

      data.append(GLfloat(x))
      data.append(GLfloat(y))
      data.append(GLfloat(z))
    }
    how_many = GLsizei(data.count)
    */



  }
}
