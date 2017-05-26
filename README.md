# HTTP API Proposal

This repo contains an HTTP API proposal for the [Swift Server APIs Project](https://swift.org/server-apis/) to be discussed in the [swift-server-dev](https://lists.swift.org/mailman/listinfo/swift-server-dev) mailing list.

## API Reference

For a more convenient overview of the API you can read the [API reference](https://paulofaria.github.io/http-proposal/).

## Rationale

Below I describe the reasoning behind the API design.

#### No `HTTP` prefix

There's no need to prefix the types with `HTTP` because they are already defined inside the `HTTP` module. Their complete names are `HTTP.Request`, `HTTP.Response`, etc. Because the module name (`HTTP`) is so short, disambiguating by adding the `HTTP` prefix (`HTTP.Request`) does not make the names prohibitively long and in comparison to `HTTPRequest` it is only a single character longer. I'd even argue that `HTTP.Request` is more readable than `HTTPRequest`.

#### `HTTP.Version` as a struct 

Having `HTTP.Version` as a `struct` allows it to adopt protocols, being the most useful [CustomStringConvertible](https://github.com/paulofaria/http-proposal/blob/master/Sources/HTTP.swift#L31) when serializing the HTTP message.

#### `HTTP.Headers` single storage [Internal]

Having a single storage for `HTTP.Headers` should provide better performance. We delegate case insensitive matching to the implementation of `HTTP.Headers.Field`'s `Equatable` conformance.

#### Add `Storage` to `HTTP.Message` protocol

This is *very* important for extensiblity as it allows API users to store data in `HTTP.Message` extensions. The most common use case for this would be adding contextual data inside HTTP middleware.

#### `URI`

`Foundation.URL` and `Foundation.URLComponents` are quite slow on parsing and initialization. I imagine this is because of all of the other functionality bundled in the aforementioned types, specially `Foundation.URL`. Also, strictly speaking, HTTP RFCs mention URIs not URL, but that's just a matter of naming.

#### `HTTP.Request.Method` nested in `HTTP.Request`

HTTP methods only exist inside HTTP requests, more specifically in the request line. Nesting it inside `HTTP.Request` also helps disambiguating from `Foundation.Method`.

#### Lowercase `HTTP.Request.Method` cases

According to Swift's '[API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) enum cases should be lowerCamelCase.

> Follow case conventions. Names of types and protocols are UpperCamelCase. Everything else is lowerCamelCase.
> 
> Acronyms and initialisms that commonly appear as all upper case in American English should be uniformly up- or down-cased according to case conventions:

```swift
var utf8Bytes: [UTF8.CodeUnit]
var isRepresentableAsASCII = true
var userSMTPServer: SecureSMTPServer
```

> Other acronyms should be treated as ordinary words:

```
var radarDetector: RadarScanner
var enjoysScubaDiving = true
```

#### `HTTP.Response.Status` nested in `HTTP.Response`

Same reasoning as `HTTP.Request.Method` nested inside `HTTP.Request`. HTTP status only exist inside HTTP responses, more specifically in the response line. Nesting it inside `HTTP.Request` also helps disambiguating from other possible `Status` types.

#### Deadlines instead of timeouts.

Deadlines are easier to deal with. There's no need for intermediate calculations when providing the value for separate calls.

#### Use `Async` as a prefix for assynchronous based types.

Most common APIs are synchronous. Asynchronous APIs are the exception in general. Prefixing all synchronous APIs with `Sync` would be insane.

#### Use `UnsafeMutableRawBufferPointer` and `UnsafeRawBufferPointer` instead of `Foundation.Data`

Using buffer pointers is more performant and depends solely on the standard library. Buffer pointers are also better suited for C APIs interfacing. The current proposal doesn't depend on `Foundation` at all, but it's possible to provide extensions for the APIs that take buffer pointers converting to and from `Foundation.Data`.

#### Use `Result<Value, Error>` for asynchronous APIs.

`Result` is a quite known type and it's used extensively by other async frameworks.



