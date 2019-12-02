import Foundation

public struct IntcodeComputer {
    public private(set) var instructions: Array<Int>
    private var instructionPointer: Array<Int>.Index
    
    public init(instructions: Array<Int>) {
        self.instructions = instructions
        self.instructionPointer = self.instructions.startIndex
    }
    
    public mutating func run() {
        while true {
            let instruction = read()
            let opcode = Opcode(rawValue: instruction)!
            
            switch opcode {
            case .add:
                write { $0 + $1 }
            case .multiply:
                write { $0 * $1 }
            case .halt:
                return
            }
        }
    }

    private mutating func read() -> Int {
        defer { instructionPointer = instructions.index(after: instructionPointer) }
        return instructions[instructionPointer]
    }

    private mutating func write(_ callback: (Int, Int) -> Int) {
        let p1 = read()
        let p2 = read()
        let p3 = read()
        instructions[p3] = callback(instructions[p1], instructions[p2])
    }
}

fileprivate enum Opcode : Int {
    case add = 1
    case multiply = 2
    case halt = 99
}
