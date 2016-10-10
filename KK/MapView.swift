//
//  MapView.swift
//  KK
//
//  Created by sphota on 2/15/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import UIKit

class MapView: UIView {
	let groupErr: UInt = 0b0010
	var mesh: Mesh?
	var magnitude: UInt?
	var onCoordinates: [CGPoint]?
	var dcCoordinates: [CGPoint]?
	var mintermButtons: [UIButton] = [UIButton]()
	var offMintermButtons: [UIButton] = [UIButton]()
	var solutions: [QMProductSum]? = [QMProductSum]()
	private var selectedMintermButtons: [UInt : UIButton] = [UInt : UIButton]()
	private var selectedProductSum: QMProductSum = QMProductSum(withProducts: [], magnitude: 0)
	private var isAttemptingWrapAround: Bool = false

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.opaque = false
		self.backgroundColor = bgColor
	}
	
	convenience init(frame: CGRect, magnitude: Int, table: [UInt]) {
		self.init(frame: frame)
		NSNotificationCenter.defaultCenter().addObserverForName(didResetTableOnMapViewNotification, object: nil, queue: nil) { (notification) in
			self.selectedProductSum = QMProductSum(withProducts: [], magnitude: 0)
			for b in self.mintermButtons {
				b.selected = false
				b.backgroundColor = bgColor
			}
			for view in self.subviews {
				if view.tag == -1 {
					UIView .animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
						view.alpha = 0;
						}, completion: { (done) in
							view.removeFromSuperview()
					})
				}
			}
			self.selectedMintermButtons.removeAll()
		}
		self.magnitude = UInt(magnitude)
		let mesh = Mesh(frame: self.bounds, magnitude: magnitude, table: table)
		self.mesh = mesh
		self.addSubview(mesh)
		for m in mesh.qmmap!.minterms {
			if (m.state == on) {
				var mintermInMapView: UIButton
				if magnitude > 2 {
					mintermInMapView = UIButton(frame: CGRectMake(m.coordinate!.x - 20, m.coordinate!.y - 20, 40, 40))
				} else {
					mintermInMapView = UIButton(frame: CGRectMake(m.coordinate!.x - 40, m.coordinate!.y - 40, 80, 80))
				}
				mintermInMapView.setTitle("1", forState: UIControlState.Normal)
				mintermInMapView.titleLabel?.textColor = UIColor.whiteColor()
				mintermInMapView.tag = Int(m.minterm!.intValue)
				mintermInMapView.userInteractionEnabled = false;
				self.addSubview(mintermInMapView)
				self.mintermButtons.append(mintermInMapView)
			} else {
				var offMintermInMapView: UIButton
				if magnitude > 2 {
					offMintermInMapView = UIButton(frame: CGRectMake(m.coordinate!.x - 20, m.coordinate!.y - 20, 40, 40))
				} else {
					offMintermInMapView = UIButton(frame: CGRectMake(m.coordinate!.x - 40, m.coordinate!.y - 40, 80, 80))
				}
				offMintermInMapView.tag = Int((m.minterm?.intValue)!)
				offMintermInMapView.userInteractionEnabled = false;
				self.addSubview(offMintermInMapView)
				self.offMintermButtons.append(offMintermInMapView)
			}
		}
		NSNotificationCenter.defaultCenter().addObserverForName(didCallForCheckEquationNotification, object: self, queue: nil) { (notification) in
			var correct = false
			self.selectedProductSum.print()
			guard self.solutions != nil else { return }
			for e in self.solutions! {
				e.print()
				if self.selectedProductSum == e {
					correct = true
					break
				}
			}
			let data = ["correct" : correct]
			NSNotificationCenter.defaultCenter().postNotificationName(didCheckEquationNotification, object: self, userInfo: data)
		}
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	private func drawMapBorders(frame: CGRect) {
		let rectanglePath = UIBezierPath(roundedRect: CGRectMake(self.bounds.origin.x, self.bounds.origin.y	, self.bounds.width, self.bounds.height), cornerRadius: 0)
		rectanglePath.lineWidth = 5
		UIColor.whiteColor().setStroke()
		rectanglePath.stroke()
	}
	
	private func drawRectAroundButtons(buttons: [UIButton], wrapAround: Bool) {
		var frames = [CGRect]()
		for b in buttons {
			frames.append(b.frame)
		}
		if wrapAround == true {
			// make frame around each minterm individually and animate them
			for f in frames {
				let grabView = UIView(frame: f)
				grabView.addDashedBorder(normalGroupColor, animated: true)
				grabView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
				grabView.tag = -1
				self.addSubview(grabView)
			}
		} else {
			while frames.count > 1 {
				frames[0] = CGRectUnion(frames[0], frames[1])
				frames.removeAtIndex(1)
			}
			let grabView = UIView(frame: frames[0])
			grabView.addDashedBorder(normalGroupColor, animated: false)
			grabView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
			grabView.tag = -1
			self .addSubview(grabView)
		}
	}
	
	private func touchedEndedWithError() {
		var data: [String: UInt] = [String: UInt]()
		data["error"] = groupErr
		for b in self.mintermButtons {
			if b.selected {
				b.selected = false;
				b.backgroundColor = UIColor.clearColor()
			}
		}
		self.isAttemptingWrapAround = false
		NSNotificationCenter.defaultCenter().postNotificationName(didSelectGroupNotification, object: self, userInfo: data)
	}
}

