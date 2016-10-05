//
//  Constants.swift
//  KK
//
//  Created by sphota on 5/21/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation

let on = true
let off = false

// Notifications

let didSelectGroupNotification = "QMDidSelectGroupOnMap"
let didCallForCheckEquationNotification = "QMDidCallForCheckEquation"
let didResetTableOnMapViewNotification = "QMDidResetTableOnMapView"
let didCheckEquationNotification = "QMDidCheckEquation"

// QMCore
let maxMagnitude: UInt = 6
let implicantFlag: UInt  = 999
let primeFlag: UInt = 888

// Geometry
let mapSizeSquare: CGFloat = 300
let mapSizeRectWidth: CGFloat = 200
let mapSizeRectHeight: CGFloat = 300

// Color
let bgColor = UIColor(hex: 0x0E2430, alpha: 1.0)
let errColor = UIColor(hex: 0x0E3024, alpha: 1.0)
let mapBtnHighlightedColor = UIColor(hex: 0xFC3A51)
let normalGroupColor = UIColor(hex: 0x50E3C2, alpha: 1.0)
let wrapAroundGroupColor = UIColor(hex: 0xE62165, alpha: 1.0)
