//
//  Mesh.swift
//  KK
//
//  Created by sphota on 2/17/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation
import UIKit

class Mesh: UIView {
	
	var magnitude = 0
	var qmmap: QMMap?
	var thickness = 0.5
	lazy var table = [UInt]()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clear
		
	}
	
	convenience init(frame:CGRect, magnitude: Int, table: [UInt]) {
		self.init(frame: frame)
		self.magnitude = magnitude
		self.table = table
		self.qmmap = QMMap(minterms: table, magnitude: UInt(magnitude), bounds: self.bounds)
		self.initCoordinates()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		self.drawMesh(rect)
	}
	
	func point(_ a: CGFloat, _ b: CGFloat) -> CGPoint {
		return CGPoint(x: a, y: b)
	}
	
	func drawBezierLine (_ start: CGPoint, end: CGPoint) {
		let bezierPath = UIBezierPath()
		bezierPath.move(to: start)
		bezierPath.addLine(to: end)
		bezierPath.lineWidth = 3
		
		UIColor.white.setFill()
		bezierPath.fill()
		UIColor.white.setStroke()
		bezierPath.stroke()
	}
	
	func drawMesh(_ frame: CGRect) {
		let midX = self.bounds.midX
		let midY = self.bounds.midY
		let minX = self.bounds.minX
		let minY = self.bounds.minY
		let maxX = self.bounds.maxX
		let maxY = self.bounds.maxY
		if magnitude == 2 {
			drawBezierLine(point(minX, midY),
							 end: point(maxX, midY))
			drawBezierLine(point(midX,maxY),
						     end: point(midX, minY))
		}
		else if magnitude == 3 {
			drawBezierLine(point(midX,maxY),
			                 end: point(midX, minY))
			drawBezierLine(point(minX, midY),
			                 end: point(maxX, midY))
			drawBezierLine(point(minX, midY/2),
			                 end: point(maxX, midY/2))
			drawBezierLine(point(minX, midY + midY/2),
			                 end: point(maxX, midY + midY/2))
		}
		else if magnitude == 4 || magnitude == 0 {
			drawBezierLine(point(minX, midY),
							 end: point(maxX, midY))
			drawBezierLine(point(midX,maxY),
							 end: point(midX, minY))
			drawBezierLine(point(minX, midY/2),
							 end: point(maxX, midY/2))
			drawBezierLine(point(minX, midY + midY/2),
							 end: point(maxX, midY + midY/2))
			drawBezierLine(point(midX + midX/2, minY),
							 end: point(midX + midX/2, maxY))
			drawBezierLine(point(midX / 2, minY),
							 end: point(midX / 2, maxY))
		}
		else if magnitude == 5 {
			
		}
	}
	
	func initCoordinates() {
		self.qmmap?.initCoordinates()
	}

	func animateMesh() {
		let smallerRectForMask = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.frame.size.width / 1.3, height: self.frame.size.height)
		let mask = CAShapeLayer()
		let maskPath = UIBezierPath(rect: smallerRectForMask)
		
		mask.path = maskPath.cgPath
		mask.fillColor = UIColor.black.cgColor
		
		self.layer.mask = mask
			
		let oldBounds = CGRect(x: mask.bounds.origin.x + 200, y: mask.bounds.origin.y, width: mask.bounds.width, height: mask.bounds.height)
		let newBounds = CGRect(x: oldBounds.origin.x - 500, y: oldBounds.origin.y, width: oldBounds.width, height: oldBounds.height)
			
		let moveToNewPos = CABasicAnimation(keyPath: "bounds")
		moveToNewPos.fromValue = NSValue(cgRect: oldBounds)
		moveToNewPos.toValue = NSValue(cgRect: newBounds)
		moveToNewPos.duration = 1.2
		moveToNewPos.repeatCount = .infinity
		
		let	fadeAnimationTo = CABasicAnimation(keyPath: "opacity")
		fadeAnimationTo.fromValue = NSNumber(value: 0.6 as Float)
		fadeAnimationTo.toValue = NSNumber(value: 0.0 as Float)
		fadeAnimationTo.duration = 1.2
		fadeAnimationTo.repeatCount = .infinity
		
		let	fadeAnimationFro = CABasicAnimation(keyPath: "opacity")
		fadeAnimationFro.fromValue = NSNumber(value: 0.0 as Float)
		fadeAnimationFro.toValue = NSNumber(value: 0.6 as Float)
		fadeAnimationFro.duration = 1.2
		fadeAnimationFro.repeatCount = .infinity
		
		self.layer.mask?.bounds = newBounds
			
		self.layer.mask?.add(moveToNewPos, forKey: "bounds")
		self.layer.mask?.add(fadeAnimationFro, forKey: "opacity")
		self.layer.mask?.add(fadeAnimationTo, forKey: "opacity")
	}
	
//	func findCenterOfRect (rect: CGRect) -> CGPoint {
//		
//	}
}
