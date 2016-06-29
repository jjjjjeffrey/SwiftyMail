import Foundation
import CCurl


class SwiftyMail {

    var mailTo: String
    var mailFrom: String
    var mailFromPassword: String
    var mailCC: String
    var mailContent: String
    
    var curl = curl_easy_init()
    var recipients: UnsafeMutablePointer<curl_slist>!
    
    
    init(to mailTo: String, from: String, password: String, cc: String, content: String) {
        self.mailTo = mailTo
        self.mailFrom = from
        self.mailFromPassword = password
        self.mailCC = cc
        self.mailContent = content
    }
    
    func send() {
        
        let unsafeSelf = Unmanaged<SwiftyMail>.passUnretained(self).toOpaque()
        
        curl_easy_setopt_cstr(curl, CURLOPT_URL, "smtps://smtp.qq.com:465")
        
        curl_easy_setopt_int64(curl, CURLOPT_USE_SSL, Int64(CURLUSESSL_ALL.rawValue))
        curl_easy_setopt_cstr(curl, CURLOPT_USERNAME, self.mailFrom)
        curl_easy_setopt_cstr(curl, CURLOPT_PASSWORD, self.mailFromPassword)
        
        curl_easy_setopt_cstr(curl, CURLOPT_MAIL_FROM, mailFrom)
        
        recipients = curl_slist_append(recipients, mailTo)
        recipients = curl_slist_append(recipients, mailCC)
        curl_easy_setopt_slist(curl, CURLOPT_MAIL_RCPT, recipients)
        
        let payload_source: curl_func = { (ptr, size, num, userp) -> Int in
            let mySelf = Unmanaged<SwiftyMail>.fromOpaque(userp!).takeUnretainedValue()
            
            
            if let ptr = UnsafeMutablePointer<UInt8>(ptr), let content = UnsafeMutablePointer<UInt8>(mySelf.mailContent.cString(using: NSUTF8StringEncoding)) {
                
                ptr.assignFrom(content, count: mySelf.mailContent.characters.count)
                
            }
            return 0
        }
        
        
        curl_easy_setopt_func(curl, CURLOPT_READFUNCTION, payload_source)
        
        curl_easy_setopt_void(curl, CURLOPT_READDATA, unsafeSelf)
        
        curl_easy_setopt_long(curl, CURLOPT_UPLOAD, 1)
        
        let code = curl_easy_perform(curl)
        if code != CURLE_OK {
            print("perform error: \(String(validatingUTF8: curl_easy_strerror(code))!)")
        }
        
        
        
    }
    
    func payload(ptr: UnsafeMutablePointer<Void>?, size: Int, num: Int, userp: UnsafeMutablePointer<Void>?) -> Int {
        if let ptr = UnsafeMutablePointer<UInt8>(ptr), let content = UnsafeMutablePointer<UInt8>(self.mailContent.cString(using: NSUTF8StringEncoding)) {
            
            ptr.assignFrom(content, count: self.mailContent.characters.count)
        }
        return 0
    }
}


