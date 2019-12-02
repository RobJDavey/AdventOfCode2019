import Foundation

public func part1(_ instructions: [Int]) -> Int {
    var instructions = instructions
    instructions[1...2] = [12, 2]
    
    var ic = IntcodeComputer(instructions: instructions)
    _ = ic.run()
    return ic.instructions[0]
}

public func part2(_ instructions: [Int], target: Int = 19690720) -> Int {
    for noun in 0...99 {
        for verb in 0...99 {
            var instructions = instructions
            instructions[1] = noun
            instructions[2] = verb
            var ic = IntcodeComputer(instructions: instructions)
            ic.run()
            
            if ic.instructions[0] == target {
                return Int("\(noun)\(verb)")!
            }
        }
    }
    
    fatalError()
}

public func process(_ instructions: [Int]) -> [Int] {
    var ic = IntcodeComputer(instructions: instructions)
    ic.run()
    return ic.instructions
}