// Geometry
extension MapView {
	override func drawRect(rect: CGRect) {
		self.drawMapBorders(rect)
	}
}

// Touch Handlers
extension MapView {
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.isAttemptingWrapAround = false
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch = event?.allTouches()?.first
		let touchLocation = touch?.locationInView(self)
		for b in self.mintermButtons {
			if CGRectContainsPoint(b.frame, touchLocation!){
				if self.isAttemptingWrapAround == true {
					b.backgroundColor = wrapAroundGroupColor
				} else {
					b.backgroundColor = UIColor(hex: 0x50E3C2, alpha: 0.8)
				}
				
				b.selected = true;
			}
		}
		if !CGRectContainsPoint(self.bounds, touchLocation!) {
			let options: UIViewAnimationOptions = [.CurveEaseInOut]
			UIView.animateWithDuration(0.5, delay: 0.0, options: options, animations: {
				self.alpha = 0.3
				}, completion: nil)
			self.isAttemptingWrapAround = true
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.alpha = 1
		let touch = event?.allTouches()?.first
		let touchLocation = touch?.locationInView(self)
		// check if we landed outside of the map upon releasing touch
		guard CGRectContainsPoint(self.bounds, touchLocation!) else {
			self.touchedEndedWithError()
			return
		}
		var table = [UInt]()
		var group = [UIButton]()
		for b in self.mintermButtons {
			if b.selected {
				table.append(UInt(b.tag))
				group.append(b)
				b.backgroundColor = bgColor
			}
		}
		// check if we have selected any minterms at all
		guard table.count > 0 else { return }
		var equation = QMCore.minimizer.computePrimeProducts(table, magnitude: self.magnitude!)
		var data: [String: QMProductSum] = [String: QMProductSum]()
		guard log2(Double(group.count)) % 1 == 0 && equation?.last?.minCount <= 1 else {
			self.touchedEndedWithError()
			return
		}
		self.drawRectAroundButtons(group, wrapAround: self.isAttemptingWrapAround)
		// this is the ugliest way of doing things but shoot me, I'm tired
		self.selectedProductSum.addProduct(equation!.last!.products.last!)
		data["data"] = equation?.popLast()
		// I'M SORRY
		if (data["data"]! as QMProductSum).products.count == 1 && (data["data"]! as QMProductSum).products[0].matches.count == (2^^Int(magnitude!)) {
			(data["data"]! as QMProductSum).stringValue = "1"
		}
		equation?.removeAll()
		for b in self.mintermButtons {
			if b.selected {
				b.selected = false;
			}
		}
		self.isAttemptingWrapAround = false
		NSNotificationCenter.defaultCenter().postNotificationName(didSelectGroupNotification, object: self, userInfo: data)
	}
}
