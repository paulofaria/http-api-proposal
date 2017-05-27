/// HTTP method.
public struct HTTPMethod {
    /// HTTP method
    public let method: String
    
    /// Creates an HTTP method.
    public init(_ method: String) {
        self.method = method.uppercased()
    }
}

/// HTTP method.
extension HTTPMethod {
    /// GET method.
    public static var get = HTTPMethod("GET")
    /// HEAD method.
    public static var head = HTTPMethod("HEAD")
    /// POST method.
    public static var post = HTTPMethod("POST")
    /// PUT method.
    public static var put = HTTPMethod("PUT")
    /// PATCH method.
    public static var patch = HTTPMethod("PATCH")
    /// DELETE method.
    public static var delete = HTTPMethod("DELETE")
    /// OPTIONS method.
    public static var options = HTTPMethod("OPTIONS")
    /// TRACE method.
    public static var trace = HTTPMethod("TRACE")
    /// CONNECT method.
    public static var connect = HTTPMethod("CONNECT")
}

extension HTTPMethod : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return method
    }
}

extension HTTPMethod : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return method.hashValue
    }
}

extension HTTPMethod : Equatable {
    /// :nodoc:
    public static func == (lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
        return lhs.description == rhs.description
    }
}

/// :nodoc:
public func ~= (pattern: HTTPMethod, value: HTTPMethod) -> Bool {
    return pattern == value
}
