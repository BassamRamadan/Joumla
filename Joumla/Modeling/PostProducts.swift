//
//  PostProducts.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

struct PostProducts: Codable {
    let code : Int?
    let message : String
    let data : PostProductsInfo?
    init(code : Int? , message : String , data : PostProductsInfo?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct PostProductsInfo: Codable {
    let main_category: ProductDetails?
    let products: [productsInfo]
     init(main_category: ProductDetails?,products: [productsInfo]) {
        self.main_category = main_category
        self.products = products
    }
    
}
struct productsInfo : Codable{
    internal init(id: Int, name: String?, discount: String?, price: String?, packagePrice: String?, InPackage: String?, imagePath: String?, netPrice: String?, prices: [pricesInfo]) {
        self.id = id
        self.name = name
        self.discount = discount
        self.price = price
        self.packagePrice = packagePrice
        self.InPackage = InPackage
        self.imagePath = imagePath
        self.netPrice = netPrice
        self.prices = prices
    }
    
    let id: Int
    let name,discount,price,packagePrice,InPackage,imagePath,netPrice: String?
    let prices: [pricesInfo]
    enum CodingKeys: String,CodingKey{
        case name,discount,price,id,prices
        case packagePrice = "package_price"
        case InPackage = "in_package"
        case imagePath = "image_path"
        case netPrice = "net_price"
    }
}
struct pricesInfo: Codable {
    internal init(id: Int, productId: String?, title: String?, count: String?, price: String?) {
        self.id = id
        self.productId = productId
        self.title = title
        self.count = count
        self.price = price
    }
    
    let id: Int
    let productId,title,count,price: String?
    enum CodingKeys: String,CodingKey{
        case title,count,price,id
        case productId = "product_id"
    }
}
