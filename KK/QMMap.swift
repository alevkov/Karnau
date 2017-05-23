//
//  QMMap.swift
//  KK
//
//  Created by sphota on 5/22/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation

class QMMap: NSObject {
	var minterms = [QMCoordiate]()
	var bounds: CGRect?
	var magnitude: UInt = 0
	
	init(minterms: [UInt], magnitude: UInt, bounds: CGRect) {
		self.magnitude = magnitude
		self.bounds = bounds
		let range = pow(Double(2), Double(self.magnitude))
		if magnitude == 0 { return }
		for m in (0...Int(range) - 1) {
			let min = QMMinterm(i: UInt(m), m: magnitude)
			let c = QMCoordiate(minterm: min, state: off)
			self.minterms.insert(c, at: m)
		}
		for m in minterms {
			self.minterms[Int(m)].state = on
		}
	}
	
	func point(_ a: CGFloat, _ b: CGFloat) -> CGPoint {
		return CGPoint(x: a, y: b)
	}
	
	func initCoordinates() {
		let w = self.bounds!.width
		switch self.magnitude {
		case 2:
			let orig = point(self.bounds!.maxX * 0.25, self.bounds!.maxY * 0.25)
			self.minterms[0].coordinate = orig
			self.minterms[1].coordinate = point(orig.x + w / 2, orig.y)
			self.minterms[2].coordinate = point(orig.x, orig.y + self.bounds!.height / 2)
			self.minterms[3].coordinate = point(orig.x + w / 2, orig.y + self.bounds!.height / 2)
			break
		case 3:
			let orig = point(self.bounds!.maxX * 0.25, self.bounds!.maxY * 0.125)
			self.minterms[0].coordinate = orig
			self.minterms[1].coordinate = point(orig.x + w / 2, orig.y)
			self.minterms[2].coordinate = point(orig.x, w * 0.375 + orig.y)
			self.minterms[3].coordinate = point(orig.x + w / 2, w * 0.375 + orig.y)
			self.minterms[6].coordinate = point(orig.x, w * 0.75 + orig.y)
			self.minterms[7].coordinate = point(orig.x + w / 2, w * 0.75 + orig.y)
			self.minterms[4].coordinate = point(orig.x, orig.y + w * 1.125)
			self.minterms[5].coordinate = point(orig.x + w / 2, orig.y + w * 1.125)
			break
		case 4:
			let orig = point(self.bounds!.maxX * 0.125, self.bounds!.maxY * 0.125)
			self.minterms[0].coordinate = orig
			self.minterms[1].coordinate = point(orig.x + w * 0.25, orig.y)
			self.minterms[3].coordinate = point(orig.x + w * 0.5, orig.y)
			self.minterms[2].coordinate = point(orig.x + w * 0.75, orig.y)
			self.minterms[4].coordinate = point(orig.x, orig.y + w * 0.25)
			self.minterms[5].coordinate = point(orig.x + w * 0.25, w * 0.25 + orig.y)
			self.minterms[7].coordinate = point(orig.x + w * 0.5, w * 0.25 + orig.y)
			self.minterms[6].coordinate = point(orig.x + w * 0.75, w * 0.25 + orig.y)
			self.minterms[12].coordinate = point(orig.x, orig.y + w * 0.5)
			self.minterms[13].coordinate = point(orig.x + w * 0.25, w * 0.5 + orig.y)
			self.minterms[15].coordinate = point(orig.x + w * 0.5, w * 0.5 + orig.y)
			self.minterms[14].coordinate = point(orig.x + w * 0.75, w * 0.5 + orig.y)
			self.minterms[8].coordinate = point(orig.x, orig.y + w * 0.75)
			self.minterms[9].coordinate = point(orig.x + w * 0.25, w * 0.75 + orig.y)
			self.minterms[11].coordinate = point(orig.x + w * 0.5, w * 0.75 + orig.y)
			self.minterms[10].coordinate = point(orig.x + w * 0.75, w * 0.75 + orig.y)
			break
		case 5:
			break
		default:
			break
		}
	}
}
