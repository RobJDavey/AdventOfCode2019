import Foundation

public struct Point : Hashable, Equatable {
    public let x: Int
    public let y: Int
}

extension Point : CustomStringConvertible {
    public static let origin = Point(0, 0)
    
    public init(_ x: Int, _ y: Int) {
        self.init(x: x, y: y)
    }
    
    public var description: String {
        "{\(x),\(y)}"
    }
}
