//
//  ThermometerView.swift
//  KK
//
//  Created by sphota on 2/18/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation

class ThermometerView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func drawRect(rect: CGRect) {
		drawLine()
	}
	
	func drawLine () {
		
		/// Draw line
		var path = UIBezierPath()
		path.moveToPoint(CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds)))
		path.addLineToPoint(CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds)))
		UIColor.whiteColor().setFill()
		UIColor.whiteColor().setStroke()
		path.fill()
		path.lineWidth = 1
		path.stroke()
	}
	
}