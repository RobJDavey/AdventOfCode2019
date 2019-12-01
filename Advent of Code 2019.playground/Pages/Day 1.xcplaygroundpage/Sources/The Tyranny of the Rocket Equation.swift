import Foundation

let masses = getInput()
    .components(separatedBy: .newlines)
    .compactMap(Int.init)

public func calculateFuel(_ mass: Int) -> Int {
    return (mass / 3) - 2
}

public func calculateCompoundFuel(_ mass: Int) -> Int {
    let fuel = max(0, calculateFuel(mass))

    return fuel > 0
        ? calculateCompoundFuel(fuel) + fuel
        : fuel
}

public func part1() -> Int {
    return masses
        .map(calculateFuel)
        .reduce(0, +)
}

public func part2() -> Int {
    return masses
        .map(calculateCompoundFuel)
        .reduce(0, +)
}
