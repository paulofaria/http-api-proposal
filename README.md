# HTTP API Proposal

This repo contains an HTTP API proposal for the [Swift Server APIs Project](https://swift.org/server-apis/) to be discussed in the [swift-server-dev](https://lists.swift.org/mailman/listinfo/swift-server-dev) mailing list.

## API Reference

For a more convenient overview of the API you can read the [API reference](https://paulofaria.github.io/http-api-proposal/).

## Rationale

Reasoning behind the API design.

#### `HTTPVersion`

```swift
public struct HTTPVersion {
    public var major: Int
    public var minor: Int
    
    public init(major: Int, minor: Int) {
        self.major = major
        self.minor = minor
    }
}
```

`HTTPVersion` is a `struct` because it allows it to adopt `Hashable`, `Equatable` and `CustomStringConvertible` or any other protocol defined in an extension, if needed.

#### `HTTPHeaders`

```swift
public struct HTTPHeaders {
    public var headers: [(Field, String)]

    public init(_ headers: [(Field, String)]) {
        self.headers = headers
    }
    
    public struct Field {
        public let original: String
        
        public init(_ original: String) {
            self.original = original
        }
    }
}
```

`HTTPHeaders` is a `struct`  because it allows it to adopt `Hashable`, `Equatable` and `CustomStringConvertible` or any other protocol defined in an extension, if needed. Its backing storage is an array of tuples, but `HTTPHeaders` has a subcript function which allows one to access the headers as if it was `[String: [String]]`. The `Field` type's `Equatable` implementation does case insensitive comparison. This allows us to have a single storage and only do case insensitive checking when necessary, thus improving performance.

#### `HTTPMessage`

```swift
public protocol HTTPMessage {
    var version: HTTPVersion { get set }
    var headers: HTTPHeaders { get set }
}
```

The `HTTPMessage` represents HTTP messages (HTTP request and HTTP response). Its goal is to allow extensions with properties and functions which are common to both `HTTPRequest` and `HTTPResponse`. A simple example would be:

```
public var contentLength: Int? {
    get {
        return headers["Content-Length"].flatMap({ Int($0) })
    }
    
    set(contentLength) {
        headers["Content-Length"] = contentLength?.description
    }
}
```

Usage would be:

```
let requestContentLenght = request.contentLength
let responseContentLenght = response.contentLength
````

#### HTTPMethod

```swift
public struct HTTPMethod {
    public let method: String
    
    public init(_ method: String) {
        self.method = method.uppercased()
    }
}
```

`HTTPMethod` is a `struct` because by definition HTTP methods are open. This means that you can have custom HTTP methods, so an `enum` would not represent the type correctly. Here's an example of how to create your own `HTTPMethod` if the static ones provided by default don't fit your needs.

```swift
extension HTTPMethod {
    public static var batch = HTTPMethod("BATCH")
}
```

Besides, the implementation provides pattern matching allowing `HTTPMethod` to be used in a `switch` case.

```swift
switch method {
case HTTPMethod.get:
    ...
case HTTPMethod.post:
    ...
default:
    ...
}
```

#### `HTTPRequest`

```swift
public struct HTTPRequest : HTTPMessage {
    public var method: HTTPMethod
    public var uri: String
    public var version: HTTPVersion
    public var headers: HTTPHeaders
    
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
```

`HTTPRequest` represents an HTTP request.

#### `HTTPStatus`

```swift
public struct HTTPStatus {
    public let statusCode: Int
    public let reasonPhrase: String
    
    public init(statusCode: Int, reasonPhrase: String) {
        self.statusCode = statusCode
        self.reasonPhrase = reasonPhrase
    }
}
```

`HTTPStatus` is a `struct` because by definition HTTP statuses are open. This means that you can have custom HTTP statuses, so an `enum` would not represent the type correctly. It's important to notice that the reason phrase is purely informational, meaning you can have different reason phrases for existing status codes. Here's an example of how to create your own `HTTPStatus` with a custom reason phrase.

```swift
extension HTTPStatus {
    public static var `youShallNotPass` = HTTPStatus(
        statusCode: 401,
        reasonPhrase: "You Shall Not Pass"
    )
}
```

Besides, the implementation provides pattern matching allowing `HTTPStatus` to be used in a `switch` case.

```swift
switch status {
case HTTPStatus.ok:
    ...
case HTTPStatus.clientErrorRange:
    ...
case 300 ..< 400:
    ...
default:
    ...
}
```

#### `HTTPResponse`

```swift
public struct HTTPResponse : HTTPMessage {
    public var status: HTTPStatus
    public var headers: HTTPHeaders
    public var version: HTTPVersion
    
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
```

`HTTPRequest` represents an HTTP response.
