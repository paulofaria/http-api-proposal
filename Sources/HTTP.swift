// MARK: Version

/// Representation of an HTTP version.
public struct Version {
    /// Major version component.
    public var major: Int
    /// Minor version component.
    public var minor: Int
    
    /// :nodoc:
    public init(major: Int, minor: Int) {
        self.major = major
        self.minor = minor
    }
}

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

// MARK: Headers

/// Representation of the HTTP headers.
/// Headers are subscriptable using case-insensitive comparison.
public struct Headers {
    /// HTTP headers.
    public var headers: [(Field, String)]
    
    /// :nodoc:
    public init(_ headers: [(Field, String)]) {
        self.headers = headers
    }
    
    /// This type is used as the key for HTTP headers.
    /// Its implementation of `Equatable` performs a case-insensitive comparison.
    public struct Field {
        /// Original header field
        public let original: String
        
        /// :nodoc:
        public init(_ original: String) {
            self.original = original
        }
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

// MARK: Message

/// Generic storage for user data.
/// This is extremely useful because it allows frameworks to add more
/// functionality to HTTP messages.
public typealias Storage = [String: Any]

/// Representation of an HTTP message.
/// This protocol is useful for adding extensions which are common to both
/// HTTP requests and responses.
public protocol Message {
    /// HTTP version.
    var version: Version { get set }
    /// HTTP headers.
    var headers: Headers { get set }
    /// User data storage.
    var storage: Storage { get set }
}

// MARK: URI

/// URI implementation of RFC 3986.
public struct URI {
    /// Scheme component.
    public var scheme: String?
    /// User info component.
    public var userInfo: UserInfo?
    /// Host component.
    public var host: String?
    /// Port component.
    public var port: Int?
    /// Path component.
    public var path: String?
    /// Query component.
    public var query:  String?
    /// Fragment component.
    public var fragment: String?
    
    /// User info.
    public struct UserInfo {
        /// Username.
        public var username: String
        /// Password.
        public var password: String?
        
        internal init(username: String, password: String?) {
            self.username = username
            self.password = password
        }
    }
}

// MARK: Request

/// HTTP request headers without the body.
public struct Request : Message {
    /// HTTP request method.
    public var method: Method
    /// URI.
    public var uri: URI
    /// HTTP version.
    public var version: Version
    /// HTTP headers.
    public var headers: Headers
    
    /// User data storage.
    public var storage: Storage = [:]
    
    /// Creates an HTTP request.
    public init(
        method: Method,
        uri: URI,
        headers: Headers,
        version: Version
        ) {
        self.method = method
        self.uri = uri
        self.headers = headers
        self.version = version
    }
    
    /// HTTP method.
    public enum Method {
        /// GET method.
        case get
        /// HEAD method.
        case head
        /// POST method.
        case post
        /// PUT method.
        case put
        /// PATCH method.
        case patch
        /// DELETE method.
        case delete
        /// OPTIONS method.
        case options
        /// TRACE method.
        case trace
        /// CONNECT method.
        case connect
        /// Other method.
        case other(String)
    }
}

extension Request.Method {
    /// :nodoc:
    init(_ method: String) {
        let method = method.uppercased()
        switch method {
        case "DELETE":  self = .delete
        case "GET":     self = .get
        case "HEAD":    self = .head
        case "POST":    self = .post
        case "PUT":     self = .put
        case "CONNECT": self = .connect
        case "OPTIONS": self = .options
        case "TRACE":   self = .trace
        case "PATCH":   self = .patch
        default:        self = .other(method)
        }
    }
}

extension Request.Method : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        switch self {
        case .delete:            return 0
        case .get:               return 1
        case .head:              return 2
        case .post:              return 3
        case .put:               return 4
        case .connect:           return 5
        case .options:           return 6
        case .trace:             return 7
        case .patch:             return 8
        case .other(let method): return 9 + method.hashValue
        }
    }
    
