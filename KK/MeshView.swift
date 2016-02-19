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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clearColor()
		
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
		bezierPath.lineWidth = 2
		
		UIColor.whiteColor().setFill()
		bezierPath.fill()
		UIColor.whiteColor().setStroke()
		bezierPath.stroke()
	}
	
	func drawMesh(frame: CGRect) {
		
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
		
		self.animateMesh()
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
			let v = NSValue(CGRect: oldBounds)
			moveToNewPos.fromValue = v
			moveToNewPos.toValue = NSValue(CGRect: newBounds)
			moveToNewPos.duration = 4.0
			moveToNewPos.repeatCount = .infinity
			
			self.layer.mask?.bounds = newBounds
			
			self.layer.mask?.addAnimation(moveToNewPos, forKey: "bounds")

		
		
//		UIView.animateWithDuration(5, animations: { () -> Void in
//			self.layer.mask?.frame = CGRectMake(smallerRectForMask.origin.x - 100, smallerRectForMask.origin.y, smallerRectForMask.width, smallerRectForMask.height)
//			}) { (flag) -> Void in
//				
//		}
		
		
	}
}