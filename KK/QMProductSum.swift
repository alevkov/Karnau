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
	private let vars = ["A", "B", "C", "D", "E", "F"]
	var products : [QMMinterm] = []
	var strRepresentationOfProducts: [String] = []
	/* format: "ABC + ABC + ABC + . . ." */
	var stringValue : String
	var magnitude: UInt = 0
	var minCount: Int {
		get {
			return products.count
		}
	}
	
	init(withProducts: [QMMinterm], magnitude: UInt) {
		self.magnitude = 0
		self.stringValue = ""
		self.products = withProducts
	}
	
	func addProduct(product: QMMinterm) {
		self.products.append(product)
	}
	
	func convertToLetters() -> String {
		var strval = ""
		for p in products {
			if strval != "" {
				strval += "+"
			}
			for i in 0 ..< p.stringValue.characters.count {
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
		self.strRepresentationOfProducts = self.stringValue.componentsSeparatedByString("+")
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

