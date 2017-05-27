import XCTest
import HTTP

public class HTTPTests: XCTestCase {
    func testHTTPMethodPatternMatching() throws {
        let method: HTTPMethod = .get
        
        var success = false
        
        switch method {
        case HTTPMethod.get:
            success = true
        case HTTPMethod.post:
            XCTFail()
        default:
            XCTFail()
        }
        
        XCTAssert(success)
    }
    
    func testHTTPStatusPatternMatching() throws {
        let status: HTTPStatus = .ok
        
        var success = false
        
        switch status {
        case HTTPStatus.ok:
            success = true
        case HTTPStatus.clientErrorRange:
            XCTFail()
        case 300 ..< 400:
            XCTFail()
        default:
            XCTFail()
        }
        
        XCTAssert(success)
    }
}

extension HTTPTests {
    public static var allTests: [(String, (HTTPTests) -> () throws -> Void)] {
        return [
            ("testHTTPMethodPatternMatching", testHTTPMethodPatternMatching),
        ]
    }
}
