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
	
	@IBOutlet weak var equationLabel: UILabel!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var resetTableButton: UIButton!
	
	var magnitude = 0
	var difficulty = 0
	var table = []
	
	lazy var core = QMCore()
	lazy var equations = [QMProductSum]()
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func viewDidLoad() {
		self.equationLabel.text = ""
		self.view.backgroundColor = BACKGROUND_COLOR
		
		if self.magnitude == 2 || self.magnitude == 4 || self.magnitude == 5 {
			let map = MapView(frame: CGRectMake(CGRectGetMidX(self.view.frame) - MAP_SIZE_SQUARE / 2,
									 CGRectGetMidY(self.view.frame) - MAP_SIZE_SQUARE / 2,
									 MAP_SIZE_SQUARE,
									 MAP_SIZE_SQUARE),
							  magnitude: self.magnitude,
							  table: table as! [Int])
			map.layer.cornerRadius = 10
			self.view.addSubview(map)
		} else {
			let map = MapView(frame: CGRectMake(CGRectGetMidX(self.view.frame) - MAP_SIZE_RECT_WIDTH / 2,
									 CGRectGetMidY(self.view.frame) - MAP_SIZE_RECT_HEIGHT / 2,
									 MAP_SIZE_RECT_WIDTH,
									 MAP_SIZE_RECT_HEIGHT),
							  magnitude: self.magnitude,
							  table: table as! [Int])
			self.view.addSubview(map)
		}
		backButton.layer.borderWidth = 1
		backButton.layer.borderColor = UIColor.whiteColor().CGColor
		let core = QMCore()
		let equations = core.computePrimeProducts(self.table as! [UInt], magnitude: UInt(self.magnitude)) //
		if equations?.count == 0 {
			print("No solutions")
		}
		for e in equations! {
			e.print()
		}
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.equationDidChange(_:)), name: "QMDidSelectGroupOnMap", object: nil)
	}
	
	func equationDidChange(notification: NSNotification) {
		if let data = notification.userInfo as? [String: QMProductSum] {
			self.equationLabel.text?.appendContentsOf((data["data"]?.convertToLetters())!)
		}
	}
	
	@IBAction func backButtonTapped(sender: AnyObject) {
		self.dismissViewControllerAnimated(false, completion: nil)
	}
	
	@IBAction func resetTableButtonTapped(sender: AnyObject) {
		self.equationLabel.text = ""
		NSNotificationCenter.defaultCenter().postNotificationName("QMDidResetTableOnMapView", object: self)
	}
}


