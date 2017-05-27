/// HTTP response head.
public struct HTTPResponse : HTTPMessage {
    /// HTTP response status.
    public var status: HTTPStatus
    /// HTTP headers.
    public var headers: HTTPHeaders
    /// HTTP Version.
    public var version: HTTPVersion
    
    /// Creates an HTTP response.
    public init(
        status: HTTPStatus,
        headers: HTTPHeaders,
        version: HTTPVersion
    ) {
        self.status = status
        self.headers = headers
        self.version = version
    }
}

extension HTTPResponse : CustomStringConvertible {
    /// :nodoc:
    public var statusLineDescription: String {
        return version.description + " " + status.description + "\n"
    }
    
    /// :nodoc:
    public var description: String {
        return statusLineDescription + headers.description
    }
}

extension HTTPResponse : Hashable {
    public var hashValue: Int {
        return status.hashValue ^ version.hashValue ^ headers.hashValue
    }
}

extension HTTPResponse : Equatable {
    public static func == (lhs: HTTPResponse, rhs: HTTPResponse) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

/// :nodoc:
public func ~= (pattern: HTTPResponse, value: HTTPResponse) -> Bool {
    return pattern == value
}
