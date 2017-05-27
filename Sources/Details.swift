extension Version : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return major ^ minor
    }
    
    /// :nodoc:
    public static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension Version : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return "HTTP/" + major.description + "." + minor.description
    }
}

extension Headers : ExpressibleByDictionaryLiteral {
    /// :nodoc:
    public init(dictionaryLiteral headers: (Field, String)...) {
        self.headers = headers
    }
}

extension Headers : Sequence {
    /// :nodoc:
    public func makeIterator() -> IndexingIterator<Array<(Field, String)>> {
        return headers.makeIterator()
    }
    
    /// :nodoc:
    public var count: Int {
        return headers.count
    }
    
    /// :nodoc:
    public var isEmpty: Bool {
        return headers.isEmpty
    }
    
    /// :nodoc:
    public subscript(field: Field) -> [String] {
        get {
            return headers.filter({ $0.0 == field }).map({ $0.1 })
        }
        
        set(headers) {
            self.headers = self.headers.filter({ $0.0 == field })
            
            for header in headers {
                append(field: field, header: header)
            }
        }
    }
    
    /// :nodoc:
    public subscript(field: String) -> [String] {
        get {
            return self[Field(field)]
        }
        
        set(header) {
            self[Field(field)] = header
        }
    }
    
    /// Appends a field to the headers.
    public mutating func append(field: Field, header: String) {
        headers.append(field, header)
    }
}

extension Headers : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        var string = ""
        
        for (header, value) in headers {
            string += "\(header): \(value)\n"
        }
        
        return string
    }
}

extension Headers : Equatable {
    /// :nodoc:
    public static func == (lhs: Headers, rhs: Headers) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        
        for (lhsHeader, rhsHeader) in zip(lhs, rhs) {
            if lhsHeader.0 != rhsHeader.0 || lhsHeader.1 != rhsHeader.1 {
                return false
            }
        }
        
        return true
    }
}

extension Headers.Field : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return original.hashValue
    }
    
    /// :nodoc:
    public static func == (lhs: Headers.Field, rhs: Headers.Field) -> Bool {
        if lhs.original == rhs.original {
            return true
        }
        
        return lhs.original.caseInsensitiveCompare(rhs.original)
    }
}

extension Headers.Field : ExpressibleByStringLiteral {
    /// :nodoc:
    public init(stringLiteral string: String) {
        self.init(string)
    }
    
    /// :nodoc:
    public init(extendedGraphemeClusterLiteral string: String){
        self.init(string)
    }
    
    /// :nodoc:
    public init(unicodeScalarLiteral string: String){
        self.init(string)
    }
}

extension Headers.Field : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return original
    }
}

extension String {
    fileprivate func caseInsensitiveCompare(_ other: String) -> Bool {
        fatalError()
    }
}

/// HTTP method.
extension Request.Method {
    /// GET method.
    public static var get = Request.Method("GET")
    /// HEAD method.
    public static var head = Request.Method("HEAD")
    /// POST method.
    public static var post = Request.Method("POST")
    /// PUT method.
    public static var put = Request.Method("PUT")
    /// PATCH method.
    public static var patch = Request.Method("PATCH")
    /// DELETE method.
    public static var delete = Request.Method("DELETE")
    /// OPTIONS method.
    public static var options = Request.Method("OPTIONS")
    /// TRACE method.
    public static var trace = Request.Method("TRACE")
    /// CONNECT method.
    public static var connect = Request.Method("CONNECT")
}

extension Request.Method : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return method.hashValue
    }
    
    /// :nodoc:
    public static func == (lhs: Request.Method, rhs: Request.Method) -> Bool {
        return lhs.description == rhs.description
    }
}

extension Request.Method : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return method
    }
}

extension Response.Status {
    /// Continue.
    public static var `continue` = Response.Status(statusCode: 100, reasonPhrase: "Continue")
    /// Switching Protocols.
    public static var switchingProtocols = Response.Status(statusCode: 101, reasonPhrase: "Switching Protocols")
    /// Processing.
    public static var processing = Response.Status(statusCode: 102, reasonPhrase: "Processing")
    
    /// OK.
    public static var ok = Response.Status(statusCode: 200, reasonPhrase: "OK")
    /// Created.
    public static var created = Response.Status(statusCode: 201, reasonPhrase: "Created")
    /// Accepted.
    public static var accepted = Response.Status(statusCode: 202, reasonPhrase: "Accepted")
    /// Non Authoritative Information.
    public static var nonAuthoritativeInformation = Response.Status(statusCode: 203, reasonPhrase: "Non Authoritative Information")
    /// No Content.
    public static var noContent = Response.Status(statusCode: 204, reasonPhrase: "No Content")
    /// Reset Content.
    public static var resetContent = Response.Status(statusCode: 205, reasonPhrase: "Reset Content")
    /// Partial Content.
    public static var partialContent = Response.Status(statusCode: 206, reasonPhrase: "Partial Content")
    
