//
//  PostProducts.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

class PostProducts: Codable {
    let code : Int?
    let message : String
    let data : PostProductsInfo?
    init(code : Int? , message : String , data : PostProductsInfo?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
class PostProductsInfo: Codable {
    let main_category: ProductDetails?
     init(main_category: ProductDetails?) {
        self.main_category = main_category
    }
    
}
