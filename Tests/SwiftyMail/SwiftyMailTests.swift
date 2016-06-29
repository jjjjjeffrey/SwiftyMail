import XCTest
@testable import SwiftyMail

class SwiftyMailTests: XCTestCase {
    func testExample() {
        
        let content = "Date: Mon, 29 Nov 2010 21:54:29 +1100\r\n"+"To: 314099323@qq.com\r\n"+"From: 314099323@qq.com\r\n"+"Cc: jeffreyzeng@me.com\r\n"+"Message-ID: <dcd7cb36-11db-487a-9f3a-e652a9458efd@rfcpedant.example.org>\r\n"+"Subject: SMTP SSL example message\r\n"+"\r\n"+"The body of the message starts here.\r\n"+"\r\n"+"It could be a lot of lines, could be MIME encoded, whatever.\r\n"+"Check RFC5322.\r\n"
        
        let mail = SwiftyMail(to: "314099323@qq.com", from: "314099323@qq.com", password: "111111111", cc: "jeffreyzeng@me.com", content: content)
        mail.send()
    }


    static var allTests : [(String, (SwiftyMailTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
