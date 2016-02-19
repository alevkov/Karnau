//
//  Extensions.swift
//  K
//
//  Created by sphota on 2/4/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

extension String {
	
	subscript (i: Int) -> Character {
		return self[self.startIndex.advancedBy(i)]
	}
	
	subscript (r: Range<Int>) -> String {
		let start = startIndex.advancedBy(r.startIndex)
		let end = start.advancedBy(r.endIndex - r.startIndex)
		return self[Range(start: start, end: end)]
	}
}

extension SequenceType where Self.Generator.Element: Hashable {
	func freq() -> [Self.Generator.Element: Int] {
		return reduce([:]) { (var accu: [Self.Generator.Element: Int], element) in
			accu[element] = accu[element]?.successor() ?? 1
			return accu
		}
	}
}

/* OPERATORS */

func * (left: String, right: UInt) -> String {
	if right <= 0 {
		return ""
	}
	
	var result = left
	for _ in 1..<right {
		result += left
	}
	
	return result
}

func ^ (left: String, right: String) -> UInt {
	if left.characters.count != right.characters.count {
		return 0
	}
	var strResult = ""
	var intResult : UInt
	
	
	for var i = 0; i < left.characters.count; ++i {
		if left[i] == right[i] {
			strResult += "0"
		} else {
			strResult += "1"
		}
	}
	
	intResult = strtoul(strResult, nil, 2)
	
	return intResult
}

// uniqueness operator
infix operator ~= {associativity left precedence 160 }
func ~= (left: [UInt], right: [UInt]) -> Bool {
	for l in left {
		for r in right {
			if l == r {
				return false
			}
		}
	}
	return true
}

// Logical ops for string type

func & (left: String, right: String) -> String {
	if left == right {
		return left
	}
	else {
		var result = left
		for r in right.characters {
			if !result.containsString(String(r)) {
				result.append(r)
			}
		}
		
		return result
	}
}

func & (left: [String], right: [String]) -> [String] {
	var results = [String]()
	
	for l in left {
		for r in right {
			let result = l & r
			results.append(result)
		}
	}
	
	return results
}

func &= (inout left: [String], right: [String]) {
	left = left & right
}

// For petrick's method?

func | (left: String, right: String) -> String? {
	if left == right {
		return left
	}
	
	if Set(left.characters).isSubsetOf(Set(right.characters)) {
		return left
	} else if Set(right.characters).isSubsetOf(Set(right.characters)) {
		return left
	} else {
		return nil
	}
}

// ------------------------------


// ***************************
// UIColor
// ***************************

extension UIColor { // Use HEX color value as argument
	convenience init(hex: Int, alpha: CGFloat = 1.0) {
		
		let red			= CGFloat((hex & 0xFF0000)	>> 16) / 255.0
		let green		= CGFloat((hex & 0xFF00)	>> 8 ) / 255.0
		let blue		= CGFloat((hex & 0xFF)			 ) / 255.0
		
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}

extension UIColor { // Generate a random color
	convenience init(random: Bool, alpha: CGFloat) {
		
		let red			= CGFloat(arc4random() % 255) / 255.0
		let green		= CGFloat(arc4random() % 255) / 255.0
		let blue		= CGFloat(arc4random() % 255) / 255.0
		
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}

// ***************************
// Array
// ***************************

extension Array {
	/* removes a given object without specifying index */
	mutating func removeObject<U: Equatable>(object: U) {
		var index: Int?
		for (idx, objectToCompare) in self.enumerate() {
			if let to = objectToCompare as? U {
				if object == to {
					index = idx
				}
			}
		}
		
		if(index != nil) {
			self.removeAtIndex(index!)
		}
	}
}

func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
	var buffer = [T]()
	var added = Set<T>()
	for elem in source {
		if !added.contains(elem) {
			buffer.append(elem)
			added.insert(elem)
		}
	}
	return buffer
}



