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
    fileprivate var headers: [Field: String]
    
    /// :nodoc:
    public init(_ headers: [Field: String]) {
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
    public init(dictionaryLiteral elements: (Field, String)...) {
        var headers: [Field: String] = [:]
        
        for (key, value) in elements {
            headers[key] = value
        }
        
        self.headers = headers
    }
}

extension Headers : Sequence {
    /// :nodoc:
    public func makeIterator() -> DictionaryIterator<Field, String> {
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
    public subscript(field: Field) -> String? {
        get {
            return headers[field]
        }
        
        set(header) {
            headers[field] = header
        }
    }
    
    /// :nodoc:
    public subscript(field: String) -> String? {
        get {
            return self[Field(field)]
        }
        
        set(header) {
            self[Field(field)] = header
        }
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
        return lhs.headers == rhs.headers
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
    
    /// `Set-Cookie` is the *only* HTTP header which can appear
    /// more than once in an HTTP message. So we make exception
    /// and store the cookies in a separate container from the other
    /// HTTP headers.
    public var cookieHeaders: Set<String> = []
    
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
    /// Body is in a readable form. This case is usually produced by parsers.
    case readable(Readable)
    /// Body is in a writable form. This case is usually produced by responders.
    case writable(Write)
    
    /// Closure used to write binary data to the body.
    public typealias Write = (Writable) throws -> Void
}

// MARK: Async

/// Asynchronous result.
public typealias ResultHandler<T> = (Void) throws -> T

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
public struct Result<T> {
    fileprivate let handler: ResultHandler<T>
    
    /// Creates a result from a handler.
    public init(_ handler: @escaping ResultHandler<T>) {
        self.handler = handler
    }
    
    /// Tries to extract the value from the result.
    public func value() throws -> T {
        return try handler()
    }
    
    /// Useful when you just want to check if the operation succeeded
    /// without caring about the result.
    public func check() throws {
        _ = try handler()
    }
}

/// Asynchronous result handler.
public typealias AsyncResult<T> = (Result<T>) -> Void

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
        result: AsyncResult<UnsafeRawBufferPointer>
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
        result: AsyncResult<Void>
    ) throws
}

// MARK: AsyncBody

/// Asynchronous HTTP message body representation.
public enum AsyncBody {
    /// Body is in a readable form. This case is usually produced by parsers.
    case readable(AsyncReadable)
    /// Body is in a writable form. This case is usually produced by responders.
    case writable(AsyncWrite)
    
    /// Closure used to write binary data to the body asynchronously.
    public typealias AsyncWrite = (AsyncWritable) throws -> Void
}