    /// :nodoc:
    public static func == (lhs: Request.Method, rhs: Request.Method) -> Bool {
        return lhs.description == rhs.description
    }
}

extension Request.Method : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        switch self {
        case .delete:            return "DELETE"
        case .get:               return "GET"
        case .head:              return "HEAD"
        case .post:              return "POST"
        case .put:               return "PUT"
        case .connect:           return "CONNECT"
        case .options:           return "OPTIONS"
        case .trace:             return "TRACE"
        case .patch:             return "PATCH"
        case .other(let method): return method.uppercased()
        }
    }
}

// MARK: Response

/// HTTP response headers without the body.
public struct Response : Message {
    /// HTTP response status.
    public var status: Status
    /// HTTP headers.
    public var headers: Headers
    /// HTTP Version.
    public var version: Version
    /// User data storage.
    public var storage: Storage = [:]
    
    /// Creates an HTTP response.
    public init(
        status: Status,
        headers: Headers,
        version: Version
    ) {
        self.status = status
        self.headers = headers
        self.version = version
    }
    
    /// HTTP status.
    public enum Status {
        /// Continue.
        case `continue`
        /// Switching Protocols.
        case switchingProtocols
        /// Processing.
        case processing
        
        /// OK.
        case ok
        /// Created.
        case created
        /// Accepted.
        case accepted
        /// Non Authoritative Information.
        case nonAuthoritativeInformation
        /// No Content.
        case noContent
        /// Reset Content.
        case resetContent
        /// Partial Content.
        case partialContent
        
        /// Multiple choices.
        case multipleChoices
        /// Moved permanently.
        case movedPermanently
        /// Found.
        case found
        /// See Other
        case seeOther
        /// Not Modified.
        case notModified
        /// Use Proxy.
        case useProxy
        /// Switch Proxy.
        case switchProxy
        /// Temporary Redirect.
        case temporaryRedirect
        /// Permanent Redirect.
        case permanentRedirect
        
        /// Bad Request.
        case badRequest
        /// Unauthorized.
        case unauthorized
        /// Payment Required.
        case paymentRequired
        /// Forbidden.
        case forbidden
        /// Not Found.
        case notFound
        /// Method Not Allowed.
        case methodNotAllowed
        /// Not Acceptable.
        case notAcceptable
        /// Proxy Authentication Required.
        case proxyAuthenticationRequired
        /// Request Timeout.
        case requestTimeout
        /// Conflict.
        case conflict
        /// Gone.
        case gone
        /// Length Required.
        case lengthRequired
        /// Precodition Failed.
        case preconditionFailed
        /// Request Entity Too Large.
        case requestEntityTooLarge
        /// Request URI Too Long.
        case requestURITooLong
        //// Unsupported Media Type.
        case unsupportedMediaType
        /// Request Range Not Satisfiable.
        case requestedRangeNotSatisfiable
        /// Expectation Failed.
        case expectationFailed
        /// I'm A Teapot.
        case imATeapot
        /// Authentication Timeout.
        case authenticationTimeout
        /// Enhance Your Calm.
        case enhanceYourCalm
        /// Unprocessable Entity.
        case unprocessableEntity
        /// Locked.
        case locked
        /// Failed Dependency.
        case failedDependency
        /// Precondition Required.
        case preconditionRequired
        /// Too Many Requests.
        case tooManyRequests
        /// Request Header Fields Too Large.
        case requestHeaderFieldsTooLarge
        
