//
//  StoryBoardManager.swift
//  KK
//
//  Created by sphota on 5/21/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation

private let sB = UIStoryboard(name: "Main", bundle: nil)

class StoryBoardManager: NSObject {
	
	class var sharedManager: UIStoryboard {
		return sB
	}
}