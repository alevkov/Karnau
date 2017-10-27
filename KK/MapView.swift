//
//  MapView.swift
//  KK
//
//  Created by sphota on 2/15/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class MapView: UIView {
	let groupErr: UInt = 0b0010
	var mesh: Mesh?
	var magnitude: UInt?
	var onCoordinates: [CGPoint]?
	var dcCoordinates: [CGPoint]?
	var mintermButtons: [UIButton] = [UIButton]()
	var offMintermButtons: [UIButton] = [UIButton]()
	var solutions: [QMProductSum]? = [QMProductSum]()
	fileprivate var selectedMintermButtons: [UInt : UIButton] = [UInt : UIButton]()
	fileprivate var selectedProductSum: QMProductSum = QMProductSum(withProducts: [], magnitude: 0)
	fileprivate var isAttemptingWrapAround: Bool = false

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.isOpaque = false
		self.backgroundColor = bgColor
	}
	
	convenience init(frame: CGRect, magnitude: Int, table: [UInt]) {
		self.init(frame: frame)
		//self.damping = 0.7
		//self.initialSpringVelocity = 0.8
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: didResetTableOnMapViewNotification), object: nil, queue: nil) { (notification) in
			self.selectedProductSum = QMProductSum(withProducts: [], magnitude: 0)
			for b in self.mintermButtons {
				b.isSelected = false
				b.backgroundColor = bgColor
			}
			for view in self.subviews {
				if view.tag == -1 {
					UIView .animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: { 
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
					mintermInMapView = UIButton(frame: CGRect(x: m.coordinate!.x - 20, y: m.coordinate!.y - 20, width: 40, height: 40))
				} else {
					mintermInMapView = UIButton(frame: CGRect(x: m.coordinate!.x - 40, y: m.coordinate!.y - 40, width: 80, height: 80))
				}
				mintermInMapView.setTitle("1", for: UIControlState())
				mintermInMapView.titleLabel?.textColor = UIColor.white
				mintermInMapView.tag = Int(m.minterm!.intValue)
				mintermInMapView.isUserInteractionEnabled = false;
				self.addSubview(mintermInMapView)
				self.mintermButtons.append(mintermInMapView)
			} else {
				var offMintermInMapView: UIButton
				if magnitude > 2 {
					offMintermInMapView = UIButton(frame: CGRect(x: m.coordinate!.x - 20, y: m.coordinate!.y - 20, width: 40, height: 40))
				} else {
					offMintermInMapView = UIButton(frame: CGRect(x: m.coordinate!.x - 40, y: m.coordinate!.y - 40, width: 80, height: 80))
				}
				offMintermInMapView.tag = Int((m.minterm?.intValue)!)
				offMintermInMapView.isUserInteractionEnabled = false;
				self.addSubview(offMintermInMapView)
				self.offMintermButtons.append(offMintermInMapView)
			}
		}
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: didCallForCheckEquationNotification), object: self, queue: nil) { (notification) in
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
			NotificationCenter.default.post(name: Notification.Name(rawValue: didCheckEquationNotification), object: self, userInfo: data)
		}
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func drawMapBorders(_ frame: CGRect) {
		let rectanglePath = UIBezierPath(roundedRect: CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y	, width: self.bounds.width, height: self.bounds.height), cornerRadius: 0)
		rectanglePath.lineWidth = 5
		UIColor.white.setStroke()
		rectanglePath.stroke()
	}
	
	fileprivate func drawRectAroundButtons(_ buttons: [UIButton], wrapAround: Bool) {
		var frames = [CGRect]()
		for b in buttons {
			frames.append(b.frame)
		}
		if wrapAround == true {
			// make frame around each minterm individually and animate them
			for f in frames {
				let grabView = UIView(frame: f)
				grabView.addDashedBorder(normalGroupColor, animated: true)
				grabView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
				grabView.tag = -1
				self.addSubview(grabView)
			}
		} else {
			while frames.count > 1 {
				frames[0] = frames[0].union(frames[1])
				frames.remove(at: 1)
			}
			let grabView = UIView(frame: frames[0])
			grabView.addDashedBorder(normalGroupColor, animated: false)
			grabView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
			grabView.tag = -1
			self .addSubview(grabView)
		}
	}
	
	fileprivate func touchedEndedWithError() {
		var data: [String: UInt] = [String: UInt]()
		data["error"] = groupErr
		for b in self.mintermButtons {
			if b.isSelected {
				b.isSelected = false;
				b.backgroundColor = UIColor.clear
			}
		}
		self.isAttemptingWrapAround = false
		NotificationCenter.default.post(name: Notification.Name(rawValue: didSelectGroupNotification), object: self, userInfo: data)
	}
}

// Geometry
extension MapView {
	override func draw(_ rect: CGRect) {
		self.drawMapBorders(rect)
	}
}

// Touch Handlers
extension MapView {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.isAttemptingWrapAround = false
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = event?.allTouches?.first
		let touchLocation = touch?.location(in: self)
		for b in self.mintermButtons {
			if b.frame.contains(touchLocation!){
				if self.isAttemptingWrapAround == true {
					b.backgroundColor = wrapAroundGroupColor
				} else {
					b.backgroundColor = UIColor(hex: 0x50E3C2, alpha: 0.8)
				}
				
				b.isSelected = true;
			}
		}
		if !self.bounds.contains(touchLocation!) {
			print(touchLocation!)
			let options: UIViewAnimationOptions = UIViewAnimationOptions()
			var rotationAndPerspectiveTransform = CATransform3DIdentity
			rotationAndPerspectiveTransform.m34 = 1.0 / -500
			rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 20 * CGFloat(Double.pi) / 180, 1.0, 0.0, 0.0)
			UIView.animate(withDuration: 0.5, delay: 0.0, options: options, animations: {
				self.alpha = 0.3
				self.layer.transform = rotationAndPerspectiveTransform
				}, completion: nil)
			self.isAttemptingWrapAround = true
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.alpha = 1
		self.layer.transform = CATransform3DIdentity
		let touch = event?.allTouches?.first
		let touchLocation = touch?.location(in: self)
		// check if we landed outside of the map upon releasing touch
		guard self.bounds.contains(touchLocation!) else {
			self.touchedEndedWithError()
			return
		}
		var table = [UInt]()
		var group = [UIButton]()
		for b in self.mintermButtons {
			if b.isSelected {
				table.append(UInt(b.tag))
				group.append(b)
				b.backgroundColor = bgColor
			}
		}
		// check if we have selected any minterms at all
		guard table.count > 0 else { return }
		var equation = QMCore.minimizer.computePrimeProducts(table, magnitude: self.magnitude!)
		var data: [String: QMProductSum] = [String: QMProductSum]()
		guard log2(Double(group.count)).truncatingRemainder(dividingBy: 1) == 0 && equation?.last?.minCount <= 1 else {
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
			if b.isSelected {
				b.isSelected = false;
			}
		}
		self.isAttemptingWrapAround = false
		NotificationCenter.default.post(name: Notification.Name(rawValue: didSelectGroupNotification), object: self, userInfo: data)
	}
}
