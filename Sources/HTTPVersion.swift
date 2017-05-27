/// Representation of an HTTP version.
public struct HTTPVersion {
    /// Major version component.
    public var major: Int
    /// Minor version component.
    public var minor: Int
    
    /// Creates an HTTP version.
    public init(major: Int, minor: Int) {
        self.major = major
        self.minor = minor
    }
}

extension HTTPVersion : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return major ^ minor
    }
    
    /// :nodoc:
    public static func == (lhs: HTTPVersion, rhs: HTTPVersion) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension HTTPVersion : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return "HTTP/" + major.description + "." + minor.description
    }
}

/// :nodoc:
public func ~= (pattern: HTTPVersion, value: HTTPVersion) -> Bool {
    return pattern == value
}
