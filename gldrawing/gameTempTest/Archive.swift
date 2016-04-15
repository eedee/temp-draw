//
//  Archive.swift
//  gameTempTest
//
//  Created by Andrew Nadlman on 7/31/15.
//  Copyright © 2015 accretion. All rights reserved.
//

import Foundation

class Archive {
  private var sheets:[Sheet] = []
  var sheetCount:Int = 0
  var sheetIndex:Int = -1
  var currentSheet:Sheet? = nil

  
  init() {

  }


  func addSheet(makeCurrent:Bool) {
    print("add sheet")
    sheetCount++

    sheets.append(Sheet())

    if makeCurrent {
      sheetIndex = sheets.count - 1
      currentSheet = sheets[sheetIndex]
    }
  }


  func removeSheet(removeIndex:Int) {
    print("remove sheet")

    if(sheetIndex == removeIndex) {
      //if the sheet is the current sheet, don't delete it without changing the view first
    } else {
      //if the sheet is not the current sheet, remove it right away
      sheets.removeAtIndex(removeIndex)
    }
  }


  enum tools {
    case penFixed
    case penVariable
    case eraserFixed
    case eraserVariable
  }


}
