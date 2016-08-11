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
	
	init(minterms: [Int], magnitude: UInt, bounds: CGRect) {
		self.magnitude = magnitude
		self.bounds = bounds
		let range = pow(Double(2), Double(self.magnitude))
		if magnitude == 0 { return }
		for m in (0...Int(range) - 1) {
			let min = QMMinterm(i: UInt(m), m: magnitude)
			let c = QMCoordiate(minterm: min, state: OFF)
			self.minterms.insert(c, atIndex: m)
		}
		
		for m in minterms {
			self.minterms[m].state = ON
		}
	}
	
	func initCoordinates() {
		switch self.magnitude {
		case 2:
			let orig = CGPointMake(CGRectGetMaxX(self.bounds!) * 0.25, CGRectGetMaxY(self.bounds!) * 0.25)
			self.minterms[0].coordinate = orig
			self.minterms[1].coordinate = CGPointMake(orig.x + self.bounds!.width / 2, orig.y)
			self.minterms[2].coordinate = CGPointMake(orig.x, orig.y + self.bounds!.height / 2)
			self.minterms[3].coordinate = CGPointMake(orig.x + self.bounds!.width / 2, orig.y + self.bounds!.height / 2)
			break
		case 3:
			let orig = CGPointMake(CGRectGetMaxX(self.bounds!) * 0.25, CGRectGetMaxY(self.bounds!) * 0.125)
			self.minterms[0].coordinate = orig
			self.minterms[1].coordinate = CGPointMake(orig.x + self.bounds!.width / 2, orig.y)
			self.minterms[2].coordinate = CGPointMake(orig.x, self.bounds!.width * 0.375 + orig.y)
			self.minterms[3].coordinate = CGPointMake(orig.x + self.bounds!.width / 2, self.bounds!.width * 0.375 + orig.y)
			self.minterms[6].coordinate = CGPointMake(orig.x, self.bounds!.width * 0.75 + orig.y)
			self.minterms[7].coordinate = CGPointMake(orig.x + self.bounds!.width / 2, self.bounds!.width * 0.75 + orig.y)
			self.minterms[4].coordinate = CGPointMake(orig.x, orig.y + self.bounds!.width * 1.125)
			self.minterms[5].coordinate = CGPointMake(orig.x + self.bounds!.width / 2, orig.y + self.bounds!.width * 1.125)
			break
		case 4:
			let orig = CGPointMake(CGRectGetMaxX(self.bounds!) * 0.125, CGRectGetMaxY(self.bounds!) * 0.125)
			self.minterms[0].coordinate = orig
			self.minterms[1].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.25, orig.y)
			self.minterms[3].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.5, orig.y)
			self.minterms[2].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.75, orig.y)
			self.minterms[4].coordinate = CGPointMake(orig.x, orig.y + self.bounds!.width * 0.25)
			self.minterms[5].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.25, self.bounds!.width * 0.25 + orig.y)
			self.minterms[7].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.5, self.bounds!.width * 0.25 + orig.y)
			self.minterms[6].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.75, self.bounds!.width * 0.25 + orig.y)
			self.minterms[12].coordinate = CGPointMake(orig.x, orig.y + self.bounds!.width * 0.5)
			self.minterms[13].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.25, self.bounds!.width * 0.5 + orig.y)
			self.minterms[15].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.5, self.bounds!.width * 0.5 + orig.y)
			self.minterms[14].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.75, self.bounds!.width * 0.5 + orig.y)
			self.minterms[8].coordinate = CGPointMake(orig.x, orig.y + self.bounds!.width * 0.75)
			self.minterms[9].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.25, self.bounds!.width * 0.75 + orig.y)
			self.minterms[11].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.5, self.bounds!.width * 0.75 + orig.y)
			self.minterms[10].coordinate = CGPointMake(orig.x + self.bounds!.width * 0.75, self.bounds!.width * 0.75 + orig.y)
			break
		case 5:
			break
		default:
			break
		}
	}
}