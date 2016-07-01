import Foundation
import SwiftCURL
import CCurl


public class SwiftyMail {

    
    
    var sender: Sender
    
    public init(sender: Sender) {
        self.sender = sender
    }
    
    public struct Sender {
        var server: String
        var email: String
        var password: String
        var name: String
    }
    
    public struct Receiver {
        var email: String
        var name: String
    }
    
    public struct EMail {
        var date: Date
        var title: String
        var content: String
    }
    

    struct MIME {
        var sender: Sender
        var receiver: Receiver
        var email: EMail
        
        var data: Data {
            get {
                var str = "\(string(from: email.date))\r\n"
                str += "To: \"\(receiver.name)\" <\(receiver.email)>\r\n"
                str += "From: \"\(sender.name)\" <\(sender.email)>\r\n"
                str += "Subject: \(RFC2047String(from: email.title))\r\n"
                str += "\r\n"
                str += email.content
                return str.data(using: .utf8)!
            }
        }
    }

}

private func string(from date: Date) -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
    formatter.locale = Locale(localeIdentifier: "en_US")
    return formatter.string(from: date)
}

private func RFC2047String(from: String) -> String {
    let data = from.data(using: .utf8)
    let base64 = data!.base64EncodedString()
    return "=?UTF-8?B?\(base64)?="
}

public extension SwiftyMail {
    func send(to receiver: Receiver, mail: EMail) throws {
        let curl = cURL()
        
        do {
            try curl.setOption(option: CURLOPT_URL, "smtps://\(sender.server)")
            try curl.setOption(option: CURLOPT_USE_SSL, Int(CURLUSESSL_ALL.rawValue))
            try curl.setOption(option: CURLOPT_USERNAME, sender.email)
            try curl.setOption(option: CURLOPT_PASSWORD, sender.password)
            try curl.setOption(option: CURLOPT_MAIL_FROM, "<\(sender.email)>")
            try curl.setOption(option: CURLOPT_MAIL_RCPT, ["<\(receiver.email)>"])
            
            let mime = MIME(sender: sender, receiver: receiver, email: mail)
            let payloadStorage = cURL.ReadFunctionStorage(data: mime.data)
            
            try curl.setOption(option: CURLOPT_READFUNCTION, curlReadFunction)
            try curl.setOption(option: CURLOPT_READDATA, payloadStorage)
            
            try curl.setOption(option: CURLOPT_UPLOAD, 1)
            
            try curl.perform()
        } catch let error {
            throw error
        }
    }
    
    
}





