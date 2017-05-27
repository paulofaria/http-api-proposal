/// HTTP request headers without the body.
public struct HTTPRequest {
    /// HTTP request method.
    public var method: HTTPMethod
    /// URI.
    public var uri: String
    /// HTTP version.
    public var version: HTTPVersion
    /// HTTP headers.
    public var headers: HTTPHeaders
    
    /// Creates an HTTP request.
    public init(
        method: HTTPMethod,
        uri: String,
        headers: HTTPHeaders,
        version: HTTPVersion
    ) {
        self.method = method
        self.uri = uri
        self.headers = headers
        self.version = version
    }
}

extension HTTPRequest : CustomStringConvertible {
    /// :nodoc:
    public var requestLineDescription: String {
        return method.description + " " + uri + " " + version.description + "\n"
    }
    
    /// :nodoc:
    public var description: String {
        return requestLineDescription + headers.description
    }
}

extension HTTPRequest : Hashable {
    public var hashValue: Int {
        return method.hashValue ^ uri.hashValue ^ version.hashValue ^ headers.hashValue
    }
}

extension HTTPRequest : Equatable {
    public static func == (lhs: HTTPRequest, rhs: HTTPRequest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

/// :nodoc:
public func ~= (pattern: HTTPRequest, value: HTTPRequest) -> Bool {
    return pattern == value
}
