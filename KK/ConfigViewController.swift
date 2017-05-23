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
		self.vardialView = CKCircleView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
		self.vardialView.frame.origin = CGPoint(x: vardialView.frame.midX, y: vardialView.frame.midY)
		if UIScreen.main.bounds.width <= 320 {
			vardialView.frame = CGRect(x: self.view.frame.midX - vardialView.frame.width/2, y: self.view.frame.midY - vardialView.frame.width * 1.00, width: vardialView.frame.width, height: vardialView.frame.height)
		} else {
			vardialView.frame = CGRect(x: self.view.frame.midX - vardialView.frame.width/2, y: self.view.frame.midY - vardialView.frame.width * 1.00, width: vardialView.frame.width, height: vardialView.frame.height)
		}
		self.view.backgroundColor = bgColor
		self.vardialView.letterScale = true;
		self.vardialView.arcColor = UIColor(hex: 0x50E3C2, alpha: 1.0)
		self.vardialView.backColor =  UIColor(hex: 0x50E3C2, alpha: 1.0)
		self.vardialView.dialColor = UIColor.white
		self.vardialView.arcRadius = 80;
		self.vardialView.minNum = 1;
		self.vardialView.maxNum = 4;
		self.vardialView.labelColor = UIColor.white
		self.vardialView.labelFont = UIFont(name: "Lantinghei SC", size: 22)
		// return value on switch completion and store it
		self.vardialView.switchCompletion = { (count)  in
			UIView.animate(withDuration: 0.5, animations: { () -> Void in
				self.vardialView.transform = CGAffineTransform(scaleX: 2, y: 2)
				self.vardialView.transform = CGAffineTransform(scaleX: 1, y: 1)
				})
			self.count = count + 1
		}
		self.view.addSubview(vardialView)
		goButton.layer.borderWidth = 1
		goButton.layer.borderColor = UIColor.white.cgColor
		backButton.layer.borderWidth = 1
		backButton.layer.borderColor = UIColor.white.cgColor
		slider.frame = CGRect(x: self.vardialView.frame.midX - 100, y: self.vardialView.frame.midY + 200, width: 200, height: 20)
		slider.maxCount = 4
		slider.trackColor = UIColor(hex: 0x50E3C2, alpha: 1.0)
		slider.tintColor =  UIColor(hex: 0x50E3C2, alpha: 1.0)
		self.view.addSubview(slider)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.count = 2
		UIView.animate(withDuration: 0.4, animations: { () -> Void in
			self.vardialView.moveCircle(toAngle: 15, with: nil)
			}, completion: { (flag) -> Void in
				UIView.animate(withDuration: 0.4, animations: { () -> Void in
					self.vardialView.moveCircle(toAngle: 0, with: nil)
					}, completion: { (flag) -> Void in
				}) 
		}) 
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		UIView.animate(withDuration: 0.4, animations: { () -> Void in
			self.vardialView.moveCircle(toAngle: 0, with: nil)
		})
	}
	
	@IBAction func goButtonAction(_ sender: AnyObject) {
		let count = (Double(self.count) * Double(slider.index + 1)) / 1.3
		let table = makeList(Int(count), cap: 2^^Int(self.count))
		let mapView = StoryBoardManager.sharedManager.instantiateViewController(withIdentifier: "MapView") as? MapViewController
		mapView!.table = table
		mapView!.magnitude = Int(self.count)
		let  trans = UIViewAnimationTransition.flipFromRight
		UIView.beginAnimations("trans", context: nil)
		UIView.setAnimationTransition(trans, for: UIApplication.shared.keyWindow!, cache: true)
		UIView.setAnimationDuration(0.3)
		self.present(mapView!, animated: false, completion: nil)
		UIView.commitAnimations()
	}
	
	
	@IBAction func backButton(_ sender: AnyObject) {
		self.dismiss(animated: false, completion: nil)
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
	func makeList(_ n:Int, cap: Int) -> [UInt] {
		var result: [UInt] = []
		for _ in 0..<n {
			result.append(UInt(arc4random_uniform(UInt32(cap))))
		}
		result.sort(by: { $1 > $0 })
		return uniq(result)
	}

}
