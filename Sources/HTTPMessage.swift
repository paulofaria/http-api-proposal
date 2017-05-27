/// Representation of an HTTP message.
/// This protocol is useful for adding extensions which are common to both
/// HTTP requests and responses.
public protocol HTTPMessage {
    /// HTTP version.
    var version: HTTPVersion { get set }
    /// HTTP headers.
    var headers: HTTPHeaders { get set }
}
