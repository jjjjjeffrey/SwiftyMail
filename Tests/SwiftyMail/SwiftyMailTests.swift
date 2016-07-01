import XCTest
@testable import SwiftyMail

class SwiftyMailTests: XCTestCase {
    
    func testExample() {
        
        let sender = SwiftyMail.Sender(server: "smtp.qq.com:465", email: "314099323@qq.com", password: "18616998609b", name: "Jeffrey")
        let client = SwiftyMail(sender: sender)
        
        let receiver = SwiftyMail.Receiver(email: "jjjjjeffreyzeng@gmail.com", name: "曾大千")
        
        let email = SwiftyMail.EMail(date: Date(), title: "邮件发送测试", content: "Development Snapshots are prebuilt binaries that are automatically created from mainline development branches. These snapshots are not official releases. They have gone through automated unit testing, but they have not gone through the full testing that is performed for official releases.现在我们来重新回顾下前三弹模式匹配的各种语法 第一弹，第二弹，第三弹，第四弹是本系列的最后一篇文章，本章会教大家使用 if case let，for case where 等一些高级语法，让我们拭目以待吧！")
        
        do {
            try client.send(to: receiver, mail: email)
        } catch let error {
            print(error)
        }
        
        
    }


    static var allTests : [(String, (SwiftyMailTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
