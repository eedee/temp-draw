//
//  LearnController.swift
//  gameTempTest
//
//  Created by Andrew Nadlman on 7/28/15.
//  Copyright © 2015 accretion. All rights reserved.
//

import GLKit
import OpenGLES

func BUFFER_OFFSET(i: Int) -> UnsafePointer<Void> {
  let p: UnsafePointer<Void> = nil
  return p.advancedBy(i)
}

var data:[GLfloat] = [] //need to add x, y, z data for each point
var howMany:Int = 0
var setupComplete = false

var currentSheet:Sheet = Sheet()

class LearnController: GLKViewController {

  var vertexArray: GLuint = 0
  var vertexBuffer: GLuint = 0

  var context: EAGLContext? = nil
  var effect: GLKBaseEffect? = nil

  override func viewDidLoad() {
    super.viewDidLoad()

    archive.addSheet(true)
    //currentSheet = archive.currentSheet

    self.context = EAGLContext(API: .OpenGLES2)
    if !(self.context != nil) { print("Failed to create ES context") }

    let view = self.view as! GLKView
    view.context = self.context!

    view.drawableMultisample = GLKViewDrawableMultisample.Multisample4X

    //let model = UIDevice.currentDevice().model
    calcBezier()
    setupGL()
  }

  func setupGL() {
    EAGLContext.setCurrentContext(self.context)

    self.effect = GLKBaseEffect()
    self.effect?.useConstantColor = GLboolean(GL_TRUE)
    self.effect?.constantColor = GLKVector4Make(1.0, 0.0, 0.0, 1.0)

    //glEnable(GLenum(GL_DEPTH_TEST))

    //glEnable(GLenum(GL_BLEND))
   // glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))

    glGenBuffers(1, &vertexBuffer)
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
    glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(sizeof(GLfloat) * howMany * 3), &data, GLenum(GL_STATIC_DRAW))

    glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
    glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 12, BUFFER_OFFSET(0))

    preferredFramesPerSecond = 30

    setupComplete = true
    update()
  }


  func tearDownGL() {
    print("tear down")
    EAGLContext.setCurrentContext(self.context)
    glDeleteBuffers(1, &vertexBuffer)
    self.effect = nil
  }


  func update() {
    paused = true

    //needs to be detected based on dimensions of device and device type on application load
    let px_per_in:GLfloat = 113.0 //113 macbook pro, 264 ipad air

    //needs to be set once and not reset every update loop
    let gl_per_px_x:GLfloat = 2.0 / GLfloat(view.bounds.width) / GLfloat(view.contentScaleFactor)
    let gl_per_px_y:GLfloat = 2.0 / GLfloat(view.bounds.height) / GLfloat(view.contentScaleFactor)
    let mm_per_in:GLfloat = 25.4

    let scale_x = gl_per_px_x * px_per_in / mm_per_in
    let scale_y = gl_per_px_y * px_per_in / mm_per_in

    let projectionMatrix = GLKMatrix4MakeScale(scale_x, scale_y, 1.0)
    self.effect?.transform.projectionMatrix = projectionMatrix
  }

  override func glkView(view: GLKView, drawInRect rect: CGRect) {
    if(setupComplete == true) {
      glClearColor(0.9, 0.9, 0.9, 1.0)
      glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))

      self.effect?.prepareToDraw()

      if setupComplete {
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, GLsizei(howMany))
        //let err = glGetError()
        //print(err)
      }
    }
  }

  deinit {
    self.tearDownGL()

    if EAGLContext.currentContext() === self.context {
      EAGLContext.setCurrentContext(nil)
    }
  }

  private struct xyVector {
    var x:Double = 0.0
    var y:Double = 0.0
  }

  private struct bezierPoint{
    var position:xyVector = xyVector()
    var tangent:xyVector = xyVector()
    var magnitude:Double = 0.0
    var normal:xyVector = xyVector()
  }

  func calcBezier() {
    let offset:[Double] = [0.7/2.0, 0.0, 0.35/2.0]

    var     c:  [bezierPoint] = [bezierPoint(), bezierPoint(), bezierPoint()]
    var  left:  [bezierPoint] = [bezierPoint(), bezierPoint(), bezierPoint()]
    var right:  [bezierPoint] = [bezierPoint(), bezierPoint(), bezierPoint()]

    //INITIALIZE ----------------------------------------------------------------------
    //initialize the curve with some dummy data
    c[0].position.x = -40.0
    c[0].position.y =   0.0
    c[1].position.x = -120.0
    c[1].position.y =  80.0
    c[2].position.x =  40.0
    c[2].position.y =   0.0

    /*
    c[0].position.x =  20.0
    c[0].position.y =   0.0
    c[1].position.x = -60.0
    c[1].position.y =  50.0
    c[2].position.x =  60.0
    c[2].position.y =   6.0
    */

    //DERIVATIVE ----------------------------------------------------------------------
    //calculate the derivative to find the tangent vector
    //tangent points B'(t) = 2 * (1 - t) * (P1 - P0) + 2 * t * (P2 - P1)

    c[0].tangent.x = 2.0 * (c[1].position.x - c[0].position.x)
    c[0].tangent.y = 2.0 * (c[1].position.y - c[0].position.y)

    c[2].tangent.x = 2.0 * (c[2].position.x - c[1].position.x)
    c[2].tangent.y = 2.0 * (c[2].position.y - c[1].position.y)

    //NORMALIZE AND ROTATE -----------------------------------------------------------
    //normalize the tangent vectors to unit length and rotate 90 degrees

    c[0].magnitude = sqrt( (c[0].tangent.x * c[0].tangent.x) + (c[0].tangent.y * c[0].tangent.y) )
    c[0].normal.x = -(c[0].tangent.y / c[0].magnitude)
    c[0].normal.y =  c[0].tangent.x / c[0].magnitude

    c[2].magnitude = sqrt( (c[2].tangent.x * c[2].tangent.x) + (c[2].tangent.y * c[2].tangent.y) )
    c[2].normal.x = -(c[2].tangent.y / c[2].magnitude)
    c[2].normal.y =  c[2].tangent.x / c[2].magnitude

    //OFFSET LINES ----------------------------------------------------------------------
    //offset the original point using the normal vector

    left[0].position.x = c[0].position.x - offset[0] * c[0].normal.x
    left[0].position.y = c[0].position.y - offset[0] * c[0].normal.y

    right[0].position.x = c[0].position.x + offset[0] * c[0].normal.x
    right[0].position.y = c[0].position.y + offset[0] * c[0].normal.y

    left[2].position.x = c[2].position.x - offset[2] * c[2].normal.x
    left[2].position.y = c[2].position.y - offset[2] * c[2].normal.y

    right[2].position.x = c[2].position.x + offset[2] * c[2].normal.x
    right[2].position.y = c[2].position.y + offset[2] * c[2].normal.y

    /*
    //POINT ON CURVE AT T = 1/2 -------------------------------------------------------
    //position points B(t) = (1-t)^2 * P0 + 2*(1-t)*t*P1 + t^t*P2
    var half = bezierPoint()

    half.position.x = (0.25 * c[0].position.x) + (0.50 * c[1].position.x) + (0.25 * c[2].position.x)
    half.position.y = (0.25 * c[0].position.y) + (0.50 * c[1].position.y) + (0.25 * c[2].position.y)

    //tangent points B'(t) = 2 * (1 - t) * (P1 - P0) + 2 * t * (P2 - P1)
    half.tangent.x = c[2].position.x - c[0].position.x
    half.tangent.y = c[2].position.y - c[0].position.y

    //find the normal vectors
    half.magnitude = sqrt( (half.tangent.x * half.tangent.x) + (half.tangent.y * half.tangent.y) )
    half.normal.x = -(half.tangent.y / half.magnitude)
    half.normal.y =  half.tangent.x / half.magnitude

    //find the offset points
    var halfL = xyVector()
    var halfR = xyVector()
    halfL.x = half.position.x - (offset * half.normal.x)
    halfL.y = half.position.y - (offset * half.normal.y)
    halfR.x = half.position.x + (offset * half.normal.x)
    halfR.y = half.position.y + (offset * half.normal.y)

    addLine(halfL, to: halfR)

    left[1].position.x = (2.0 * halfL.x) - (0.5 * (left[0].position.x + left[2].position.x))
    left[1].position.y = (2.0 * halfL.y) - (0.5 * (left[0].position.y + left[2].position.y))

    right[1].position.x = (2.0 * halfR.x) - (0.5 * (right[0].position.x + right[2].position.x))
    right[1].position.y = (2.0 * halfR.y) - (0.5 * (right[0].position.y + right[2].position.y))
    */

    left[1] = c[1]
    right[1] = c[1]

    //addLine(c[0].position, to: c[1].position)
    //addLine(c[1].position, to: c[2].position)


    left[1].position = intersect(left[0].position, b:c[0].tangent, c:left[2].position, d:c[2].tangent)
    //addLine(left[0].position, to: left[1].position)
    //addLine(left[1].position, to: left[2].position)

    right[1].position = intersect(right[0].position, b:c[0].tangent, c:right[2].position, d:c[2].tangent)
    //addLine(right[0].position, to: right[1].position)
    //addLine(right[1].position, to: right[2].position)

    //fixed step size
    let step:Double = 0.01
    let z = GLfloat(0.0)
    var t:Double

    /*
    for p in [left, c, right] {
      var last:xyVector = p[0].position
      var current:xyVector = last

      for t = 0.0; t <= 1.0; t += step {
        let f0:Double = 1.0 - t
        let f1:Double = f0 * f0
        let f2:Double = 2*f0*t
        let f3:Double = t * t

        current.x = f1 * p[0].position.x + f2 * p[1].position.x + f3 * p[2].position.x
        current.y = f1 * p[0].position.y + f2 * p[1].position.y + f3 * p[2].position.y
        addLine(last, to: current)

        last = current
      }
    }
    */

    for t = 0.0; t <= 1.0; t += step {
      let f0:Double = 1.0 - t
      let f1:Double = f0 * f0
      let f2:Double = 2*f0*t
      let f3:Double = t * t

      let xL = f1 * left[0].position.x + f2 * left[1].position.x + f3 * left[2].position.x
      let yL = f1 * left[0].position.y + f2 * left[1].position.y + f3 * left[2].position.y
      data.append(GLfloat(xL))
      data.append(GLfloat(yL))
      data.append(z)
      howMany++

      let xR = f1 * right[0].position.x + f2 * right[1].position.x + f3 * right[2].position.x
      let yR = f1 * right[0].position.y + f2 * right[1].position.y + f3 * right[2].position.y
      data.append(GLfloat(xR))
      data.append(GLfloat(yR))
      data.append(z)
      howMany++
    }

    io("left control", xy: left[1].position)
    io("right control", xy: right[1].position)
  }


  private func intersect(a:xyVector, b:xyVector, c:xyVector, d:xyVector)->xyVector {

    io("a", xy:a)
    io("b", xy:b)
    io("c", xy:c)
    io("d", xy:d)

    let f1:Double = d.x * (c.y - a.y)
    let f2:Double = d.y * (a.x - c.x)
    let f3:Double = (d.x * b.y) - (d.y * b.x)
    let  m:Double = (f1 + f2) / f3

    print(f1)
    print(f2)
    print(f3)
    print(m)

    let x:Double = a.x + (m * b.x)
    let y:Double = a.y + (m * b.y)

    return xyVector(x: x, y: y)
  }


  var began:Double = 0.0
  var pointCount:Int = 0

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let now = Double(CACurrentMediaTime())
    currentSheet.beginPath(now)
    let at = (touches.first!).locationInView(self.view)
    currentSheet.extendPath(now, x: Double(at.x), y: Double(at.y))

    began = now
    pointCount = 1
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let now = Double(CACurrentMediaTime())
    let at = (touches.first!).locationInView(self.view)
    currentSheet.extendPath(now, x: Double(at.x), y: Double(at.y))

    pointCount++
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let now = Double(CACurrentMediaTime())
    let at = (touches.first!).locationInView(self.view)
    currentSheet.extendPath(now, x: Double(at.x), y: Double(at.y))

    let elapsedTime = Double(now - began)
    var message = String(round(Double(pointCount)/elapsedTime))
    if(pointCount == 1) { message = "n/a" }
    print(message)


  }

  private func addLine(from: xyVector, to:xyVector) {
    data.append(GLfloat(from.x))
    data.append(GLfloat(from.y))
    data.append(GLfloat(0.0))
    howMany++

    data.append(GLfloat(to.x))
    data.append(GLfloat(to.y))
    data.append(GLfloat(0.0))
    howMany++
  }

  private func io(what:String, xy:xyVector) {
    var x:String = String(round(xy.x*10)/10)
    while(x.characters.count < 6) { x = " " + x }

    var y:String = String(round(xy.y*10)/10)
    while(y.characters.count < 5) { y = " " + y }

    print("x: \(x), y: \(y), \(what)")
  }

}