        /// Internal Server Error.
        case internalServerError
        /// Not Implemented.
        case notImplemented
        /// Bad Gateway.
        case badGateway
        /// Service Unavailable.
        case serviceUnavailable
        /// Gateway Timeout.
        case gatewayTimeout
        /// HTTP Version Not Supported.
        case httpVersionNotSupported
        /// Variant Also Negotiates.
        case variantAlsoNegotiates
        /// Insufficient Storage.
        case insufficientStorage
        /// Loop Detected.
        case loopDetected
        /// Not Extended.
        case notExtended
        /// Network Authentication Required.
        case networkAuthenticationRequired
        /// Other status code.
        case other(statusCode: Int, reasonPhrase: String)
    }
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

extension Response.Status {
    /// :nodoc:
    public init(statusCode: Int, reasonPhrase: String? = nil) {
        switch statusCode {
        case Response.Status.continue.statusCode:                      self = .continue
        case Response.Status.switchingProtocols.statusCode:            self = .switchingProtocols
        case Response.Status.processing.statusCode:                    self = .processing
            
        case Response.Status.ok.statusCode:                            self = .ok
        case Response.Status.created.statusCode:                       self = .created
        case Response.Status.accepted.statusCode:                      self = .accepted
        case Response.Status.nonAuthoritativeInformation.statusCode:   self = .nonAuthoritativeInformation
        case Response.Status.noContent.statusCode:                     self = .noContent
        case Response.Status.resetContent.statusCode:                  self = .resetContent
        case Response.Status.partialContent.statusCode:                self = .partialContent
            
        case Response.Status.multipleChoices.statusCode:               self = .multipleChoices
        case Response.Status.movedPermanently.statusCode:              self = .movedPermanently
        case Response.Status.found.statusCode:                         self = .found
        case Response.Status.seeOther.statusCode:                      self = .seeOther
        case Response.Status.notModified.statusCode:                   self = .notModified
        case Response.Status.useProxy.statusCode:                      self = .useProxy
        case Response.Status.switchProxy.statusCode:                   self = .switchProxy
        case Response.Status.temporaryRedirect.statusCode:             self = .temporaryRedirect
        case Response.Status.permanentRedirect.statusCode:             self = .permanentRedirect
            
        case Response.Status.badRequest.statusCode:                    self = .badRequest
        case Response.Status.unauthorized.statusCode:                  self = .unauthorized
        case Response.Status.paymentRequired.statusCode:               self = .paymentRequired
        case Response.Status.forbidden.statusCode:                     self = .forbidden
        case Response.Status.notFound.statusCode:                      self = .notFound
        case Response.Status.methodNotAllowed.statusCode:              self = .methodNotAllowed
        case Response.Status.notAcceptable.statusCode:                 self = .notAcceptable
        case Response.Status.proxyAuthenticationRequired.statusCode:   self = .proxyAuthenticationRequired
        case Response.Status.requestTimeout.statusCode:                self = .requestTimeout
        case Response.Status.conflict.statusCode:                      self = .conflict
        case Response.Status.gone.statusCode:                          self = .gone
        case Response.Status.lengthRequired.statusCode:                self = .lengthRequired
        case Response.Status.preconditionFailed.statusCode:            self = .preconditionFailed
        case Response.Status.requestEntityTooLarge.statusCode:         self = .requestEntityTooLarge
        case Response.Status.requestURITooLong.statusCode:             self = .requestURITooLong
        case Response.Status.unsupportedMediaType.statusCode:          self = .unsupportedMediaType
        case Response.Status.requestedRangeNotSatisfiable.statusCode:  self = .requestedRangeNotSatisfiable
        case Response.Status.expectationFailed.statusCode:             self = .expectationFailed
        case Response.Status.imATeapot.statusCode:                     self = .imATeapot
        case Response.Status.authenticationTimeout.statusCode:         self = .authenticationTimeout
        case Response.Status.enhanceYourCalm.statusCode:               self = .enhanceYourCalm
        case Response.Status.unprocessableEntity.statusCode:           self = .unprocessableEntity
        case Response.Status.locked.statusCode:                        self = .locked
        case Response.Status.failedDependency.statusCode:              self = .failedDependency
        case Response.Status.preconditionRequired.statusCode:          self = .preconditionRequired
        case Response.Status.tooManyRequests.statusCode:               self = .tooManyRequests
        case Response.Status.requestHeaderFieldsTooLarge.statusCode:   self = .requestHeaderFieldsTooLarge
            
        case Response.Status.internalServerError.statusCode:           self = .internalServerError
        case Response.Status.notImplemented.statusCode:                self = .notImplemented
        case Response.Status.badGateway.statusCode:                    self = .badGateway
        case Response.Status.serviceUnavailable.statusCode:            self = .serviceUnavailable
        case Response.Status.gatewayTimeout.statusCode:                self = .gatewayTimeout
        case Response.Status.httpVersionNotSupported.statusCode:       self = .httpVersionNotSupported
        case Response.Status.variantAlsoNegotiates.statusCode:         self = .variantAlsoNegotiates
        case Response.Status.insufficientStorage.statusCode:           self = .insufficientStorage
        case Response.Status.loopDetected.statusCode:                  self = .loopDetected
        case Response.Status.notExtended.statusCode:                   self = .notExtended
        case Response.Status.networkAuthenticationRequired.statusCode: self = .networkAuthenticationRequired
            
        default: self = .other(statusCode: statusCode, reasonPhrase: reasonPhrase ?? "CUSTOM")
        }
    }
}

extension Response.Status {
    /// Status code.
    public var statusCode: Int {
        switch self {
        case .continue:                      return 100
        case .switchingProtocols:            return 101
        case .processing:                    return 102
            
        case .ok:                            return 200
        case .created:                       return 201
        case .accepted:                      return 202
        case .nonAuthoritativeInformation:   return 203
        case .noContent:                     return 204
        case .resetContent:                  return 205
        case .partialContent:                return 206
            
        case .multipleChoices:               return 300
        case .movedPermanently:              return 301
        case .found:                         return 302
        case .seeOther:                      return 303
        case .notModified:                   return 304
        case .useProxy:                      return 305
        case .switchProxy:                   return 306
        case .temporaryRedirect:             return 307
        case .permanentRedirect:             return 308
            
        case .badRequest:                    return 400
        case .unauthorized:                  return 401
        case .paymentRequired:               return 402
        case .forbidden:                     return 403
        case .notFound:                      return 404
        case .methodNotAllowed:              return 405
        case .notAcceptable:                 return 406
        case .proxyAuthenticationRequired:   return 407
        case .requestTimeout:                return 408
        case .conflict:                      return 409
        case .gone:                          return 410
        case .lengthRequired:                return 411
        case .preconditionFailed:            return 412
        case .requestEntityTooLarge:         return 413
        case .requestURITooLong:             return 414
        case .unsupportedMediaType:          return 415
        case .requestedRangeNotSatisfiable:  return 416
        case .expectationFailed:             return 417
        case .imATeapot:                     return 418
        case .authenticationTimeout:         return 419
        case .enhanceYourCalm:               return 420
        case .unprocessableEntity:           return 422
        case .locked:                        return 423
        case .failedDependency:              return 424
        case .preconditionRequired:          return 428
        case .tooManyRequests:               return 429
        case .requestHeaderFieldsTooLarge:   return 431
            
        case .internalServerError:           return 500
        case .notImplemented:                return 501
        case .badGateway:                    return 502
        case .serviceUnavailable:            return 503
        case .gatewayTimeout:                return 504
        case .httpVersionNotSupported:       return 505
        case .variantAlsoNegotiates:         return 506
        case .insufficientStorage:           return 507
        case .loopDetected:                  return 508
        case .notExtended:                   return 510
        case .networkAuthenticationRequired: return 511
            
        case .other(let statusCode, _):        return statusCode
        }
    }
    
