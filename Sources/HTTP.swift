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
    }
}

// MARK: Time

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
    /// Raw value representing the duration.
    public let value: Double
    
    init(_ duration: Double) {
        self.value = duration
    }
    
    /// Creates a `Deadline` from the duration.
    public func fromNow() -> Deadline {
        fatalError()
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
    public let value: Double
    
    init(_ deadline: Double) {
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
