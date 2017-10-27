/***
*
*
*
*
*
/*** OOP-Based Implementation of the Quine-McCluskey Simplification Algorithm ***/
*
*
*
*
*
***/

import Foundation
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


/*
-- Will be introduced to the scene as an object instance
-- Ultimately must produce an array of groups of minterms, represented as UInt16
-- Completely abstracted away from the View
-- Instantiated as a singleton
*/

/* TYPES */

typealias GroupType = Array<QMMinterm>
typealias OrderType = Dictionary<UInt, GroupType>
typealias PrimeType = Dictionary<String, QMMinterm>

private let qm = QMCore()

class QMCore: NSObject {
	class var minimizer: QMCore {
		return qm
	}
	fileprivate let tags = "abcdefghklmnpqrstuvwxyz"
	var magnitude : UInt = 0
	lazy var solutions = [GroupType]()
	lazy var equations = [QMProductSum]()
	
	
	fileprivate func sortedKeys (_ group: AnyObject) -> [UInt] {
	
		var keys : [UInt] = []
		if let mingroup = group as? OrderType {
			for (k, _) in (mingroup) {
				keys.append(k)
			}
			keys.sort(by: { $1 > $0 })
			return keys
		} else if let solutions = group as? [Int: [String]] {
			for (k, _) in (solutions) {
				keys.append(UInt(k))
			}
			keys.sort(by: { $1 > $0 })
			return keys
		}
		return []
	}
	
	
	fileprivate func splitBuffer (_ buffer: [AnyObject], orderGroup: OrderType, magnitude: UInt) -> OrderType {
		var order: OrderType = orderGroup
		for i in buffer {
			if let intKey = i as? UInt {
				if order[hashFunction(intKey)] == nil {
					order[hashFunction(intKey)] = GroupType()
				}
				order[hashFunction(intKey)]?.append(QMMinterm(i: intKey, m: magnitude))
			}
			else {
				if let impl = i as? QMMinterm {
					if order[hashBitCount(nonnul: impl.stringValue as AnyObject)] == nil {
						order[hashBitCount(nonnul: impl.stringValue as AnyObject)] = GroupType()
					}
					order[hashBitCount(nonnul: impl.stringValue as AnyObject)]?.append(impl)
				}
			}
		}
		return order
	}
	
	
	fileprivate func deriveNthOrder(_ buffer: [AnyObject], order: inout OrderType, residual: inout OrderType, magnitude: UInt) -> OrderType {
		if buffer.count == 0 {
			return order
		}
		order = OrderType()
		var temp = [AnyObject]()
		order = splitBuffer(buffer, orderGroup: order, magnitude: magnitude) // O(n)
		for key in sortedKeys(order as AnyObject) {
			guard let group = order[key] as GroupType?
				else { print("error"); break}
			for minterm1 in group {
				if order[key + 1] != nil {
					for minterm2 in order[key + 1]! {
						do {
							let im = try grayCodeDiff(minterm1, value2: minterm2)
							if im != nil {
								temp.append(im!)
								minterm1.paired = true
								minterm2.paired = true
							}
						}
						catch _ {
							print("comparison not possible")
						}
					}
				}
			}
		}
		for (_, v) in order {
			for minterm in v {
				if !minterm.paired {
					if residual[hashBitCount(nonnul: minterm.stringValue as AnyObject)] == nil {
						residual[hashBitCount(nonnul: minterm.stringValue as AnyObject)] = GroupType()
					}
					residual[hashBitCount(nonnul: minterm.stringValue as AnyObject)]?.append(minterm)
				}
			}
		}
		return deriveNthOrder(temp, order: &order, residual: &residual, magnitude: magnitude)
	}
	
	
	func computePrimeProducts (_ withMin: [UInt], magnitude: UInt) -> [QMProductSum]? {
		var withMinterms = withMin
		let timer = ParkBenchTimer() // start timer for algoithm
		var order = OrderType()
		var residual = OrderType()
		var primes = PrimeType()
		var ePrimes = PrimeType()
		var primesArray = GroupType()
		var petrick = [[String]]()
		self.magnitude = magnitude
        
		deriveNthOrder(withMinterms as [AnyObject], order: &order, residual: &residual, magnitude: magnitude)
		for (_, v) in residual {
			for m in v {
				primes[m.stringValue] = m
				if primes[m.stringValue]?.matches.count < 2 {
					primes[m.stringValue]?.matches.append(m)
				}
			}
		}
		for (_, min) in primes {
			primesArray.append(min)
		}
		//print(primesArray.count)
		if primesArray.count > 1 {
			reducePrimes(&primesArray, table: &withMinterms, ePrimes: &ePrimes)
		}
        // we must find only the essential primes in the prime matrix
		//print(primesArray.count)
		var em = GroupType()
		if primesArray.count >= 1 && withMinterms.count > 0 {
			var primeCount = 0
			for (_, v) in primes {
				v.tag = String(tags[tags.characters.index(tags.startIndex, offsetBy: primeCount)])
				primeCount = primeCount + 1
			}
			for min in withMinterms {
				petrick.append(Array<String>())
				for (p) in primesArray {
					if convertMintermArrayToUInt(p.matches).contains(min) {
						petrick[petrick.count - 1].append(p.tag)
					}
				}
				if petrick.last?.count == 0 {
					petrick.removeLast()
				}
			}
			var exp = [String]()
			let ccf = petrickify(&petrick)
			
			/* if we encounter a cyclical prime implicant cover (i.e. number of elements exceeds limit)
				then abandon ship */
			if ccf == nil {
				return equations
			}
			for s in petrick[0] {
				let ss = s.characters.sorted()
				exp.append(String(ss))
			}
			exp.sort(by: { $1.characters.count > $0.characters.count })
			var petrickDict = [Int: [String]]()
			for s in exp {
				if petrickDict[s.characters.count] == nil {
					petrickDict[s.characters.count] = [String]()
				}
				petrickDict[s.characters.count]?.append(s)
			}
			var primeDict = [String: QMMinterm]()
			var petrickPrimes = [GroupType]()
			for p in primesArray {
				primeDict[p.tag] = p
			}
			let keys = sortedKeys(petrickDict as AnyObject)
			let k = keys[0]
			let extras = petrickDict[Int(k)]
			/* extras contains a string array with strings with the smallest number of letter tags */
			var extrasByCountOfTerms = [Int: [String]]()
			for e in extras! {
				var key = 0
				for c in e.characters {
					print(primeDict[String(c)]!.stringValue)
					key += countVars(primeDict[String(c)]!)
				}
				if extrasByCountOfTerms[key] == nil {
					extrasByCountOfTerms[key] = [String]()
				}
				extrasByCountOfTerms[key]?.append(e)
			}
			let minkey = sortedKeys(extrasByCountOfTerms as AnyObject)[0]
			for (k, v) in extrasByCountOfTerms {
				if (UInt(k) == minkey) {
					for term in uniq(v) {
						var x = GroupType()
						for c in term.characters {
							x.append(primeDict[String(c)]!)
						}
						petrickPrimes.append(x)
					}
				}
			}
			for p in petrickPrimes {
				var solution = GroupType()
				for c in p {
					solution.append(c)
					for (_,e) in ePrimes {
						solution.append(e)
					}
				}
				solutions.append(uniq(solution))
			}
			print("The task took \(timer.stop() * 1000) ms")
			for s in solutions {
				let eq = QMProductSum(withProducts: s, magnitude: magnitude)
				equations.append(eq)
			}
			return equations
			/* TRIVIAL SOLUTION */
		} else { // if there is only one non-essential prime or none left in the table, return the final solution
			for (_, e) in ePrimes {
				em.append(e)
			}
			print("The task took \(timer.stop() * 1000) ms")
			let eq = QMProductSum(withProducts: em, magnitude: magnitude)
			equations.append(eq)
			return equations
		}
	}
	
