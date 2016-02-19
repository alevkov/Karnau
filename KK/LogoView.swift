//
//  LogoView.swift
//  KK
//
//  Created by sphota on 2/15/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import UIKit

class LogoView: UIView {
	
	lazy var mesh = UIView()
//	
//	class func instanceFromNib() -> UIView {
//		if UIScreen.mainScreen().bounds.width > 320 {
//			
//			
//			return (UINib(nibName: "Logo@3", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView)!
//		} else {
//			return (UINib(nibName: "Logo@2", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView)!
//		}
//	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		let v = (UINib(nibName: "Logo@3", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView)!
		self.addSubview(v)
		//self.frame = v.frame
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//		super.drawRect(rect)
//		setNeedsDisplay()
//	}

}
