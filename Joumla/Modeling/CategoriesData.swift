//
//  CategoriesData.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
struct CategoriesData : Codable {
    let code : Int?
    let message : String
    let data : [CategoriesDetails]
    init(code : Int? , message : String , data : [CategoriesDetails]) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct CategoriesDetails: Codable {
    let name,imagePath : String?
    let productsList,id: Int
    enum CodingKeys: String,CodingKey{
        case name,id
        case imagePath = "image_path"
        case productsList = "products_list"
    }
    init(name : String,imagePath : String?,productsList : Int,id : Int) {
        self.name = name
        self.productsList = productsList
        self.imagePath = imagePath
        self.id = id
    }
}
