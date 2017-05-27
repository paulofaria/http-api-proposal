/// HTTP status.
public struct HTTPStatus {
    /// HTTP status code.
    public let statusCode: Int
    /// HTTP reason phrase.
    public let reasonPhrase: String
    
    /// Creates an HTTP status code.
    public init(statusCode: Int, reasonPhrase: String) {
        self.statusCode = statusCode
        self.reasonPhrase = reasonPhrase
    }
}

extension HTTPStatus {
    /// Continue.
    public static var `continue` = HTTPStatus(
        statusCode: 100,
        reasonPhrase: "Continue"
    )
    
    /// Switching Protocols.
    public static var switchingProtocols = HTTPStatus(
        statusCode: 101,
        reasonPhrase: "Switching Protocols"
    )
    
    /// Processing.
    public static var processing = HTTPStatus(
        statusCode: 102,
        reasonPhrase: "Processing"
    )
    
    /// OK.
    public static var ok = HTTPStatus(
        statusCode: 200,
        reasonPhrase: "OK"
    )
    
    /// Created.
    public static var created = HTTPStatus(
        statusCode: 201,
        reasonPhrase: "Created"
    )
    
    /// Accepted.
    public static var accepted = HTTPStatus(
        statusCode: 202,
        reasonPhrase: "Accepted"
    )
    
    /// Non Authoritative Information.
    public static var nonAuthoritativeInformation = HTTPStatus(
        statusCode: 203,
        reasonPhrase: "Non Authoritative Information"
    )
    
    /// No Content.
    public static var noContent = HTTPStatus(
        statusCode: 204,
        reasonPhrase: "No Content"
    )
    
    /// Reset Content.
    public static var resetContent = HTTPStatus(
        statusCode: 205,
        reasonPhrase: "Reset Content"
    )
    
    /// Partial Content.
    public static var partialContent = HTTPStatus(
        statusCode: 206,
        reasonPhrase: "Partial Content"
    )
    
    /// Multiple choices.
    public static var multipleChoices = HTTPStatus(
        statusCode: 300,
        reasonPhrase: "Multiple Choices"
    )
    
    /// Moved permanently.
    public static var movedPermanently = HTTPStatus(
        statusCode: 301,
        reasonPhrase: "Moved Permanently"
    )
    
    /// Found.
    public static var found = HTTPStatus(
        statusCode: 302,
        reasonPhrase: "Found"
    )
    
    /// See Other
    public static var seeOther = HTTPStatus(
        statusCode: 303,
        reasonPhrase: "See Other"
    )
    
    /// Not Modified.
    public static var notModified = HTTPStatus(
        statusCode: 304,
        reasonPhrase: "Not Modified"
    )
    
    /// Use Proxy.
    public static var useProxy = HTTPStatus(
        statusCode: 305,
        reasonPhrase: "Use Proxy"
    )
    
    /// Switch Proxy.
    public static var switchProxy = HTTPStatus(
        statusCode: 306,
        reasonPhrase: "Switch Proxy"
    )
    
    /// Temporary Redirect.
    public static var temporaryRedirect = HTTPStatus(
        statusCode: 307,
        reasonPhrase: "Temporary Redirect"
    )
    
    /// Permanent Redirect.
    public static var permanentRedirect = HTTPStatus(
        statusCode: 308,
        reasonPhrase: "Permanent Redirect"
    )
    
    /// Bad Request.
    public static var badRequest = HTTPStatus(
        statusCode: 400,
        reasonPhrase: "Bad Request"
    )
    
    /// Unauthorized.
    public static var unauthorized = HTTPStatus(
        statusCode: 401,
        reasonPhrase: "Unauthorized"
    )
    
    /// Payment Required.
    public static var paymentRequired = HTTPStatus(
        statusCode: 402,
        reasonPhrase: "Payment Required"
    )
    
    /// Forbidden.
    public static var forbidden = HTTPStatus(
        statusCode: 403,
        reasonPhrase: "Forbidden"
    )
    
