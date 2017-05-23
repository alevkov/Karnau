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
		return self[self.characters.index(self.startIndex, offsetBy: i)]
	}
	
	subscript (r: Range<Int>) -> String {
		let start = characters.index(startIndex, offsetBy: r.lowerBound)
		let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
		return self[start..<end]
	}
}

extension Sequence where Iterator.Element : Hashable {
    func freq() -> [Iterator.Element:Int] {
        var results : [Iterator.Element:Int] = [:]
        for element in self {
            results[element] = (results[element] ?? 0) + 1
        }
        return results
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

infix operator ^^
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
			if !result.contains(String(r)) {
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

func &= (left: inout [String], right: [String]) {
	left = left & right
}

func | (left: String, right: String) -> String? {
	if left == right {
		return left
	}
	if Set(left.characters).isSubset(of: Set(right.characters)) {
		return left
	} else if Set(right.characters).isSubset(of: Set(right.characters)) {
		return left
	} else {
		return nil
	}
}

// ------------------------------

extension UIView {
	func addDashedBorder(_ color: UIColor, animated: Bool) {
		let c = color.cgColor
		let shapeLayer:CAShapeLayer = CAShapeLayer()
		let frameSize = self.frame.size
		let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
		shapeLayer.bounds = shapeRect
		shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
		shapeLayer.fillColor = animated == true ? wrapAroundGroupColor.cgColor : UIColor.clear.cgColor
		shapeLayer.strokeColor = animated == true ? UIColor.clear.cgColor : c
		shapeLayer.lineWidth = 2
		shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
		self.alpha = 0.0
		let options: UIViewAnimationOptions = animated == true ? [.autoreverse, .repeat] : UIViewAnimationOptions()
			UIView.animate(withDuration: 0.7, delay: 0.0, options: options, animations: {
				self.alpha = animated == true ? 0.5 : 1
			}, completion: nil)
		self.layer.addSublayer(shapeLayer)
	}
}

extension CALayer {
	func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
		let border = CALayer()
		switch edge {
		case UIRectEdge.top:
			border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
			break
		case UIRectEdge.bottom:
			border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
			break
		case UIRectEdge.left:
			border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
			break
		case UIRectEdge.right:
			border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
			break
		default:
			break
		}
		border.backgroundColor = color.cgColor;
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
	mutating func removeObject<U: Equatable>(_ object: U) {
		var index: Int?
		for (idx, objectToCompare) in self.enumerated() {
			if let to = objectToCompare as? U {
				if object == to {
					index = idx
				}
			}
		}
		if(index != nil) {
			self.remove(at: index!)
		}
	}
}

func uniq<S : Sequence, T : Hashable>(_ source: S) -> [T] where S.Iterator.Element == T {
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
