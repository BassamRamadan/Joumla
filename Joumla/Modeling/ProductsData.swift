//
//  ProductsData.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
struct Filters : Codable{
    let code : Int?
    let message : String
    let data : [FiltersData]
    init(code : Int? , message : String , data : [FiltersData]) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct FiltersData : Codable{
    let id: Int
    let name : String?
    init(id: Int,name: String?) {
        self.id = id
        self.name = name
    }
}