	fileprivate func convertMintermArrayToUInt (_ array: GroupType) -> Array<UInt> {
		var b = Array<UInt>()
		for a in array {
			b.append(a.intValue)
		}
		return b
	}
	
	fileprivate func reducePrimes( _ primes: inout GroupType, table: inout [UInt], ePrimes: inout PrimeType) -> GroupType {
		var minGroupForEssentialPrimes = [UInt]()
		var x = [UInt]()
		for m in primes {
			x += convertMintermArrayToUInt(m.matches)
		}
		for (k, v) in x.freq() {
			if v == 1 && table.contains(k) {
				minGroupForEssentialPrimes.append(UInt(k))
			}
		}
		if  minGroupForEssentialPrimes.count == 0 || primes.count < 2  {
			return primes
		}
		for x in minGroupForEssentialPrimes {
			for p in primes {
				if convertMintermArrayToUInt(p.matches).contains(x) {
					ePrimes[p.stringValue] = p
					if table.index(of: x) != nil {
						table.remove(at: table.index(of: x)!)
					}
					
				}
			}
		}
		/* remove essential primes from prime table */
		for p in primes {
			for (_, q) in ePrimes {
				if p.stringValue == q.stringValue {
					primes.remove(at: primes.index(of: q)!)
				}
			}
		}
		for (_,q) in ePrimes {
			for match in convertMintermArrayToUInt(q.matches) {
				if table.contains(match) {
					if table.index(of: match) != nil {
						table.remove(at: table.index(of: match)!)
					}
				}
			}
		}
		return reducePrimes(&primes, table: &table, ePrimes: &ePrimes)
	}
	
