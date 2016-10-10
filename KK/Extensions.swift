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

/* TYPES */

typealias GroupType = Array<QMMinterm>
typealias OrderType = Dictionary<UInt, GroupType>
typealias PrimeType = Dictionary<String, QMMinterm>

enum Error : ErrorType {
	case UnknownType
}

extension String {
	subscript (i: Int) -> Character {
		return self[self.startIndex.advancedBy(i)]
	}
	
	subscript (r: Range<Int>) -> String {
		let start = startIndex.advancedBy(r.startIndex)
		let end = start.advancedBy(r.endIndex - r.startIndex)
		return self[start..<end]
	}
}

extension SequenceType where Self.Generator.Element: Hashable {
	func freq() -> [Self.Generator.Element: Int] {
		return reduce([:]) { ( accu: [Self.Generator.Element: Int], element) in
			var accumulator = accu
			accumulator[element] = accumulator[element]?.successor() ?? 1
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

infix operator ^^ { }
func ^^ (radix: Int, power: Int) -> Int {
	return Int(pow(Double(radix), Double(power)))
}

// Logical ops for string type

func ^ (left: String, right: String) -> UInt {
	if left.characters.count != right.characters.count {
		return 0
	}
	var strResult = ""
	var intResult : UInt
	for i in 0 ..< left.characters.count {
		if left[i] == right[i] {
			strResult += "0"
		} else {
			strResult += "1"
		}
	}
	intResult = strtoul(strResult, nil, 2)
	return intResult
}

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

extension UIView {
	func addDashedBorder(color: UIColor, animated: Bool) {
		let c = color.CGColor
		let shapeLayer:CAShapeLayer = CAShapeLayer()
		let frameSize = self.frame.size
		let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
		shapeLayer.bounds = shapeRect
		shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
		shapeLayer.fillColor = animated == true ? wrapAroundGroupColor.CGColor : UIColor.clearColor().CGColor
		shapeLayer.strokeColor = animated == true ? UIColor.clearColor().CGColor : c
		shapeLayer.lineWidth = 2
		shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).CGPath
		self.alpha = 0.0
		let options: UIViewAnimationOptions = animated == true ? [.Autoreverse, .Repeat] : .CurveEaseInOut
			UIView.animateWithDuration(1, delay: 0.0, options: options, animations: {
				self.alpha = animated == true ? 0.5 : 1
			}, completion: nil)
		self.layer.addSublayer(shapeLayer)
	}
}

extension CALayer {
	func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
		let border = CALayer()
		switch edge {
		case UIRectEdge.Top:
			border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness)
			break
		case UIRectEdge.Bottom:
			border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness)
			break
		case UIRectEdge.Left:
			border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
			break
		case UIRectEdge.Right:
			border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
			break
		default:
			break
		}
		border.backgroundColor = color.CGColor;
		self.addSublayer(border)
	}
}


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

class ParkBenchTimer {
	let startTime:CFAbsoluteTime
	var endTime:CFAbsoluteTime?
	
	init() {
		startTime = CFAbsoluteTimeGetCurrent()
	}
	
	func stop() -> CFAbsoluteTime {
		endTime = CFAbsoluteTimeGetCurrent()
		
		return duration!
	}
	
	var duration:CFAbsoluteTime? {
		if let endTime = endTime {
			return endTime - startTime
		} else {
			return nil
		}
	}
}