    /// Not Found.
    public static var notFound = HTTPStatus(
        statusCode: 404,
        reasonPhrase: "Not Found"
    )
    
    /// HTTPMethod Not Allowed.
    public static var methodNotAllowed = HTTPStatus(
        statusCode: 405,
        reasonPhrase: "HTTPMethod Not Allowed"
    )
    
    /// Not Acceptable.
    public static var notAcceptable = HTTPStatus(
        statusCode: 406,
        reasonPhrase: "Not Acceptable"
    )
    
    /// Proxy Authentication Required.
    public static var proxyAuthenticationRequired = HTTPStatus(
        statusCode: 407,
        reasonPhrase: "Proxy Authentication Required"
    )
    
    /// Request Timeout.
    public static var requestTimeout = HTTPStatus(
        statusCode: 408,
        reasonPhrase: "Request Timeout"
    )
    
    /// Conflict.
    public static var conflict = HTTPStatus(
        statusCode: 409,
        reasonPhrase: "Conflict"
    )
    
    /// Gone.
    public static var gone = HTTPStatus(
        statusCode: 410,
        reasonPhrase: "Gone"
    )
    
    /// Length Required.
    public static var lengthRequired = HTTPStatus(
        statusCode: 411,
        reasonPhrase: "Length Required"
    )
    
    /// Precodition Failed.
    public static var preconditionFailed = HTTPStatus(
        statusCode: 412,
        reasonPhrase: "Precondition Failed"
    )
    
    /// Request Entity Too Large.
    public static var requestEntityTooLarge = HTTPStatus(
        statusCode: 413,
        reasonPhrase: "Request Entity Too Large"
    )
    
    /// Request URI Too Long.
    public static var requestURITooLong = HTTPStatus(
        statusCode: 414,
        reasonPhrase: "Request URI Too Long"
    )
    
    //// Unsupported Media Type.
    public static var unsupportedMediaType = HTTPStatus(
        statusCode: 415,
        reasonPhrase: "Unsupported Media Type"
    )
    
    /// Request Range Not Satisfiable.
    public static var requestedRangeNotSatisfiable = HTTPStatus(
        statusCode: 416,
        reasonPhrase: "Request Range Not Satisfiable"
    )
    
    /// Expectation Failed.
    public static var expectationFailed = HTTPStatus(
        statusCode: 417,
        reasonPhrase: "Expectation Failed"
    )
    
    /// I'm A Teapot.
    public static var imATeapot = HTTPStatus(
        statusCode: 418,
        reasonPhrase: "I'm A Teapot"
    )
    
    /// Authentication Timeout.
    public static var authenticationTimeout = HTTPStatus(
        statusCode: 419,
        reasonPhrase: "Authentication Timeout"
    )
    
    /// Enhance Your Calm.
    public static var enhanceYourCalm = HTTPStatus(
        statusCode: 420,
        reasonPhrase: "Enhance Your Calm"
    )
    
    /// Unprocessable Entity.
    public static var unprocessableEntity = HTTPStatus(
        statusCode: 422,
        reasonPhrase: "Unprocessable Entity"
    )
    
    /// Locked.
    public static var locked = HTTPStatus(
        statusCode: 423,
        reasonPhrase: "Locked"
    )
    
    /// Failed Dependency.
    public static var failedDependency = HTTPStatus(
        statusCode: 424,
        reasonPhrase: "Failed Dependency"
    )
    
    /// Precondition Required.
    public static var preconditionRequired = HTTPStatus(
        statusCode: 428,
        reasonPhrase: "Precondition Required"
    )
    
    /// Too Many Requests.
    public static var tooManyRequests = HTTPStatus(
        statusCode: 429,
        reasonPhrase: "Too Many Requests"
    )
    
    /// Request Header Fields Too Large.
    public static var requestHeaderFieldsTooLarge = HTTPStatus(
        statusCode: 431,
        reasonPhrase: "Request Header Fields Too Large"
    )
    
    /// Internal Server Error.
    public static var internalServerError = HTTPStatus(
        statusCode: 500,
        reasonPhrase: "Internal Server Error"
    )
    
