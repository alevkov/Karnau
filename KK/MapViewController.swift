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
	@IBOutlet weak var checkButton: UIButton!
	
	var magnitude = 0
	var difficulty = 0
	var table: [UInt] = []
	var map : MapView?
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func viewDidLoad() {
		self.equationLabel.text = ""
		self.resetTableButton.setTitle("\u{21ba}", forState: .Normal)
		self.view.backgroundColor = bgColor
		if self.magnitude == 2 || self.magnitude == 4 || self.magnitude == 5 {
			self.map = MapView(frame: CGRectMake(CGRectGetMidX(self.view.frame) - mapSizeSquare / 2,
									 CGRectGetMidY(self.view.frame) - mapSizeSquare / 2,
									 mapSizeSquare,
									 mapSizeSquare),
							  magnitude: self.magnitude,
							  table: self.table)
			self.map!.layer.cornerRadius = 0
			self.map!.layer.masksToBounds = true
			self.view.addSubview(self.map!)
		} else {
			self.map = MapView(frame: CGRectMake(CGRectGetMidX(self.view.frame) - mapSizeRectWidth / 2,
									 CGRectGetMidY(self.view.frame) - mapSizeRectHeight / 2,
									 mapSizeRectWidth,
									 mapSizeRectHeight),
							  magnitude: self.magnitude,
							  table: self.table)
			self.map!.layer.cornerRadius = 0
			self.map!.layer.masksToBounds = true
			self.view.addSubview(self.map!)
		}
		let core = QMCore()
		let equations = core.computePrimeProducts(self.table, magnitude: UInt(self.magnitude)) //
		if equations?.count == 0 {
			print("No solutions")
		}
		self.map?.solutions = equations
		for e in equations! {
			e.print()
		}
		backButton.layer.borderWidth = 1
		backButton.layer.borderColor = UIColor.whiteColor().CGColor
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.equationDidChange(_:)), name: didSelectGroupNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.didGetCheckResult(_:)), name: didCheckEquationNotification, object: self.map)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(true)
		self.map = nil
	}
	
	@objc private func equationDidChange(notification: NSNotification) {
		guard let data = notification.userInfo as? [String: QMProductSum] else {
			print("invalid type in NSNotification data")
			return
		}
		if data["error"] != nil {
			let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
			return
		}
		if self.equationLabel.text != "" {
			self.equationLabel.text?.appendContentsOf(" + ")
		}
		self.equationLabel.text?.appendContentsOf((data["data"]?.convertToLetters())!)
	}
	
	@objc private func didGetCheckResult(notification: NSNotification) {
		guard let data = notification.userInfo as? [String: Bool]  else {
			print("invalid type in NSNotification data")
			return
		}
		if data["correct"] == false {
			let alert = UIAlertController(title: "Incorrect Solution", message: "Try a different approach!", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
			return
		} else {
			let alert = UIAlertController(title: "Solution is Accepted", message: "Nice job!", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func backButtonTapped(sender: AnyObject) {
		self.dismissViewControllerAnimated(false, completion: nil)
	}
	
	@IBAction func checkButtonTapped(sender: AnyObject) {
		NSNotificationCenter.defaultCenter().postNotificationName(didCallForCheckEquationNotification, object: self.map);
	}
	
	@IBAction func resetTableButtonTapped(sender: AnyObject) {
		self.equationLabel.text = ""
		NSNotificationCenter.defaultCenter().postNotificationName(didResetTableOnMapViewNotification, object: self)
	}
	
	deinit {
		self.map = nil
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}


