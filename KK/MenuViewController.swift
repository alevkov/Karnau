//
//  ViewController.swift
//  KK
//
//  Created by sphota on 2/15/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

class MenuViewController: UIViewController {
	
	@IBOutlet weak var tutorialButton: UIButton!
	@IBOutlet weak var engineerButton: UIButton!
	
	var mesh = Mesh()
	let sB = UIStoryboard(name: "Main", bundle: nil)
	
	func setup () {
		let logoView = LogoView(frame: CGRect(x: 0, y: 0, width: 220, height: 220))
		logoView.frame.origin =  CGPoint(x: logoView.frame.midX, y: logoView.frame.midY)
		logoView.layer.anchorPoint = CGPoint(x: logoView.frame.midX, y: logoView.frame.midY)
		if UIScreen.main.bounds.width <= 320 {
			logoView.frame = CGRect(x: self.view.frame.midX - logoView.frame.width/2, y: self.view.frame.midY - logoView.frame.width * 1.45, width: logoView.frame.width, height: logoView.frame.height)
		}
		else {
			logoView.frame = CGRect(x: self.view.frame.midX - logoView.frame.width/2, y: self.view.frame.midY - logoView.frame.width * 1.15, width: logoView.frame.width, height: logoView.frame.height)
		}
		logoView.layer.cornerRadius = 10
		logoView.layer.masksToBounds = true
		self.view.addSubview(logoView)
		self.mesh = Mesh(frame: CGRect(x: logoView.frame.origin.x, y: logoView.frame.origin.y, width: logoView.frame.width, height: logoView.frame.height), magnitude: 0, table: [])
		self.view.addSubview(mesh)
		tutorialButton.layer.borderWidth = 1
		tutorialButton.layer.borderColor = UIColor.white.cgColor
		engineerButton.layer.borderColor = UIColor.white.cgColor
		engineerButton.layer.borderWidth = 1
		self.view.backgroundColor = bgColor
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		self.mesh.animateMesh()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override var prefersStatusBarHidden : Bool {
		return true
	}
	
	@IBAction func engineerPressed(_ sender: AnyObject) {
		do {
			try animateMenuButton(engineerButton) { (data: Bool) -> Void in
				let trans = UIViewAnimationTransition.flipFromRight
				UIView.beginAnimations("trans", context: nil)
				UIView.setAnimationTransition(trans, for: UIApplication.shared.keyWindow!, cache: true)
				UIView.setAnimationDuration(0.3)
				let config = StoryBoardManager.sharedManager.instantiateViewController(withIdentifier: "ConfigView") as? ConfigViewController
				self.present(config!, animated: false, completion: nil)
				UIView.commitAnimations()
			}
		} catch _ {
			print(VendingMachineError.invalidSelection)
		}
	}
	
	@IBAction func tutorialPressed(_ sender: AnyObject) {
		do {
			try animateMenuButton(tutorialButton, completion: nil)
		} catch _ {
			print(VendingMachineError.invalidSelection)
		}
	}
	
	func animateMenuButton(_ view: AnyObject, completion: ((Bool) -> Void)?) throws {
		guard let button = view as? UIButton else { throw VendingMachineError.invalidSelection }
		if !button.isSelected {
			button.isSelected = true
			UIView.animate(withDuration: 0.3, animations: { () -> Void in
				button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
			}, completion:completion)
		} else {
			button.isSelected = false
			UIView.animate(withDuration: 0.3, animations: { () -> Void in
				button.transform = CGAffineTransform(scaleX: 1, y: 1)
			}, completion: completion)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		UIView.animate(withDuration: 0.3, animations: { () -> Void in
			self.engineerButton.transform = CGAffineTransform(scaleX: 1, y: 1)
			self.tutorialButton.transform = CGAffineTransform(scaleX: 1, y: 1)
			}, completion: nil)
		self.engineerButton.isSelected = false
		self.tutorialButton.isSelected = false
	}
}
