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
    public struct Method {
        /// HTTP method
        public let method: String
        
        /// Creates an HTTP method.
        init(_ method: String) {
            self.method = method.uppercased()
        }
        
        /// GET method.
        public static var get = Method("GET")
        /// HEAD method.
        public static var head = Method("HEAD")
        /// POST method.
        public static var post = Method("POST")
        /// PUT method.
        public static var put = Method("PUT")
        /// PATCH method.
        public static var patch = Method("PATCH")
        /// DELETE method.
        public static var delete = Method("DELETE")
        /// OPTIONS method.
        public static var options = Method("OPTIONS")
        /// TRACE method.
        public static var trace = Method("TRACE")
        /// CONNECT method.
        public static var connect = Method("CONNECT")
    }
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
    public struct Status {
        /// HTTP status code.
        public let statusCode: Int
        /// HTTP reason phrase.
        public let reasonPhrase: String
        
        /// Creates an HTTP status code.
        public init(statusCode: Int, reasonPhrase: String) {
            self.statusCode = statusCode
            self.reasonPhrase = reasonPhrase
        }
        
        /// Continue.
        public static var `continue` = Status(statusCode: 100, reasonPhrase: "Continue")
        /// Switching Protocols.
        public static var switchingProtocols = Status(statusCode: 101, reasonPhrase: "Switching Protocols")
        /// Processing.
        public static var processing = Status(statusCode: 102, reasonPhrase: "Processing")
        
        /// OK.
        public static var ok = Status(statusCode: 200, reasonPhrase: "OK")
        /// Created.
        public static var created = Status(statusCode: 201, reasonPhrase: "Created")
        /// Accepted.
        public static var accepted = Status(statusCode: 202, reasonPhrase: "Accepted")
        /// Non Authoritative Information.
        public static var nonAuthoritativeInformation = Status(statusCode: 203, reasonPhrase: "Non Authoritative Information")
        /// No Content.
        public static var noContent = Status(statusCode: 204, reasonPhrase: "No Content")
        /// Reset Content.
        public static var resetContent = Status(statusCode: 205, reasonPhrase: "Reset Content")
        /// Partial Content.
        public static var partialContent = Status(statusCode: 206, reasonPhrase: "Partial Content")
        
        /// Multiple choices.
        public static var multipleChoices = Status(statusCode: 300, reasonPhrase: "Multiple Choices")
        /// Moved permanently.
        public static var movedPermanently = Status(statusCode: 301, reasonPhrase: "Moved Permanently")
        /// Found.
        public static var found = Status(statusCode: 302, reasonPhrase: "Found")
        /// See Other
        public static var seeOther = Status(statusCode: 303, reasonPhrase: "See Other")
        /// Not Modified.
        public static var notModified = Status(statusCode: 304, reasonPhrase: "Not Modified")
        /// Use Proxy.
        public static var useProxy = Status(statusCode: 305, reasonPhrase: "Use Proxy")
        /// Switch Proxy.
        public static var switchProxy = Status(statusCode: 306, reasonPhrase: "Switch Proxy")
        /// Temporary Redirect.
        public static var temporaryRedirect = Status(statusCode: 307, reasonPhrase: "Temporary Redirect")
        /// Permanent Redirect.
        public static var permanentRedirect = Status(statusCode: 308, reasonPhrase: "Permanent Redirect")
        
        /// Bad Request.
        public static var badRequest = Status(statusCode: 400, reasonPhrase: "Bad Request")
        /// Unauthorized.
        public static var unauthorized = Status(statusCode: 401, reasonPhrase: "Unauthorized")
        /// Payment Required.
        public static var paymentRequired = Status(statusCode: 402, reasonPhrase: "Payment Required")
        /// Forbidden.
        public static var forbidden = Status(statusCode: 403, reasonPhrase: "Forbidden")
        /// Not Found.
        public static var notFound = Status(statusCode: 404, reasonPhrase: "Not Found")
        /// Method Not Allowed.
        public static var methodNotAllowed = Status(statusCode: 405, reasonPhrase: "Method Not Allowed")
        /// Not Acceptable.
        public static var notAcceptable = Status(statusCode: 406, reasonPhrase: "Not Acceptable")
        /// Proxy Authentication Required.
        public static var proxyAuthenticationRequired = Status(statusCode: 407, reasonPhrase: "Proxy Authentication Required")
        /// Request Timeout.
        public static var requestTimeout = Status(statusCode: 408, reasonPhrase: "Request Timeout")
        /// Conflict.
        public static var conflict = Status(statusCode: 409, reasonPhrase: "Conflict")
        /// Gone.
        public static var gone = Status(statusCode: 410, reasonPhrase: "Gone")
        /// Length Required.
        public static var lengthRequired = Status(statusCode: 411, reasonPhrase: "Length Required")
        /// Precodition Failed.
        public static var preconditionFailed = Status(statusCode: 412, reasonPhrase: "Precondition Failed")
        /// Request Entity Too Large.
        public static var requestEntityTooLarge = Status(statusCode: 413, reasonPhrase: "Request Entity Too Large")
        /// Request URI Too Long.
        public static var requestURITooLong = Status(statusCode: 414, reasonPhrase: "Request URI Too Long")
        //// Unsupported Media Type.
        public static var unsupportedMediaType = Status(statusCode: 415, reasonPhrase: "Unsupported Media Type")
        /// Request Range Not Satisfiable.
        public static var requestedRangeNotSatisfiable = Status(statusCode: 416, reasonPhrase: "Request Range Not Satisfiable")
        /// Expectation Failed.
        public static var expectationFailed = Status(statusCode: 417, reasonPhrase: "Expectation Failed")
        /// I'm A Teapot.
        public static var imATeapot = Status(statusCode: 418, reasonPhrase: "I'm A Teapot")
        /// Authentication Timeout.
        public static var authenticationTimeout = Status(statusCode: 419, reasonPhrase: "Authentication Timeout")
        /// Enhance Your Calm.
        public static var enhanceYourCalm = Status(statusCode: 420, reasonPhrase: "Enhance Your Calm")
        /// Unprocessable Entity.
        public static var unprocessableEntity = Status(statusCode: 422, reasonPhrase: "Unprocessable Entity")
        /// Locked.
        public static var locked = Status(statusCode: 423, reasonPhrase: "Locked")
        /// Failed Dependency.
        public static var failedDependency = Status(statusCode: 424, reasonPhrase: "Failed Dependency")
        /// Precondition Required.
        public static var preconditionRequired = Status(statusCode: 428, reasonPhrase: "Precondition Required")
        /// Too Many Requests.
        public static var tooManyRequests = Status(statusCode: 429, reasonPhrase: "Too Many Requests")
        /// Request Header Fields Too Large.
        public static var requestHeaderFieldsTooLarge = Status(statusCode: 431, reasonPhrase: "Request Header Fields Too Large")
        
        /// Internal Server Error.
        public static var internalServerError = Status(statusCode: 500, reasonPhrase: "Internal Server Error")
        /// Not Implemented.
        public static var notImplemented = Status(statusCode: 501, reasonPhrase: "Not Implemented")
        /// Bad Gateway.
        public static var badGateway = Status(statusCode: 502, reasonPhrase: "Bad Gateway")
        /// Service Unavailable.
        public static var serviceUnavailable = Status(statusCode: 503, reasonPhrase: "Service Unavailable")
        /// Gateway Timeout.
        public static var gatewayTimeout = Status(statusCode: 504, reasonPhrase: "Gateway Timeout")
        /// HTTP Version Not Supported.
        public static var httpVersionNotSupported = Status(statusCode: 505, reasonPhrase: "HTTP Version Not Supported")
        /// Variant Also Negotiates.
        public static var variantAlsoNegotiates = Status(statusCode: 506, reasonPhrase: "Variant Also Negotiates")
        /// Insufficient Storage.
        public static var insufficientStorage = Status(statusCode: 507, reasonPhrase: "Insufficient Storage")
        /// Loop Detected.
        public static var loopDetected = Status(statusCode: 508, reasonPhrase: "Loop Detected")
        /// Not Extended.
        public static var notExtended = Status(statusCode: 510, reasonPhrase: "Not Extended")
        /// Network Authentication Required.
        public static var networkAuthenticationRequired = Status(statusCode: 511, reasonPhrase: "Network Authentication Required")
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