    /// Multiple choices.
    public static var multipleChoices = Response.Status(statusCode: 300, reasonPhrase: "Multiple Choices")
    /// Moved permanently.
    public static var movedPermanently = Response.Status(statusCode: 301, reasonPhrase: "Moved Permanently")
    /// Found.
    public static var found = Response.Status(statusCode: 302, reasonPhrase: "Found")
    /// See Other
    public static var seeOther = Response.Status(statusCode: 303, reasonPhrase: "See Other")
    /// Not Modified.
    public static var notModified = Response.Status(statusCode: 304, reasonPhrase: "Not Modified")
    /// Use Proxy.
    public static var useProxy = Response.Status(statusCode: 305, reasonPhrase: "Use Proxy")
    /// Switch Proxy.
    public static var switchProxy = Response.Status(statusCode: 306, reasonPhrase: "Switch Proxy")
    /// Temporary Redirect.
    public static var temporaryRedirect = Response.Status(statusCode: 307, reasonPhrase: "Temporary Redirect")
    /// Permanent Redirect.
    public static var permanentRedirect = Response.Status(statusCode: 308, reasonPhrase: "Permanent Redirect")
    
    /// Bad Request.
    public static var badRequest = Response.Status(statusCode: 400, reasonPhrase: "Bad Request")
    /// Unauthorized.
    public static var unauthorized = Response.Status(statusCode: 401, reasonPhrase: "Unauthorized")
    /// Payment Required.
    public static var paymentRequired = Response.Status(statusCode: 402, reasonPhrase: "Payment Required")
    /// Forbidden.
    public static var forbidden = Response.Status(statusCode: 403, reasonPhrase: "Forbidden")
    /// Not Found.
    public static var notFound = Response.Status(statusCode: 404, reasonPhrase: "Not Found")
    /// Method Not Allowed.
    public static var methodNotAllowed = Response.Status(statusCode: 405, reasonPhrase: "Method Not Allowed")
    /// Not Acceptable.
    public static var notAcceptable = Response.Status(statusCode: 406, reasonPhrase: "Not Acceptable")
    /// Proxy Authentication Required.
    public static var proxyAuthenticationRequired = Response.Status(statusCode: 407, reasonPhrase: "Proxy Authentication Required")
    /// Request Timeout.
    public static var requestTimeout = Response.Status(statusCode: 408, reasonPhrase: "Request Timeout")
    /// Conflict.
    public static var conflict = Response.Status(statusCode: 409, reasonPhrase: "Conflict")
    /// Gone.
    public static var gone = Response.Status(statusCode: 410, reasonPhrase: "Gone")
    /// Length Required.
    public static var lengthRequired = Response.Status(statusCode: 411, reasonPhrase: "Length Required")
    /// Precodition Failed.
    public static var preconditionFailed = Response.Status(statusCode: 412, reasonPhrase: "Precondition Failed")
    /// Request Entity Too Large.
    public static var requestEntityTooLarge = Response.Status(statusCode: 413, reasonPhrase: "Request Entity Too Large")
    /// Request URI Too Long.
    public static var requestURITooLong = Response.Status(statusCode: 414, reasonPhrase: "Request URI Too Long")
    //// Unsupported Media Type.
    public static var unsupportedMediaType = Response.Status(statusCode: 415, reasonPhrase: "Unsupported Media Type")
    /// Request Range Not Satisfiable.
    public static var requestedRangeNotSatisfiable = Response.Status(statusCode: 416, reasonPhrase: "Request Range Not Satisfiable")
    /// Expectation Failed.
    public static var expectationFailed = Response.Status(statusCode: 417, reasonPhrase: "Expectation Failed")
    /// I'm A Teapot.
    public static var imATeapot = Response.Status(statusCode: 418, reasonPhrase: "I'm A Teapot")
    /// Authentication Timeout.
    public static var authenticationTimeout = Response.Status(statusCode: 419, reasonPhrase: "Authentication Timeout")
    /// Enhance Your Calm.
    public static var enhanceYourCalm = Response.Status(statusCode: 420, reasonPhrase: "Enhance Your Calm")
    /// Unprocessable Entity.
    public static var unprocessableEntity = Response.Status(statusCode: 422, reasonPhrase: "Unprocessable Entity")
    /// Locked.
    public static var locked = Response.Status(statusCode: 423, reasonPhrase: "Locked")
    /// Failed Dependency.
    public static var failedDependency = Response.Status(statusCode: 424, reasonPhrase: "Failed Dependency")
    /// Precondition Required.
    public static var preconditionRequired = Response.Status(statusCode: 428, reasonPhrase: "Precondition Required")
    /// Too Many Requests.
    public static var tooManyRequests = Response.Status(statusCode: 429, reasonPhrase: "Too Many Requests")
    /// Request Header Fields Too Large.
    public static var requestHeaderFieldsTooLarge = Response.Status(statusCode: 431, reasonPhrase: "Request Header Fields Too Large")
    
