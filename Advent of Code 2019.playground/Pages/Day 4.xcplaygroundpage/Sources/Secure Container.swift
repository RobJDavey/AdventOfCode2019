import Foundation

public typealias CharacterCount = (character: Character, count: Int)
public typealias Predicate = ([CharacterCount]) -> Bool

public let part1Predicate: Predicate = { totals in totals.contains { $0.count >= 2 }}
public let part2Predicate: Predicate = { totals in totals.contains { $0.count == 2 }}

func getCounts(_ text: String) -> (totals: [CharacterCount], increased: Bool) {
    precondition(!text.isEmpty)
    var current = text.first!
    var count = 0
    var value = 0
    var totals: [(Character, Int)] = []
    
    for character in text {
        let characterValue = Int("\(character)")!
        
        guard characterValue >= value else {
            return ([], false)
        }
        
        value = characterValue
        
        if character == current {
            count += 1
        } else {
            totals.append((current, count))
            current = character
            count = 1
        }
    }
    
    totals.append((current, count))
    return (totals, true)
}

public func isValid(_ password: Int, predicate: Predicate) -> Bool {
    let counts = getCounts("\(password)")
    return counts.increased && predicate(counts.totals)
}

func run(_ range: ClosedRange<Int>, _ predicate: Predicate) -> Int { range.filter { isValid($0, predicate: predicate) }.count }

public func part1(_ range: ClosedRange<Int>) -> Int { run(range, part1Predicate) }
public func part2(_ range: ClosedRange<Int>) -> Int { run(range, part2Predicate) }
