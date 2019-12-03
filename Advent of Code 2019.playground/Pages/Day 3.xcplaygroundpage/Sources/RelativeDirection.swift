import Foundation

public enum RelativeDirection {
    case up(Int)
    case down(Int)
    case left(Int)
    case right(Int)
}

extension RelativeDirection {
    public init(_ text: String) {
        let distanceText = text.dropFirst()
        let distance = Int(distanceText)!
        
        switch text.first {
        case "U":
            self = .up(distance)
        case "D":
            self = .down(distance)
        case "L":
            self = .left(distance)
        case "R":
            self = .right(distance)
        default:
            fatalError()
        }
    }
}
