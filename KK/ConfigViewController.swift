//
//  ConfigViewController.swift
//  KK
//
//  Created by sphota on 2/15/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import UIKit
import Foundation

class ConfigViewController: UIViewController {
	
	lazy var vardialView = CKCircleView()
	lazy var diffdialView = CKCircleView()
	
	var count: Int32 = 0
	var difficulty = 0
	
	@IBOutlet weak var goButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	
	let slider = StepSlider()
	
	override func viewDidLoad() {
		/// Dial view setup
		self.vardialView = CKCircleView(frame: CGRectMake(0, 0, 150, 150))
		self.vardialView.frame.origin = CGPointMake(CGRectGetMidX(vardialView.frame), CGRectGetMidY(vardialView.frame))
		if UIScreen.mainScreen().bounds.width <= 320 {
			vardialView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - vardialView.frame.width/2, CGRectGetMidY(self.view.frame) - vardialView.frame.width * 1.00, vardialView.frame.width, vardialView.frame.height)
		} else {
			vardialView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - vardialView.frame.width/2, CGRectGetMidY(self.view.frame) - vardialView.frame.width * 1.00, vardialView.frame.width, vardialView.frame.height)
		}
		self.view.backgroundColor = BACKGROUND_COLOR
		self.vardialView.letterScale = true;
		self.vardialView.arcColor = UIColor(hex: 0x50E3C2, alpha: 1.0)
		self.vardialView.backColor =  UIColor(hex: 0x50E3C2, alpha: 1.0)
		self.vardialView.dialColor = UIColor.whiteColor()
		self.vardialView.arcRadius = 80;
		self.vardialView.minNum = 1;
		self.vardialView.maxNum = 5;
		self.vardialView.labelColor = UIColor.whiteColor()
		self.vardialView.labelFont = UIFont(name: "Lantinghei SC", size: 22)
		// return value on switch completion and store it
		self.vardialView.switchCompletion = { (count)  in
			UIView.animateWithDuration(0.5, animations: { () -> Void in
				self.vardialView.transform = CGAffineTransformMakeScale(2, 2)
				self.vardialView.transform = CGAffineTransformMakeScale(1, 1)
				})
			self.count = count + 1
		}
		self.view.addSubview(vardialView)
		goButton.layer.borderWidth = 1
		goButton.layer.borderColor = UIColor.whiteColor().CGColor
		backButton.layer.borderWidth = 1
		backButton.layer.borderColor = UIColor.whiteColor().CGColor
		slider.frame = CGRectMake(CGRectGetMidX(self.vardialView.frame) - 100, CGRectGetMidY(self.vardialView.frame) + 200, 200, 20)
		slider.maxCount = 5
		slider.trackColor = UIColor(hex: 0x50E3C2, alpha: 1.0)
		slider.tintColor =  UIColor(hex: 0x50E3C2, alpha: 1.0)
		self.view.addSubview(slider)
	}
	
	override func viewDidAppear(animated: Bool) {
		self.count = 2
		UIView.animateWithDuration(0.4, animations: { () -> Void in
			self.vardialView.moveCircleToAngle(15, with: nil)
			}) { (flag) -> Void in
				UIView.animateWithDuration(0.4, animations: { () -> Void in
					self.vardialView.moveCircleToAngle(0, with: nil)
					}) { (flag) -> Void in
				}
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		UIView.animateWithDuration(0.4, animations: { () -> Void in
			self.vardialView.moveCircleToAngle(0, with: nil)
		})
	}
	
	@IBAction func goButtonAction(sender: AnyObject) {
		let count = (Double(self.count) * Double(slider.index)) / 1.3
		let table = makeList(Int(count), cap: 2^^Int(self.count))
		let mapView = StoryBoardManager.sharedManager.instantiateViewControllerWithIdentifier("MapView") as? MapViewController
		mapView!.table = table
		mapView!.magnitude = Int(self.count)
		let  trans = UIViewAnimationTransition.FlipFromRight
		UIView.beginAnimations("trans", context: nil)
		UIView.setAnimationTransition(trans, forView: UIApplication.sharedApplication().keyWindow!, cache: true)
		UIView.setAnimationDuration(0.3)
		self.presentViewController(mapView!, animated: false, completion: nil)
		UIView.commitAnimations()
	}
	
	
	@IBAction func backButton(sender: AnyObject) {
		self.dismissViewControllerAnimated(false, completion: nil)
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	func makeList(n:Int, cap: Int) -> [Int] {
		var result:[Int] = []
		for _ in 0..<n {
			result.append(Int(arc4random_uniform(UInt32(cap))))
		}
		result.sortInPlace({ $1 > $0 })
		return uniq(result)
	}

}