    /// Textual representation of the status code.
    public var statusCodeString: String {
        switch self {
        case .continue:                      return "100"
        case .switchingProtocols:            return "101"
        case .processing:                    return "102"
            
        case .ok:                            return "200"
        case .created:                       return "201"
        case .accepted:                      return "202"
        case .nonAuthoritativeInformation:   return "203"
        case .noContent:                     return "204"
        case .resetContent:                  return "205"
        case .partialContent:                return "206"
            
        case .multipleChoices:               return "300"
        case .movedPermanently:              return "301"
        case .found:                         return "302"
        case .seeOther:                      return "303"
        case .notModified:                   return "304"
        case .useProxy:                      return "305"
        case .switchProxy:                   return "306"
        case .temporaryRedirect:             return "307"
        case .permanentRedirect:             return "308"
            
        case .badRequest:                    return "400"
        case .unauthorized:                  return "401"
        case .paymentRequired:               return "402"
        case .forbidden:                     return "403"
        case .notFound:                      return "404"
        case .methodNotAllowed:              return "405"
        case .notAcceptable:                 return "406"
        case .proxyAuthenticationRequired:   return "407"
        case .requestTimeout:                return "408"
        case .conflict:                      return "409"
        case .gone:                          return "410"
        case .lengthRequired:                return "411"
        case .preconditionFailed:            return "412"
        case .requestEntityTooLarge:         return "413"
        case .requestURITooLong:             return "414"
        case .unsupportedMediaType:          return "415"
        case .requestedRangeNotSatisfiable:  return "416"
        case .expectationFailed:             return "417"
        case .imATeapot:                     return "418"
        case .authenticationTimeout:         return "419"
        case .enhanceYourCalm:               return "420"
        case .unprocessableEntity:           return "422"
        case .locked:                        return "423"
        case .failedDependency:              return "424"
        case .preconditionRequired:          return "428"
        case .tooManyRequests:               return "429"
        case .requestHeaderFieldsTooLarge:   return "431"
            
        case .internalServerError:           return "500"
        case .notImplemented:                return "501"
        case .badGateway:                    return "502"
        case .serviceUnavailable:            return "503"
        case .gatewayTimeout:                return "504"
        case .httpVersionNotSupported:       return "505"
        case .variantAlsoNegotiates:         return "506"
        case .insufficientStorage:           return "507"
        case .loopDetected:                  return "508"
        case .notExtended:                   return "510"
        case .networkAuthenticationRequired: return "511"
            
        case .other(let statusCode, _):        return statusCode.description
        }
    }
}

extension Response.Status {
    /// Reason phrase.
    public var reasonPhrase: String {
        switch self {
        case .continue:                      return "Continue"
        case .switchingProtocols:            return "Switching Protocols"
        case .processing:                    return "Processing"
            
        case .ok:                            return "OK"
        case .created:                       return "Created"
        case .accepted:                      return "Accepted"
        case .nonAuthoritativeInformation:   return "Non Authoritative Information"
        case .noContent:                     return "No Content"
        case .resetContent:                  return "Reset Content"
        case .partialContent:                return "Partial Content"
            
        case .multipleChoices:               return "Multiple Choices"
        case .movedPermanently:              return "Moved Permanently"
        case .found:                         return "Found"
        case .seeOther:                      return "See Other"
        case .notModified:                   return "Not Modified"
        case .useProxy:                      return "Use Proxy"
        case .switchProxy:                   return "Switch Proxy"
        case .temporaryRedirect:             return "Temporary Redirect"
        case .permanentRedirect:             return "Permanent Redirect"
            
        case .badRequest:                    return "Bad Request"
        case .unauthorized:                  return "Unauthorized"
        case .paymentRequired:               return "Payment Required"
        case .forbidden:                     return "Forbidden"
        case .notFound:                      return "Not Found"
        case .methodNotAllowed:              return "Method Not Allowed"
        case .notAcceptable:                 return "Not Acceptable"
        case .proxyAuthenticationRequired:   return "Proxy Authentication Required"
        case .requestTimeout:                return "Request Timeout"
        case .conflict:                      return "Conflict"
        case .gone:                          return "Gone"
        case .lengthRequired:                return "Length Required"
        case .preconditionFailed:            return "Precondition Failed"
        case .requestEntityTooLarge:         return "Request Entity Too Large"
        case .requestURITooLong:             return "Request URI Too Long"
        case .unsupportedMediaType:          return "Unsupported Media Type"
        case .requestedRangeNotSatisfiable:  return "Requested Range Not Satisfiable"
        case .expectationFailed:             return "Expectation Failed"
        case .imATeapot:                     return "I'm A Teapot"
        case .authenticationTimeout:         return "Authentication Timeout"
        case .enhanceYourCalm:               return "Enhance Your Calm"
        case .unprocessableEntity:           return "Unprocessable Entity"
        case .locked:                        return "Locked"
        case .failedDependency:              return "Failed Dependency"
        case .preconditionRequired:          return "Precondition Required"
        case .tooManyRequests:               return "Too Many Requests"
        case .requestHeaderFieldsTooLarge:   return "Request Header Fields Too Large"
            
        case .internalServerError:           return "Internal Server Error"
        case .notImplemented:                return "Not Implemented"
        case .badGateway:                    return "Bad Gateway"
        case .serviceUnavailable:            return "Service Unavailable"
        case .gatewayTimeout:                return "Gateway Timeout"
        case .httpVersionNotSupported:       return "HTTP Version Not Supported"
        case .variantAlsoNegotiates:         return "Variant Also Negotiates"
        case .insufficientStorage:           return "Insufficient Storage"
        case .loopDetected:                  return "Loop Detected"
        case .notExtended:                   return "Not Extended"
        case .networkAuthenticationRequired: return "Network Authentication Required"
        case .other(_, let reasonPhrase): return reasonPhrase
        }
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
        return statusCodeString + " " + reasonPhrase
    }
}

// MARK: Time

extension Int {
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

/// Representation of a time interval.
///
/// To create a `Duration` you should use any of the following `Int` extensions:
///
/// - millisecond
/// - milliseconds
/// - second
/// - seconds
/// - minute
/// - minutes
/// - hour
/// - hours
///
/// ## Example:
/// ```swift
/// let oneMillisecond = 1.millisecond
/// let twoMilliseconds = 2.milliseconds
/// let oneSecond = 1.second
/// let twoSeconds = 2.seconds
/// let oneMinute = 1.minute
/// let twoMinutes = 2.minutes
/// let oneHour = 1.hour
/// let twoHours = 2.hours
/// ```
public struct Duration {
    let value: Int64
    
