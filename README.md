# HTTP API Proposal

This repo contains an HTTP API proposal for the [Swift Server APIs Project](https://swift.org/server-apis/) to be discussed in the [swift-server-dev](https://lists.swift.org/mailman/listinfo/swift-server-dev) mailing list.

## API Reference

For a more convenient overview of the API you can read the [API reference](https://paulofaria.github.io/http-proposal/).

## Rationale

Below I describe the reasoning behind the API design.

### No `HTTP` prefix

There's no need to prefix the types with `HTTP` because they are already defined inside the `HTTP` module. Their complete names are `HTTP.Request`, `HTTP.Response`, etc. Because the module name (`HTTP`) is so short, disambiguating by adding the `HTTP` prefix (`HTTP.Request`) does not make the names prohibitively long and in comparison to `HTTPRequest` it is only a single character longer. I'd even argue that `HTTP.Request` is more readable than `HTTPRequest`.

### `HTTP.Version` as a struct 

Having `HTTP.Version` as a `struct` allows it to adopt protocols, being the most useful [CustomStringConvertible](https://github.com/paulofaria/http-proposal/blob/master/Sources/HTTP.swift#L31) when serializing the HTTP message.

