import Foundation

public func runPermutation(_ instructions: [Int], with phases: [Int]) -> Int {
    let amps: [IntcodeComputer] = phases.map { IntcodeComputer(instructions: instructions, inputs: [$0]) }
    
    for (offset, amp) in amps.enumerated() {
        let previousIndex = offset == 0 ? 4 : offset - 1
        let previous = amps[previousIndex]
        amp.previous = previous
        previous.next = amp
    }
    
    var amp = amps[0]
    amp.add(input: 0)
    
    while !amp.isHalted {
        amp.run()
        amp = amp.next!
    }
    
    return amps[4].outputs.last!
}

func runPermutations(_ instructions: [Int], phases: [Int], remaining: [Int], best: inout Int) {
    guard !remaining.isEmpty else {
        let thruster = runPermutation(instructions, with: phases)
        
        if thruster > best {
            best = thruster
        }
        
        return
    }
    
    for (index, item) in remaining.enumerated() {
        var left = remaining
        left.remove(at: index)
        runPermutations(instructions, phases: phases + [item], remaining: left, best: &best)
    }
}

func run(_ instructions: [Int], range: ClosedRange<Int>) -> Int {
    var best: Int = 0
    runPermutations(instructions, phases: [], remaining: Array(range), best: &best)
    return best
}

public let part1 = { run($0, range: 0...4) }
public let part2 = { run($0, range: 5...9) }
