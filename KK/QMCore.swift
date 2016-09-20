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

/*
-- This class will be introduced to the scene as an object instance
-- Ultimately must produce an array of groups of minterms, represented as UInt16
-- Must be completely abstracted away from the GameScene, except for the instance
-- Application can have multiple instances running, but one per level/scene
*/

private let qm = QMCore()

class QMCore: NSObject {
	class var minimizer: QMCore {
		return qm
	}
	private let tags = "abcdefghklmnpqrstuvwxyz"
	var magnitude : UInt = 0
	lazy var solutions = [GroupType]()
	lazy var equations = [QMProductSum]()
	
	/*----------------------------------------------------------*/
	private func sortedKeys (group: AnyObject) -> [UInt] {
	/*----------------------------------------------------------*/
		var keys : [UInt] = []
		if let mingroup = group as? OrderType {
			for (k, _) in (mingroup) {
				keys.append(k)
			}
			keys.sortInPlace({ $1 > $0 })
			return keys
		} else if let solutions = group as? [Int: [String]] {
			for (k, _) in (solutions) {
				keys.append(UInt(k))
			}
			keys.sortInPlace({ $1 > $0 })
			return keys
		}
		return []
	}
	
	/*----------------------------------------------------------*/
	private func splitBuffer (buffer: [AnyObject], var order: OrderType, magnitude: UInt) -> OrderType {
	/*----------------------------------------------------------*/
		for i in buffer {
			if let intKey = i as? UInt {
				if order[hashFunction(intKey)] == nil {
					order[hashFunction(intKey)] = GroupType()
				}
				order[hashFunction(intKey)]?.append(QMMinterm(i: intKey, m: magnitude))
			}
			else {
				if let impl = i as? QMMinterm {
					if order[hashBitCount(nonnul: impl.stringValue)] == nil {
						order[hashBitCount(nonnul: impl.stringValue)] = GroupType()
					}
					order[hashBitCount(nonnul: impl.stringValue)]?.append(impl)
				}
			}
		}
		return order
	}
	
	/*----------------------------------------------------------*/
	private func deriveNthOrder(buffer: [AnyObject], inout order: OrderType, inout residual: OrderType, magnitude: UInt) -> OrderType {
	/*----------------------------------------------------------*/
		if buffer.count == 0 {
			return order
		}
		order = OrderType()
		var temp = [AnyObject]()
		order = splitBuffer(buffer, order: order, magnitude: magnitude) // O(n)
		for key in sortedKeys(order) {
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
					if residual[hashBitCount(nonnul: minterm.stringValue)] == nil {
						residual[hashBitCount(nonnul: minterm.stringValue)] = GroupType()
					}
					residual[hashBitCount(nonnul: minterm.stringValue)]?.append(minterm)
				}
			}
		}
		return deriveNthOrder(temp, order: &order, residual: &residual, magnitude: magnitude)
	}
	
	/*----------------------------------------------------------*/
	func computePrimeProducts (var withMinterms: [UInt], magnitude: UInt) -> [QMProductSum]? {
	/*----------------------------------------------------------*/
		let timer = ParkBenchTimer() // start timer for algoithm
		var order = OrderType()
		var residual = OrderType()
		var primes = PrimeType()
		var ePrimes = PrimeType()
		var primesArray = GroupType()
		var petrick = [[String]]()
		self.magnitude = magnitude
		deriveNthOrder(withMinterms, order: &order, residual: &residual, magnitude: magnitude)
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
		print(primesArray.count)
		if primesArray.count > 1 {
			reducePrimes(&primesArray, table: &withMinterms, ePrimes: &ePrimes)
		}
		print(primesArray.count)
		var em = GroupType()
		if primesArray.count >= 1 && withMinterms.count > 0 {
			var primeCount = 0
			for (_, v) in primes {
				v.tag = String(tags[tags.startIndex.advancedBy(primeCount)])
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
			
			/* if we encounter a cyclical PI cover,
				then abandon ship */
			if ccf == nil {
				return equations
			}
			for s in petrick[0] {
				let ss = s.characters.sort()
				exp.append(String(ss))
			}
			exp.sortInPlace({ $1.characters.count > $0.characters.count })
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
			let keys = sortedKeys(petrickDict)
			let key = keys[0]
			let extras = petrickDict[Int(key)]
			
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
			let minkey = sortedKeys(extrasByCountOfTerms)[0]
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
	
	private func convertMintermArrayToUInt (array: GroupType) -> Array<UInt> {
		var b = Array<UInt>()
		for a in array {
			b.append(a.intValue)
		}
		return b
	}
	
	private func reducePrimes( inout primes: GroupType, inout table: [UInt], inout ePrimes: PrimeType) -> GroupType {
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
					if table.indexOf(x) != nil {
						table.removeAtIndex(table.indexOf(x)!)
					}
					
				}
			}
			
		}
		/* remove EP's from prime table */
		for p in primes {
			for (_, q) in ePrimes {
				if p.stringValue == q.stringValue {
					primes.removeAtIndex(primes.indexOf(q)!)
				}
			}
		}
		for (_,q) in ePrimes {
			for match in convertMintermArrayToUInt(q.matches) {
				if table.contains(match) {
					if table.indexOf(match) != nil {
						table.removeAtIndex(table.indexOf(match)!)
					}
				}
			}
		}
		return reducePrimes(&primes, table: &table, ePrimes: &ePrimes)
	}
	private func petrickify(inout expression: [[String]]) -> [[String]]? {
		if expression.count == 1  {
			return expression
		}
		if expression[0].count > 100000 {
			return nil
		}
		print(expression)
		print("----")
		expression[0] &= expression[1]
		expression.removeAtIndex(1)
		return petrickify(&expression)
	}
	
	private func countVars (forMinterm: QMMinterm) -> Int {
		return Int(self.magnitude) - (forMinterm.stringValue.componentsSeparatedByString("-").count - 1)
	}
	
	/*----------------------------------------------------------*/
	private func hashBitCount (nonnul value: AnyObject) -> UInt {
	/*----------------------------------------------------------*/
		if let n = value as? UInt {
			var num = n;
			var count: UInt = 0;
			while(num != 0)
			{
				num = num & (num - 1);
				count = count + 1;
			}
			return count;
		} else if let s = value as? String {
			var count: UInt = 0
			for c in s.characters {
				if c == "1" {
					count = count + 1;
				}
			}
			return count
		} else {
			return 0
		}
		
	}
	
	/*----------------------------------------------------------*/
	private func grayCodeDiff (value1: AnyObject, value2: AnyObject) throws -> QMMinterm? {
	/*----------------------------------------------------------*/
		guard let min1 = value1 as? QMMinterm
			else { throw Error.UnknownType }
		guard let min2 = value2 as? QMMinterm
			else { throw Error.UnknownType }
		if min1.intValue != IMPLICANT_FLAG && min2.intValue != IMPLICANT_FLAG {
			let comparator = min1.intValue ^ min2.intValue
			if log2(Double(comparator)) % 1 == 0 {
				let im = QMMinterm(min1: min1, min2: min2, idx: UInt(log2(Double(comparator))))
				im.matches.append(min1)
				im.matches.append(min2)
				return im
			}
			else {
				return nil
			}
		} else {
			let comparator = min1.stringValue ^ min2.stringValue
			if log2(Double(comparator)) % 1 == 0 {
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
	
	/*----------------------------------------------------------*/
	private func hashFunction (value: UInt) -> UInt {
	/*----------------------------------------------------------*/
		let key = hashBitCount(nonnul: value)
		return key
	}
}