    fileprivate init(_ duration: Int) {
        self.value = Int64(duration)
    }
    
    /// Creates a `Deadline` from the duration.
    public func fromNow() -> Deadline {
        fatalError()
    }
}

extension Duration : Equatable {
    /// :nodoc:
    public static func == (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.value == rhs.value
    }
}

/// Representation of a deadline.
///
/// To create a `Deadline` you can either use the static values `.immediately` and `.never`
/// or call `fromNow()` from a previously created `Duration`.
///
/// ## Example:
/// ```swift
/// let deadline = 30.seconds.fromNow()
/// ```
public struct Deadline {
    /// Raw value representing the deadline.
    public let value: Int64
    
    init(_ deadline: Int64) {
        self.value = deadline
    }
    
    /// Deadline representing now.
    public static func now() -> Deadline {
        fatalError()
    }
    
    /// Special value to be used if the operation needs to be performed without blocking.
    public static var immediately: Deadline {
        fatalError()
    }
    
    /// Special value to be used to allow the operation to block forever if needed.
    public static var never: Deadline {
        fatalError()
    }
}

// MARK: IO

/// Representation of a type which binary data can be read from.
///
/// # Example
///
/// ```swift
/// let readBuffer = try readable.read(buffer, deadline: 1.minute.fromNow())
/// ```
public protocol Readable {
    /// Read binary data into `buffer` timing out at `deadline`.
    func read(
        _ buffer: UnsafeMutableRawBufferPointer,
        deadline: Deadline
    ) throws -> UnsafeRawBufferPointer
}

/// Representation of a type which binary data can be written to.
///
/// # Example
///
/// ```swift
/// try writable.write(buffer, deadline: 1.minute.fromNow())
/// ```
public protocol Writable {
    /// Write `buffer` timing out at `deadline`.
    func write(_ buffer: UnsafeRawBufferPointer, deadline: Deadline) throws
}

// MARK: Body

/// HTTP message body representation.
public enum Body {
    /// Body is in a readable form. This case is usually produced by parsers and used by responders.
    case readable(Readable)
    /// Body is in a writable form. This case is usually produced by responders and used by serializers.
    case writable(Write)
    