    /// Internal Server Error.
    public static var internalServerError = Response.Status(statusCode: 500, reasonPhrase: "Internal Server Error")
    /// Not Implemented.
    public static var notImplemented = Response.Status(statusCode: 501, reasonPhrase: "Not Implemented")
    /// Bad Gateway.
    public static var badGateway = Response.Status(statusCode: 502, reasonPhrase: "Bad Gateway")
    /// Service Unavailable.
    public static var serviceUnavailable = Response.Status(statusCode: 503, reasonPhrase: "Service Unavailable")
    /// Gateway Timeout.
    public static var gatewayTimeout = Response.Status(statusCode: 504, reasonPhrase: "Gateway Timeout")
    /// HTTP Version Not Supported.
    public static var httpVersionNotSupported = Response.Status(statusCode: 505, reasonPhrase: "HTTP Version Not Supported")
    /// Variant Also Negotiates.
    public static var variantAlsoNegotiates = Response.Status(statusCode: 506, reasonPhrase: "Variant Also Negotiates")
    /// Insufficient Storage.
    public static var insufficientStorage = Response.Status(statusCode: 507, reasonPhrase: "Insufficient Storage")
    /// Loop Detected.
    public static var loopDetected = Response.Status(statusCode: 508, reasonPhrase: "Loop Detected")
    /// Not Extended.
    public static var notExtended = Response.Status(statusCode: 510, reasonPhrase: "Not Extended")
    /// Network Authentication Required.
    public static var networkAuthenticationRequired = Response.Status(statusCode: 511, reasonPhrase: "Network Authentication Required")
}

extension Response.Status {
    /// True if the status is informational.
    public var isInformational: Bool {
        return (100 ..< 200).contains(statusCode)
    }
    
    /// True if the status is succesfull.
    public var isSuccessful: Bool {
        return (200 ..< 300).contains(statusCode)
    }
    
    /// True if the status is redirection.
    public var isRedirection: Bool {
        return (300 ..< 400).contains(statusCode)
    }
    
    /// True if the status is an error.
    public var isError: Bool {
        return (400 ..< 600).contains(statusCode)
    }
    
    /// True if the status is a client error.
    public var isClientError: Bool {
        return (400 ..< 500).contains(statusCode)
    }
    
    /// True if the status is a server error.
    public var isServerError: Bool {
        return (500 ..< 600).contains(statusCode)
    }
}

extension Response.Status : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return statusCode
    }
    
    /// :nodoc:
    public static func == (lhs: Response.Status, rhs: Response.Status) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension Response.Status : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return statusCode.description + " " + reasonPhrase
    }
}

extension Double {
    /// `Duration` represented in milliseconds.
    public var millisecond: Duration {
        return Duration(self)
    }
    
    /// `Duration` represented in milliseconds.
    public var milliseconds: Duration {
        return millisecond
    }
    
    /// `Duration` represented in seconds.
    public var second: Duration {
        return Duration(self * 1000)
    }
    
    /// `Duration` represented in seconds.
    public var seconds: Duration {
        return second
    }
    
    /// `Duration` represented in minutes.
    public var minute: Duration {
        return Duration(self * 1000 * 60)
    }
    
    /// `Duration` represented in minutes.
    public var minutes: Duration {
        return minute
    }
    
    /// `Duration` represented in hours.
    public var hour: Duration {
        return Duration(self * 1000 * 60 * 60)
    }
    
    /// `Duration` represented in hours.
    public var hours: Duration {
        return hour
    }
}

extension Int {
    /// `Duration` represented in milliseconds.
    public var millisecond: Duration {
        return Duration(Double(self))
    }
    
    /// `Duration` represented in milliseconds.
    public var milliseconds: Duration {
        return millisecond
    }
    
    /// `Duration` represented in seconds.
    public var second: Duration {
        return Duration(Double(self * 1000))
    }
    
    /// `Duration` represented in seconds.
    public var seconds: Duration {
        return second
    }
    
    /// `Duration` represented in minutes.
    public var minute: Duration {
        return Duration(Double(self * 1000 * 60))
    }
    
    /// `Duration` represented in minutes.
    public var minutes: Duration {
        return minute
    }
    
    /// `Duration` represented in hours.
    public var hour: Duration {
        return Duration(Double(self * 1000 * 60 * 60))
    }
    
    /// `Duration` represented in hours.
    public var hours: Duration {
        return hour
    }
}

extension Duration : Equatable {
    /// :nodoc:
    public static func == (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.value == rhs.value
    }
}

extension AnyError : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return String(describing: error)
    }
}
