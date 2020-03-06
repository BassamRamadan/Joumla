//
//  File.swift
//
//  Created by Hassan Ramadan on 9/21/19.
//  Copyright © 2019 Hassan Ramadan IOS/Android Developer Tamkeen CO. All rights reserved.
//



import Foundation
import ObjectMapper


class AboutUS: Codable {
    let code: Int?
    let message: String?
    let data: AboutUSDataDetails
    
    init(code: Int, message: String, data: AboutUSDataDetails) {
        self.code = code
        self.message = message
        self.data = data
    }
}

class AboutUSDataDetails: Codable {
    let content: String?
    init(content: String? ) {
        self.content = content
    }
}



class SocialLinks: Codable {
    let code: Int?
    let message: String?
    let data: [SocialLinksDetails]
    
    init(code: Int, message: String, data: [SocialLinksDetails]) {
        self.code = code
        self.message = message
        self.data = data
    }
}

class SocialLinksDetails: Codable {
    let link: String?
    let icon: String?
    
    init(link: String, icon: String) {
        self.link = link
        self.icon = icon
    }
}

struct Contacts: Codable {
    let code: Int
    let message: String
    let data: [ContactsDetails]
    
    init(code: Int, message: String, data: [ContactsDetails]) {
        self.code = code
        self.message = message
        self.data = data
    }
}


struct ContactsDetails: Codable {
    let phone, whatsapp, telegram: String?
    
    enum CodingKeys: String, CodingKey {
        case phone, whatsapp, telegram
        
    }
    
    init(phone: String?, whatsapp: String?, telegram: String? ) {
        self.phone = phone
        self.whatsapp = whatsapp
        self.telegram = telegram
    
    }
}

