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
	@IBOutlet weak var diffSlider: UISlider!
	@IBOutlet weak var backButton: UIButton!
	
	
	override func viewDidLoad() {
		/// Dial view setup
		self.vardialView = CKCircleView(frame: CGRectMake(0, 0, 150, 150))
		self.vardialView.frame.origin = CGPointMake(CGRectGetMidX(vardialView.frame), CGRectGetMidY(vardialView.frame))
		if UIScreen.mainScreen().bounds.width <= 320 {
			vardialView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - vardialView.frame.width/2, CGRectGetMidY(self.view.frame) - vardialView.frame.width * 1.20, vardialView.frame.width, vardialView.frame.height)
		} else {
			vardialView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - vardialView.frame.width/2, CGRectGetMidY(self.view.frame) - vardialView.frame.width * 1.20, vardialView.frame.width, vardialView.frame.height)
		}
		
		self.view.backgroundColor = UIColor(hex: 0x5499CB, alpha: 1.0)
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
		
		/// Start button setup
		goButton.layer.borderWidth = 1
		goButton.layer.borderColor = UIColor.whiteColor().CGColor
		
		backButton.layer.borderWidth = 1
		backButton.layer.borderColor = UIColor.whiteColor().CGColor

		
		/// Slider setup
		let thumb = UIImage(named: "SiderThumb")
		let size = CGSizeApplyAffineTransform(thumb!.size, CGAffineTransformMakeScale(0.1, 0.1))
		let hasAlpha = false
		let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
		
		UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
		thumb!.drawInRect(CGRect(origin: CGPointZero, size: size))
		
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		diffSlider.setThumbImage(scaledImage, forState: UIControlState.Normal)
		
		
		let numberOfSteps = Float(6.0)
		diffSlider.maximumValue = numberOfSteps;
		diffSlider.minimumValue = 1;
		diffSlider.continuous = true;
		
//		diffSlider.layer.borderWidth = 1
//		diffSlider.layer.borderColor = UIColor.whiteColor().CGColor
		
		var slider = StepSlider(frame: CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)-300, 200, 20))
		slider.maxCount = 6
		self.view.addSubview(slider)
		
	}
	
	
	override func viewDidAppear(animated: Bool) {
		UIView.animateWithDuration(0.6, animations: { () -> Void in
			self.vardialView.moveCircleToAngle(15, with: nil)
			}) { (flag) -> Void in
				UIView.animateWithDuration(0.6, animations: { () -> Void in
					self.vardialView.moveCircleToAngle(0, with: nil)
					}) { (flag) -> Void in
						
				}
		}
	}
	
	@IBAction func goButtonAction(sender: AnyObject) {
		
		let count = (Double(self.count) * Double(diffSlider.value)) / 1.7
		let table = makeList(Int(count), cap: 2^^Int(self.count))
		
		
		let mapView = MapViewController()
		mapView.table = table
		mapView.magnitude = Int(self.count)
		
		let  trans = UIViewAnimationTransition.FlipFromRight
		UIView.beginAnimations("trans", context: nil)
		UIView.setAnimationTransition(trans, forView: UIApplication.sharedApplication().keyWindow!, cache: true)
		UIView.setAnimationDuration(0.3)
		
		self.presentViewController(mapView, animated: false, completion: nil)
		UIView.commitAnimations()
		
		print(table)
		
	}
	
	
	@IBAction func backButton(sender: AnyObject) {
		self.dismissViewControllerAnimated(false, completion: nil)
	}

	@IBAction func diffsliderShifted(sender: AnyObject) {
		sender.setValue(Float(lroundf(diffSlider.value)), animated: true)
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