	fileprivate func petrickify(_ expression: inout [[String]]) -> [[String]]? {
		if expression.count == 1  {
			return expression
		}
		if expression[0].count > 100000 {
            // equation too complex to be simplifed using petrick's method
			return nil
		}
		expression[0] &= expression[1]
        // reduce expression in petrick's form until only one element is left
		expression.remove(at: 1)
		return petrickify(&expression)
	}
	
	fileprivate func countVars (_ forMinterm: QMMinterm) -> Int {
		return Int(self.magnitude) - (forMinterm.stringValue.components(separatedBy: "-").count - 1)
	}
	
	fileprivate func hashBitCount (nonnul value: AnyObject) -> UInt {
		if let n = value as? UInt {
			var num = n;
			var count: UInt = 0;
			while(num != 0) {
				num = num & (num - 1);
				count += 1;
			}
			return count;
		} else if let s = value as? String {
			var count: UInt = 0
			for c in s.characters {
				if c == "1" {
					count += 1;
				}
			}
			return count
		} else {
			return 0
		}
		
	}
	
	fileprivate func grayCodeDiff (_ value1: AnyObject, value2: AnyObject) throws -> QMMinterm? {
		guard let min1 = value1 as? QMMinterm
			else { return nil }
		guard let min2 = value2 as? QMMinterm
			else { return nil }
		if min1.intValue != implicantFlag && min2.intValue != implicantFlag {
			let comparator = min1.intValue ^ min2.intValue
			if log2(Double(comparator)).truncatingRemainder(dividingBy: 1) == 0 {
				let im = QMMinterm(min1: min1, min2: min2, idx: UInt(log2(Double(comparator))))
				im.matches.append(min1)
				im.matches.append(min2)
				return im
			} else {
				return nil
			}
		} else {
			let comparator = min1.stringValue ^ min2.stringValue
			if log2(Double(comparator)).truncatingRemainder(dividingBy: 1) == 0 {
				let im = QMMinterm(min1: min1, min2: min2, idx: UInt(log2(Double(comparator))))
				for m in min1.matches {
					im.matches.append(m)
				}
				for m in min2.matches {
					im.matches.append(m)
				}
				return im
			} else {
				return nil
			}
		}
	}
	
	fileprivate func hashFunction (_ value: UInt) -> UInt {
		let key = hashBitCount(nonnul: value as AnyObject)
		return key
	}
}
