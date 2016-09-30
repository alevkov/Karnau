//
//  QMTypeDef.swift
//  K
//
//  Created by sphota on 1/20/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import Foundation

class QMMinterm : NSObject {
	private let vars = ["A", "B", "C", "D", "E", "F"]
	var intValue: UInt = 0;
	var stringValue: String = "";
	var letters: String = "";
	var count: Int = 0;
	var magnitude: UInt = 0;
	var matches	: [QMMinterm] = []
	var paired: Bool = false
	var essential: Bool = false
	var tag: String = ""
	
	init(i: UInt, m: UInt) {
		if i == implicantFlag {
			self.intValue = implicantFlag;
			self.stringValue = "";
		} else if i == primeFlag {
			self.intValue = 0
			self.magnitude = 0
		} else {
			if m <= maxMagnitude {
				self.magnitude = m;
				self.intValue = i;
				self.stringValue = String(self.intValue, radix: 2);
				
				self.stringValue = "0" * (m - UInt(self.stringValue.characters.count)) + self.stringValue
				for s in self.stringValue.characters {
					if s == "1" { self.letters += vars[self.count] } else { self.letters += (vars[self.count].lowercaseString) }
					self.count = self.count + 1
				}
			}
		}
		
	}
	
	convenience init (min1: QMMinterm, min2: QMMinterm, idx: UInt) {
		self.init(i: implicantFlag, m: min1.magnitude)
		var s = min1.stringValue
		s.replaceRange(s.startIndex.advancedBy(Int(s.characters.count - 1) - Int(idx))...s.startIndex.advancedBy(Int(s.characters.count - 1) - Int(idx)), with: "-")
		self.stringValue = s
	}
	
	convenience init(str: String, magnitude: UInt) {
		self.init(i: primeFlag, m: magnitude)
		self.magnitude = UInt(str.characters.count)
	}
	
	func print() {
		if self.intValue != implicantFlag || self.intValue != primeFlag {
			Swift.print("\(stringValue) : \(intValue) : \(letters)");
		}
		else {
			Swift.print(self.stringValue + " " + self.matches.debugDescription)
		}
		
	}
}

/* Equatable */

func ==(lhs: QMMinterm, rhs: QMMinterm) -> Bool {
	if lhs.stringValue == "" && rhs.stringValue == "" {
		return lhs.intValue == rhs.intValue
	} else {
		return lhs.stringValue == rhs.stringValue
	}
}

