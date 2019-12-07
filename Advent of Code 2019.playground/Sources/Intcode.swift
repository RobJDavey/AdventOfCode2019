import Foundation

public class IntcodeComputer {
    public private(set) var instructions: Array<Int>
    public private(set) var inputs: [Int]
    public private(set) var outputs: [Int] = []
    public private(set) var isHalted: Bool = false
    public var previous: IntcodeComputer?
    public var next: IntcodeComputer?
    private var instructionPointer: Array<Int>.Index
    
    public init(instructions: Array<Int>, inputs: [Int] = []) {
        self.instructions = instructions
        self.instructionPointer = self.instructions.startIndex
        self.inputs = inputs
    }
    
    public func add(input: Int) {
        self.inputs.append(input)
    }
    
    public func add(inputs: [Int]) {
        self.inputs.append(contentsOf: inputs)
    }
    
    func readOutput() -> Int {
        return self.outputs.removeFirst()
    }
    
    public func run() {
        guard !isHalted else {
            return
        }
        
        if let previous = previous {
            inputs.append(contentsOf: previous.outputs)
            previous.outputs = []
        }
        
        while true {
            let instruction = read()
            let (opcode, m1, m2, m3) = Self.parse(instruction: instruction)
            
            switch opcode {
            case .add:
                write(mode1: m1, mode2: m2, mode3: m3, +)
            case .multiply:
                write(mode1: m1, mode2: m2, mode3: m3, *)
            case .input:
                if inputs.isEmpty {
                    instructionPointer -= 1
                    return
                }
                
                self.write(mode1: m1) { self.inputs.removeFirst() }
            case .output:
                outputs.append(read(mode1: m1))
            case .jumpIfTrue:
                jump(mode1: m1, mode2: m2) { $0 != 0 }
            case .jumpIfFalse:
                jump(mode1: m1, mode2: m2) { $0 == 0 }
            case .lessThan:
                write(mode1: m1, mode2: m2, mode3: m3) { $0 < $1 ? 1 : 0 }
            case .equals:
                write(mode1: m1, mode2: m2, mode3: m3) { $0 == $1 ? 1 : 0 }
            case .halt:
                isHalted = true
                return
            }
        }
    }
    
    private subscript(value: Int, mode: ParameterMode) -> Int {
        get {
            switch mode {
            case .position:
                return instructions[value]
            case .immediate:
                return value
            }
        }
        
        set {
            switch mode {
            case .position:
                instructions[value] = newValue
            case .immediate:
                fatalError()
            }
        }
    }
    
    private static func parse(instruction: Int) -> (opcode: Opcode, mode1: ParameterMode, mode2: ParameterMode, mode3: ParameterMode) {
        let de = instruction % 100
        let c = (instruction / 100) % 10
        let b = (instruction / 1000) % 10
        let a = (instruction / 10000) % 10
        
        guard let opcode = Opcode(rawValue: de),
            let mode1 = ParameterMode(rawValue: c),
            let mode2 = ParameterMode(rawValue: b),
            let mode3 = ParameterMode(rawValue: a) else {
            fatalError("Failed to parse opcode \(de), modes: \(c), \(b), \(a)")
        }
        
        return (opcode, mode1, mode2, mode3)
    }

    private func read() -> Int {
        defer { instructionPointer = instructions.index(after: instructionPointer) }
        return instructions[instructionPointer]
    }
    
    private func read(mode1: ParameterMode) -> Int {
        let p1 = read()
        return self[p1, mode1]
    }
    
    private func write(mode1: ParameterMode, _ callback: () -> Int) {
        let p1 = read()
        let result = callback()
        self[p1, mode1] = result
    }

    private func write(mode1: ParameterMode, mode2: ParameterMode, mode3: ParameterMode, _ callback: (Int, Int) -> Int) {
        let p1 = read()
        let p2 = read()
        let p3 = read()
        let lhs = self[p1, mode1]
        let rhs = self[p2, mode2]
        let result = callback(lhs, rhs)
        self[p3, mode3] = result
    }

    private func jump(mode1: ParameterMode, mode2: ParameterMode, _ predicate: (Int) -> Bool) {
        let p1 = read()
        let p2 = read()
        let value = self[p1, mode1]
        
        if predicate(value) {
            instructionPointer = self[p2, mode2]
        }
    }
}

fileprivate enum ParameterMode : Int {
    case position = 0
    case immediate = 1
}

fileprivate enum Opcode : Int {
    case add = 1
    case multiply = 2
    case input = 3
    case output = 4
    case jumpIfTrue = 5
    case jumpIfFalse = 6
    case lessThan = 7
    case equals = 8
    case halt = 99
}