    /// Closure used to write binary data to the body.
    public typealias Write = (Writable) throws -> Void
}

// MARK: Async

/// Result of an operation. Usually retuned wrapped in an `AsyncResult`.
///
/// # Example
///
/// ```swift
/// readable.read(buffer, deadline: 1.minute.fromNow()) { result in
///     do {
///         let readBuffer = try result.value()
///         process(readBuffer)
///     } catch {
///         handle(error)
///     }
/// }
/// ```
public enum Result<Value, Error : Swift.Error> {
    /// Success.
    case success(Value)
    /// Failure.
    case failure(Error)
    
    /// Creates a succesfull result.
    public init(_ value: Value) {
        self = .success(value)
    }
    
    /// Creates a failure result.
    public init(_ error: Error) {
        self = .failure(error)
    }
    
    /// Tries to extract the value from the result.
    public func value() throws -> Value {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
    
    /// Useful when you just want to check if the operation succeeded
    /// without caring about the result.
    public func check() throws {
        _ = try value()
    }
}

/// Asynchronous result handler.
public typealias AsyncResult<Value, Error : Swift.Error> = (Result<Value, Error>) -> Void

/// Type erased error.
public struct AnyError : Error {
    /// Underlying error.
    public let error: Error
    
    /// Creates an error type erasing `error`.
    public init(error: Error) {
        self.error = error
    }
}

extension AnyError : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return String(describing: error)
    }
}


// MARK: AsyncReadable

/// Representation of a type which binary data can be read from asynchronously.
///
/// # Example
///
/// ```swift
/// readable.read(buffer, deadline: 1.minute.fromNow()) { result in
///     do {
///         let readBuffer = try result.value()
///         process(readBuffer)
///     } catch {
///         handle(error)
///     }
/// }
/// ```
public protocol AsyncReadable {
    /// Read binary data into `buffer` asynchronously timing out at `deadline`.
    func read(
        _ buffer: UnsafeMutableRawBufferPointer,
        deadline: Deadline,
        result: AsyncResult<UnsafeRawBufferPointer, AnyError>
    )
}

// MARK: AsyncWritable

/// Representation of a type which binary data can be written to asynchronously.
///
/// # Example
///
/// ```swift
/// writable.write(buffer, deadline: 1.minute.fromNow()) { result in
///     do {
///         try result.check()
///     } catch {
///         handle(error)
///     }
/// }
/// ```
public protocol AsyncWritable {
    /// Write `buffer` asynchronously timing out at `deadline`.
    func write(
        _ buffer: UnsafeRawBufferPointer,
        deadline: Deadline,
        result: AsyncResult<Void, AnyError>
    ) throws
}

// MARK: AsyncBody

/// Asynchronous HTTP message body representation.
public enum AsyncBody {
    /// Body is in a readable form. This case is usually produced by parsers and used by responders.
    case readable(AsyncReadable)
    /// Body is in a writable form. This case is usually produced by responders and used by serializers.
    case writable(Write)
    
    /// Closure used to write binary data to the body asynchronously.
    public typealias Write = (AsyncWritable) throws -> Void
}
