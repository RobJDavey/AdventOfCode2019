import Foundation

public func process(_ instructions: [Int], input: Int = 1) -> Int {
    var ic = IntcodeComputer(instructions: instructions)
    return ic.run(input: input)
}


