//
//  QMCoordinate.swift
//  KK
//
//  Created by sphota on 5/22/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation

class QMCoordiate: NSObject {
  var coordinate: CGPoint?
  var minterm: QMMinterm?
  var state: Bool?
  
  init(minterm: QMMinterm, state: Bool) {
    self.minterm = minterm
    self.state = state
  }
}
