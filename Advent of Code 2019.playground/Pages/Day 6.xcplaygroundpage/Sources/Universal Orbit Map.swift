import Foundation

public typealias Map = [String : Set<String>]

func getOrbits(for object: String, in map: Map, _ current: Int = 0) -> Int {
    let items = map[object, default: []]
    var result = current
    
    for item in items {
        result += getOrbits(for: item, in: map, current + 1)
    }
    
    return result
}

public func part1(_ map: Map) -> Int {
    return getOrbits(for: "COM", in: map)
}

public func part2(_ map: Map) -> Int {
    let startOrbit = map.first { $0.value.contains("YOU") }!
    let endOrbit = map.first { $0.value.contains("SAN") }!
    
    var queue: [(name: String, distance: Int)] = [(startOrbit.key, 0)]
    var history: Set<String> = [startOrbit.key]
    
    while !queue.isEmpty {
        let current = queue.removeFirst()
        
        guard current.name != endOrbit.key else {
            return current.distance
        }
        
        let item = current.name
        let children = map[item, default: []]
        let parents = map.filter { $0.value.contains(item) }.map { $0.key }
        let all = Set(parents + children)
        
        for next in all {
            let (inserted, _) = history.insert(next)
            if inserted {
                queue.append((next, current.distance + 1))
            }
        }
    }
    
    fatalError()
}

public func parse(_ text: String) -> [String : Set<String>] {
    var map = [String : Set<String>]()
    let lines = text.components(separatedBy: .newlines).map { $0.components(separatedBy: ")") }
    
    for line in lines {
        map[line[0], default: []].insert(line[1])
    }
    
    return map
}
