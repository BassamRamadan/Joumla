//
//  SignUp.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/29/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
struct User : Codable {
    let code : Int?
    let message : String
    let data : UserInfo?
    init(code : Int? , message : String , data : UserInfo?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct UserInfo : Codable{
    let name,phone,email,accessToken : String?
    let emailVerifiedAt,firebase,status,imagePath,image : String?
    let id : Int
    enum CodingKeys: String, CodingKey {
        case name,phone,email,id,firebase,status,image
        case accessToken = "access_token"
        case emailVerifiedAt = "email_verified_at"
        case imagePath = "image_path"
    }
    init(name : String,phone : String,email : String,accessToken : String?,id : Int,emailVerifiedAt : String?,firebase : String?,status : String?,imagePath : String?,image : String?) {
        self.name = name
        self.phone = phone
        self.email = email
        self.accessToken = accessToken
        self.id = id
        self.emailVerifiedAt = emailVerifiedAt
        self.status = status
        self.firebase = firebase
        self.imagePath = imagePath
        self.image = image
    }
}
