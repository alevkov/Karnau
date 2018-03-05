//
//  QMProductSum.swift
//  KK
//
//  Created by sphota on 9/27/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation

/* An abstract representation of a boolean expression as a sum of products */
class QMProductSum : NSObject {
  fileprivate let vars = ["A", "B", "C", "D", "E", "F"]
  internal var products : [QMMinterm] = []
  internal var strRepresentationOfProducts: [String] = []
  /* format: "ABC + ABC + ABC + . . ." */
  internal var stringValue : String
  internal var magnitude: UInt = 0
  internal var minCount: Int {
    get {
      return products.count
    }
  }
  
  init(withProducts: [QMMinterm], magnitude: UInt) {
    self.magnitude = 0
    self.stringValue = ""
    self.products = withProducts
  }
  
  func addProduct(_ product: QMMinterm) {
    self.products.append(product)
  }
  
  func convertToLetters() -> String {
    guard self.stringValue != "1" else { return self.stringValue }
    var strval = ""
    for p in products {
      if strval != "" {
        strval += "+"
      }
      for i in 0 ..< p.stringValue.count {
        if p.stringValue[i] == Character("1") {
          strval += self.vars[i]
        }
        else if p.stringValue[i] == Character("0") {
          strval += self.vars[i] + "'"
        }
        else {
          strval += ""
        }
      }
    }
    self.stringValue = strval
    self.convertToStringArray()
    return self.stringValue
  }
  
  func convertToStringArray() {
    self.strRepresentationOfProducts = self.stringValue.components(separatedBy: "+")
  }
  
  func print () {
    self.convertToLetters()
    Swift.print(self.stringValue)
  }
}

/* Equatable */

func ==(lhs: QMProductSum, rhs: QMProductSum) -> Bool {
  let lset = Set(lhs.strRepresentationOfProducts)
  let rset = Set(rhs.strRepresentationOfProducts)
  return lset == rset
}

