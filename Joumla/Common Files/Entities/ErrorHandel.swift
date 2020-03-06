//
//  ErrorHandel.swift
//  Tourist-Guide
//
//  Created by mac on 12/4/19.
//  Copyright © 2019 Tamkeen. All rights reserved.
//

import Foundation

class ErrorHandle: Codable {
    let code: Int?
    let message: String?
    let data: [String]?
    init(code:Int?, message: String?,data: [String]?) {
        self.code = code
        self.message = message
        self.data = data
    }
    enum CodingKeys: String, CodingKey {
        case code, message, data
        
    }
}
