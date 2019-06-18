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
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
	override func viewDidLoad() {
		self.equationLabel.text = ""
		self.resetTableButton.setTitle("reset", for: UIControl.State())
		self.view.backgroundColor = bgColor
		if self.magnitude == 2 || self.magnitude == 4 || self.magnitude == 5 {
			self.map = MapView(frame: CGRect(x: self.view.frame.midX - mapSizeSquare / 2,
									 y: self.view.frame.midY - mapSizeSquare / 2,
									 width: mapSizeSquare,
									 height: mapSizeSquare),
							  magnitude: self.magnitude,
							  table: self.table)
			self.map!.layer.cornerRadius = 0
			self.map!.layer.masksToBounds = true
			self.view.addSubview(self.map!)
		} else {
			self.map = MapView(frame: CGRect(x: self.view.frame.midX - mapSizeRectWidth / 2,
									 y: self.view.frame.midY - mapSizeRectHeight / 2,
									 width: mapSizeRectWidth,
									 height: mapSizeRectHeight),
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
		backButton.layer.borderColor = UIColor.white.cgColor
		
//		let cdLabel = UILabel(frame: CGRectMake(self.map!.frame.minX + 20, self.map!.frame.minY - 70, 100, 100))
//		cdLabel.text = "CD"
//		cdLabel.font = UIFont(name: "Lantinghei SC", size: 20)
//		cdLabel.textColor = UIColor.whiteColor()
//		self.view.addSubview(cdLabel)
//		let abLabel = UILabel(frame: CGRectMake(self.map!.frame.minX - 40, self.map!.frame.minY - 20, 100, 100))
//		abLabel.text = "AB"
//		abLabel.font = UIFont(name: "Lantinghei SC", size: 20)
//		abLabel.textColor = UIColor.whiteColor()
//		self.view.addSubview(abLabel)
		NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.equationDidChange(_:)), name: NSNotification.Name(rawValue: didSelectGroupNotification), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.didGetCheckResult(_:)), name: NSNotification.Name(rawValue: didCheckEquationNotification), object: self.map)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		self.map = nil
	}
	
	@objc fileprivate func equationDidChange(_ notification: Notification) {
		guard let data = notification.userInfo as? [String: QMProductSum] else {
			print("invalid type in NSNotification data")
			return
		}
		if data["error"] != nil {
			let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		if self.equationLabel.text != "" {
			self.equationLabel.text?.append(" + ")
		}
		self.equationLabel.text?.append((data["data"]?.convertToLetters())!)
	}
	
	@objc fileprivate func didGetCheckResult(_ notification: Notification) {
		guard let data = notification.userInfo as? [String: Bool]  else {
			print("invalid type in NSNotification data")
			return
		}
		if data["correct"] == false {
			let alert = UIAlertController(title: "Incorrect Solution", message: "Try a different approach!", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		} else {
			let alert = UIAlertController(title: "Solution is Accepted", message: "Nice job!", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func backButtonTapped(_ sender: AnyObject) {
		self.dismiss(animated: false, completion: nil)
	}
	
	@IBAction func checkButtonTapped(_ sender: AnyObject) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: didCallForCheckEquationNotification), object: self.map);
	}
	
	@IBAction func resetTableButtonTapped(_ sender: AnyObject) {
		self.equationLabel.text = ""
		NotificationCenter.default.post(name: Notification.Name(rawValue: didResetTableOnMapViewNotification), object: self)
	}
	
	deinit {
		self.map = nil
		NotificationCenter.default.removeObserver(self)
	}
}


