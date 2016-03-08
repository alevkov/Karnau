//
//  MapView.swift
//  KK
//
//  Created by sphota on 2/15/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import UIKit

class MapView: UIView {
	
	var mesh: Mesh?
	var onCoordinates : [CGPoint]?
	var dcCoordinates: [CGPoint]?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.opaque = false
		self.backgroundColor = UIColor.clearColor()
	}
	
	convenience init(frame: CGRect, magnitude: Int, table: [Int]) {
		self.init(frame: frame)
		
		let mesh = Mesh(frame: self.bounds, magnitude: magnitude, table: table)
		self.mesh = mesh
		
		self.addSubview(mesh)
		
		let test = UILabel(frame: CGRectMake(mesh.coordinates[1]!.x-5, mesh.coordinates[1]!.y - 20, 40, 40))
		let test2 = UILabel(frame: CGRectMake(mesh.coordinates[3]!.x-5, mesh.coordinates[3]!.y - 20, 40, 40))
		test.text = "0"
		test2.text = "1"
		test2.font = UIFont(name: "Lantinghei SC", size: 25)
		test.font = UIFont(name: "Lantinghei SC", size: 25)

		self.addSubview(test)
		self.addSubview(test2)

	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
    override func drawRect(rect: CGRect) {
         self.drawMapBorders(rect)
    }
	
	func drawMapBorders(frame: CGRect) {
		let rectanglePath = UIBezierPath(roundedRect: CGRectMake(self.bounds.origin.x, self.bounds.origin.y	, self.bounds.width, self.bounds.height), cornerRadius: 0)
		rectanglePath.lineWidth = 10
		UIColor.whiteColor().setStroke()
		rectanglePath.stroke()
	}
}
