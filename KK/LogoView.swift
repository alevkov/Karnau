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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		let v = (UINib(nibName: "Logo@3", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView)!
		self.addSubview(v)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