    /// Not Implemented.
    public static var notImplemented = HTTPStatus(
        statusCode: 501,
        reasonPhrase: "Not Implemented"
    )
    
    /// Bad Gateway.
    public static var badGateway = HTTPStatus(
        statusCode: 502,
        reasonPhrase: "Bad Gateway"
    )
    
    /// Service Unavailable.
    public static var serviceUnavailable = HTTPStatus(
        statusCode: 503,
        reasonPhrase: "Service Unavailable"
    )
    
    /// Gateway Timeout.
    public static var gatewayTimeout = HTTPStatus(
        statusCode: 504,
        reasonPhrase: "Gateway Timeout"
    )
    
    /// HTTP Version Not Supported.
    public static var httpVersionNotSupported = HTTPStatus(
        statusCode: 505,
        reasonPhrase: "HTTP Version Not Supported"
    )
    
    /// Variant Also Negotiates.
    public static var variantAlsoNegotiates = HTTPStatus(
        statusCode: 506,
        reasonPhrase: "Variant Also Negotiates"
    )
    
    /// Insufficient Storage.
    public static var insufficientStorage = HTTPStatus(
        statusCode: 507,
        reasonPhrase: "Insufficient Storage"
    )
    
    /// Loop Detected.
    public static var loopDetected = HTTPStatus(
        statusCode: 508,
        reasonPhrase: "Loop Detected"
    )
    
    /// Not Extended.
    public static var notExtended = HTTPStatus(
        statusCode: 510,
        reasonPhrase: "Not Extended"
    )
    
    /// Network Authentication Required.
    public static var networkAuthenticationRequired = HTTPStatus(
        statusCode: 511,
        reasonPhrase: "Network Authentication Required"
    )
}

extension HTTPStatus {
    /// True if the status is informational.
    public static var informationalRange: CountableRange<Int> {
        return 100 ..< 200
    }
    
    /// True if the status is succesfull.
    public static var successfulRange: CountableRange<Int> {
        return 200 ..< 300
    }
    
    /// True if the status is redirection.
    public static var redirectionRange: CountableRange<Int> {
        return 300 ..< 400
    }
    
    /// True if the status is an error.
    public static var errorRange: CountableRange<Int> {
        return 400 ..< 600
    }
    
    /// True if the status is a client error.
    public static var clientErrorRange: CountableRange<Int> {
        return 400 ..< 500
    }
    
    /// True if the status is a server error.
    public static var serverErrorRange: CountableRange<Int> {
        return 500 ..< 600
    }
    
    /// True if the status is informational.
    public var isInformational: Bool {
        return HTTPStatus.informationalRange.contains(statusCode)
    }
    
    /// True if the status is succesfull.
    public var isSuccessful: Bool {
        return HTTPStatus.successfulRange.contains(statusCode)
    }
    
    /// True if the status is redirection.
    public var isRedirection: Bool {
        return HTTPStatus.redirectionRange.contains(statusCode)
    }
    
    /// True if the status is an error.
    public var isError: Bool {
        return HTTPStatus.errorRange.contains(statusCode)
    }
    
    /// True if the status is a client error.
    public var isClientError: Bool {
        return HTTPStatus.clientErrorRange.contains(statusCode)
    }
    
    /// True if the status is a server error.
    public var isServerError: Bool {
        return HTTPStatus.serverErrorRange.contains(statusCode)
    }
}

extension HTTPStatus : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return statusCode
    }
}

extension HTTPStatus : Equatable {
    /// :nodoc:
    public static func == (lhs: HTTPStatus, rhs: HTTPStatus) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension HTTPStatus : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return statusCode.description + " " + reasonPhrase
    }
}

/// :nodoc:
public func ~= (pattern: HTTPStatus, value: HTTPStatus) -> Bool {
    return pattern.statusCode == value.statusCode
}

/// :nodoc:
public func ~= (pattern: CountableRange<Int>, value: HTTPStatus) -> Bool {
    return pattern.contains(value.statusCode)
}
