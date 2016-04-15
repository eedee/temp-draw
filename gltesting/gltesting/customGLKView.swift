//
//  customGLKView.swift
//  gltesting
//
//  Created by Andrew Nadlman on 8/7/15.
//  Copyright © 2015 accretion. All rights reserved.
//

import GLKit
import OpenGLES

class customGLKView: GLKView {
  var data:[GLfloat] =
   [0.0, 0.0, 0.0,
    10.0, 0.0, 0.0,
    0.0, 10.0, 0.0]
  var scale1x: GLKMatrix4 = GLKMatrix4Identity
  var scale4x: GLKMatrix4 = GLKMatrix4Identity

  var effect: GLKBaseEffect? = nil

  var vertexArray: GLuint = 0
  var vertexBuffer: GLuint = 0

  var translateX:Float = 0

  //required init?(coder aDecoder: NSCoder) {
  //  super.init(coder: aDecoder)
  //}

  func setup() {
    self.context = EAGLContext(API: .OpenGLES2)

    self.drawableMultisample = GLKViewDrawableMultisample.Multisample4X //*****//
    self.enableSetNeedsDisplay = true
    self.drawableDepthFormat = GLKViewDrawableDepthFormat.Format16

    EAGLContext.setCurrentContext(self.context)

    self.effect = GLKBaseEffect()
    self.effect?.useConstantColor = GLboolean(GL_TRUE)
    self.effect?.constantColor = GLKVector4Make(0.0, 0.0, 1.0, 0.5)

    //glEnable(GLenum(GL_DEPTH_TEST))
    glEnable(GLenum(GL_BLEND))
    glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))

    glGenBuffers(1, &vertexBuffer)
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)

    glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
    glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 12, BUFFER_OFFSET(0))

    glBufferData(GLenum(GL_ARRAY_BUFFER), (data.count * 100), &data, GLenum(GL_DYNAMIC_DRAW))

    update()

    //self.effect?.transform.modelviewMatrix = GLKMatrix4Identity
  }

  func update() {
    print(bounds.width)
    print(bounds.height)
    let x = 2.0 / (Double(bounds.width)  * Double(contentScaleFactor)) * pixelsPerMillimeter
    let y = 2.0 / (Double(bounds.height) * Double(contentScaleFactor)) * pixelsPerMillimeter

    print(x)
    print(y)
    scale1x = GLKMatrix4MakeScale(GLfloat(x), GLfloat(y), 1.0)
    scale4x = GLKMatrix4MakeScale(GLfloat(x * 4.0), GLfloat(y * 4.0), 1.0)
  }

  override func drawRect(rect: CGRect) {
    glClearColor(0.8, 0.8, 0.8, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

    let offsetX:Float = 50.0
    let offsetY:Float = -50.0

    //let translate1x = GLKMatrix4Translate(GLKMatrix4Identity, translateX, 0.0, 0.0)
    //self.effect?.transform.projectionMatrix = GLKMatrix4Multiply(scale1x, translate1x)
    let translate1x = GLKMatrix4Translate(scale1x, translateX + offsetX, offsetY, 0.0)
    self.effect?.transform.projectionMatrix = translate1x
    self.effect?.constantColor = GLKVector4Make(0.0, 0.0, 1.0, 0.5)
    self.effect?.prepareToDraw()
    glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(9))

    //let translate4x = GLKMatrix4Translate(GLKMatrix4Identity, ((4.0 * translateX) + 5.0), -5.0, 0.0)
    //self.effect?.transform.projectionMatrix = GLKMatrix4Multiply(scale4x, translate4x)
    let translate4x = GLKMatrix4Translate(scale4x, (translateX), 0.0, 0.0)
    self.effect?.transform.projectionMatrix = translate4x
    self.effect?.constantColor = GLKVector4Make(0.0, 1.0, 0.0, 0.5)
    self.effect?.prepareToDraw()
    glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(9))
  }

  func BUFFER_OFFSET(i: Int) -> UnsafePointer<Void> {
    let p: UnsafePointer<Void> = nil
    return p.advancedBy(i)
  }

}