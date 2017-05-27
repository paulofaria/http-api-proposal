/// Representation of the HTTP headers.
/// Headers are subscriptable using case-insensitive comparison.
public struct HTTPHeaders {
    /// HTTP headers.
    public var headers: [(Field, String)]
    
    /// Creates HTTP headers.
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

extension HTTPHeaders : ExpressibleByDictionaryLiteral {
    /// :nodoc:
    public init(dictionaryLiteral headers: (Field, String)...) {
        self.headers = headers
    }
}

extension HTTPHeaders : Sequence {
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

extension HTTPHeaders : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        var string = ""
        
        for (header, value) in headers {
            string += "\(header): \(value)\n"
        }
        
        return string
    }
}

extension HTTPHeaders : Hashable {
    public var hashValue: Int {
        return description.hashValue
    }
}

extension HTTPHeaders : Equatable {
    /// :nodoc:
    public static func == (lhs: HTTPHeaders, rhs: HTTPHeaders) -> Bool {
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

/// :nodoc:
public func ~= (pattern: HTTPHeaders, value: HTTPHeaders) -> Bool {
    return pattern == value
}

extension HTTPHeaders.Field : CustomStringConvertible {
    /// :nodoc:
    public var description: String {
        return original
    }
}

extension HTTPHeaders.Field : Hashable {
    /// :nodoc:
    public var hashValue: Int {
        return original.hashValue
    }
}

extension HTTPHeaders.Field : Equatable {
    /// :nodoc:
    public static func == (lhs: HTTPHeaders.Field, rhs: HTTPHeaders.Field) -> Bool {
        if lhs.original == rhs.original {
            return true
        }
        
        return lhs.original.caseInsensitiveCompare(rhs.original)
    }
}

extension HTTPHeaders.Field : ExpressibleByStringLiteral {
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

/// :nodoc:
public func ~= (pattern: HTTPHeaders.Field, value: HTTPHeaders.Field) -> Bool {
    return pattern == value
}

// Implementation details

extension UTF8.CodeUnit {
    fileprivate func lowercased() -> UTF8.CodeUnit {
        let isUppercase = self >= 65 && self <= 90
        
        if isUppercase {
            return self + 32
        }
        
        return self
    }
}

extension String {
    fileprivate func caseInsensitiveCompare(_ other: String) -> Bool {
        if self.utf8.count != other.utf8.count {
            return false
        }
        
        for (lhs, rhs) in zip(self.utf8, other.utf8) {
            if lhs.lowercased() != rhs.lowercased() {
                return false
            }
        }
        
        return true
    }
}
