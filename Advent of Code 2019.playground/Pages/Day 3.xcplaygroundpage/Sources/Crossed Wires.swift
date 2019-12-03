import Foundation

extension Point {
    mutating func move(_ direction: RelativeDirection, current: inout Int, counts: inout [Point : Int]) -> Set<Point> {
        switch direction {
        case let .up(distance):
            return moveY(distance, current: &current, counts: &counts)
        case let .down(distance):
            return moveY(-distance, current: &current, counts: &counts)
        case let .left(distance):
            return moveX(-distance, current: &current, counts: &counts)
        case let .right(distance):
            return moveX(distance, current: &current, counts: &counts)
        }
    }
    
    mutating func moveX(_ amount: Int, current: inout Int, counts: inout [Point : Int]) -> Set<Point> {
        var result = Set<Point>()
        
        let by = amount > 0 ? 1 : -1
        
        for newX in stride(from: x + by, through: x + amount, by: by) {
            self = Point(newX, y)
            result.insert(self)
            current += 1
            if !counts.keys.contains(self) {
                counts[self] = current
            }
        }
        
        return result
    }
    
    mutating func moveY(_ amount: Int, current: inout Int, counts: inout [Point : Int]) -> Set<Point> {
        var result = Set<Point>()
        
        let by = amount > 0 ? 1 : -1
        
        for newY in stride(from: y + by, through: y + amount, by: by) {
            self = Point(x, newY)
            result.insert(self)
            current += 1
            if !counts.keys.contains(self) {
                counts[self] = current
            }
        }
        
        return result
    }
}

func run(_ wire: [RelativeDirection]) -> Set<Point> {
    var result = Set<Point>()
    var counts: [Point : Int] = [:]
    var current = Point.origin
    var amount = 0

    for direction in wire {
        let points = current.move(direction, current: &amount, counts: &counts)
        result.formUnion(points)
    }

    return result
}

func processWires(_ wire: [RelativeDirection]) -> [Point : Int] {
    var result = Set<Point>()
    var current = Point.origin
    var counts: [Point : Int] = [:]
    var amount = 0
    
    for direction in wire {
        let points = current.move(direction, current: &amount, counts: &counts)
        result.formUnion(points)
    }
    
    return counts
}

public func part1(_ wires: [[RelativeDirection]]) -> Int {
    let paths = wires.map(processWires).map { Set($0.keys) }
    let a = paths[0]
    let b = paths[1]
    let intersection = a.intersection(b)
    return intersection.filter { $0 != .origin }.map { abs($0.x) + abs($0.y) }.min()!
}

public func part2(_ wires: [[RelativeDirection]]) -> Int {
    let paths = wires.map(processWires)
    let a = paths[0]
    let b = paths[1]
    let aPoints = Set(a.keys)
    let bPoints = Set(b.keys)
    let intersection = aPoints.intersection(bPoints)
    let totals = intersection.filter { $0 != Point(0, 0) }.map { ($0, a[$0]! + b[$0]!) }
    let min = totals.map { $0.1 }.min()!
    return min
}
