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
	var coordinates = [Int: CGPoint]()
	var thickness = 1
	lazy var table = [Int]()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clearColor()
		
	}
	
	convenience init(frame:CGRect, magnitude: Int, table: [Int]) {
		self.init(frame: frame)
		
		self.magnitude = magnitude
		self.table = table
		
		self.initCoordinates()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func drawRect(rect: CGRect) {
		self.drawMesh(rect)
	}
	
	func drawBezierLineForMesh (start start: CGPoint, end: CGPoint) {
		let bezierPath = UIBezierPath()
		bezierPath.moveToPoint(start)
		bezierPath.addLineToPoint(end)
		bezierPath.lineWidth = 3
		
		UIColor.whiteColor().setFill()
		bezierPath.fill()
		UIColor.whiteColor().setStroke()
		bezierPath.stroke()
	}
	
	func drawMesh(frame: CGRect) {
		
		if magnitude == 2 {
			drawBezierLineForMesh(start: CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds)),
				end: CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds)))
			
			drawBezierLineForMesh(start: CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
				end: CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)))
			
			
		}
			
		else if magnitude == 3 {
			
		}
			
		else if magnitude == 4 || magnitude == 0 {
		drawBezierLineForMesh(start: CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds)),
								end: CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds)))
		
		drawBezierLineForMesh(start: CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
								end: CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)))
		
		drawBezierLineForMesh(start: CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds)/2),
			                    end: CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds)/2))
		
		drawBezierLineForMesh(start: CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds) + CGRectGetMidY(self.bounds)/2),
								end: CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds) + CGRectGetMidY(self.bounds)/2))
		
		drawBezierLineForMesh(start: CGPointMake(CGRectGetMidX(self.bounds) + CGRectGetMidX(self.bounds)/2, CGRectGetMinY(self.bounds)),
								end: CGPointMake(CGRectGetMidX(self.bounds) + CGRectGetMidX(self.bounds)/2,CGRectGetMaxY(self.bounds)))

		drawBezierLineForMesh(start: CGPointMake(CGRectGetMidX(self.bounds) / 2, CGRectGetMinY(self.bounds)),
								end: CGPointMake(CGRectGetMidX(self.bounds) / 2, CGRectGetMaxY(self.bounds)))
		}
		
		else if magnitude == 5 {
			
		}
	}
	
	func initCoordinates() {
		if magnitude == 2 {
			let orig = CGPointMake(CGRectGetMaxX(self.bounds) * 0.25, CGRectGetMaxY(self.bounds) * 0.75)
			coordinates[3] = orig
			coordinates[2] = CGPointMake(orig.x + self.bounds.width / 2, orig.y)
			coordinates[1] = CGPointMake(orig.x, orig.y - self.bounds.height / 2)
			coordinates[0] = CGPointMake(orig.x + self.bounds.width / 2, orig.y - self.bounds.height / 2)
		}
		
		else if magnitude == 3 {
			
		}
			
		else if magnitude == 4 {
			let orig = CGPointMake(CGRectGetMaxX(self.bounds) * 0.25, CGRectGetMaxY(self.bounds) * 0.75)
			coordinates[3] = orig
			coordinates[2] = CGPointMake(orig.x + self.bounds.width / 2, orig.y)
			coordinates[1] = CGPointMake(orig.x, orig.y - self.bounds.height / 2)
			coordinates[0] = CGPointMake(orig.x + self.bounds.width / 2, orig.y - self.bounds.height / 2)
		}
			
		else if magnitude == 5 {
			
		}
		
		
	}

	func animateMesh() {
		let smallerRectForMask = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), self.frame.size.width / 1.3, self.frame.size.height)
		let mask = CAShapeLayer()
		let maskPath = UIBezierPath(rect: smallerRectForMask)
		
		mask.path = maskPath.CGPath
		mask.fillColor = UIColor.blackColor().CGColor
		
		self.layer.mask = mask
			
		let oldBounds = CGRectMake(mask.bounds.origin.x + 200, mask.bounds.origin.y, mask.bounds.width, mask.bounds.height)
		let newBounds = CGRectMake(oldBounds.origin.x - 500, oldBounds.origin.y, oldBounds.width, oldBounds.height)
			
		let moveToNewPos = CABasicAnimation(keyPath: "bounds")
		moveToNewPos.fromValue = NSValue(CGRect: oldBounds)
		moveToNewPos.toValue = NSValue(CGRect: newBounds)
		moveToNewPos.duration = 1.2
		moveToNewPos.repeatCount = .infinity
		
		let	fadeAnimationTo = CABasicAnimation(keyPath: "opacity")
		fadeAnimationTo.fromValue = NSNumber(float: 1.0)
		fadeAnimationTo.toValue = NSNumber(float: 0.0)
		fadeAnimationTo.duration = 1.2
		fadeAnimationTo.repeatCount = .infinity
		
		let	fadeAnimationFro = CABasicAnimation(keyPath: "opacity")
		fadeAnimationFro.fromValue = NSNumber(float: 0.0)
		fadeAnimationFro.toValue = NSNumber(float: 1.0)
		fadeAnimationFro.duration = 1.2
		fadeAnimationFro.repeatCount = .infinity
		
		self.layer.mask?.bounds = newBounds
			
		self.layer.mask?.addAnimation(moveToNewPos, forKey: "bounds")
		self.layer.mask?.addAnimation(fadeAnimationFro, forKey: "opacity")
		self.layer.mask?.addAnimation(fadeAnimationTo, forKey: "opacity")
	}
	
//	func findCenterOfRect (rect: CGRect) -> CGPoint {
//		
//	}
}