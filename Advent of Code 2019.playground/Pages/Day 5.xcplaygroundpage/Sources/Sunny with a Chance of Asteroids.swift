import Foundation

public func process(_ instructions: [Int], input: Int = 1) -> Int {
    let ic = IntcodeComputer(instructions: instructions, inputs: [input])
    ic.run()
    return ic.outputs.last ?? 0
}
