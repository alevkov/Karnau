//
//  MapViewController.swift
//  KK
//
//  Created by sphota on 2/15/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import UIKit
import Foundation

class MapViewController: UIViewController {
	
	var magnitude = 0
	var difficulty = 0
	var table = []
	
	lazy var core = QMCore()
	lazy var equations = [QMProductSum]()

	override func viewDidLoad() {
		self.view.backgroundColor = UIColor(hex: 0x5499CB, alpha: 1.0)
		
		
		let map = MapView(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 100, CGRectGetMidY(self.view.frame) - 100, 320, 320), magnitude: self.magnitude, table: table as! [Int])
		self.view.addSubview(map)
		
		
		print("Map view loaded")
	}
}
