//
//  Cart.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

struct CartItems : Codable{
    let code : Int?
    let message : String
    let data : CartDetails
    init(code : Int? , message : String , data : CartDetails) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct CartDetails: Codable {
    init(cartId: Int, tax: String, shipping: String, totalCost: String, shippingData: shippingInfo?, items: [itemDetails]) {
        self.cartId = cartId
        self.tax = tax
        self.shipping = shipping
        self.totalCost = totalCost
        self.shippingData = shippingData
        self.items = items
    }
    
    let cartId: Int
    let tax,shipping,totalCost: String?
    let shippingData : shippingInfo?
    var items: [itemDetails]
    enum CodingKeys:String,CodingKey{
        case cartId = "cart_id"
        case shippingData = "shipping_data"
        case tax,shipping,totalCost,items
    }
    
}
struct itemDetails: Codable {
    init(id: Int, productId: String, priceId: String?, priceTitle: String, priceValue: String, InPackage: String, quantity: String, productName: String, productImage: String,cartId: String) {
        self.id = id
        self.productId = productId
        self.priceId = priceId
        self.priceTitle = priceTitle
        self.priceValue = priceValue
        self.InPackage = InPackage
        self.quantity = quantity
        self.productName = productName
        self.productImage = productImage
        self.cartId = cartId
    }
    
    let id: Int
    let productId,priceId,priceTitle,priceValue,InPackage,quantity,productName,productImage,cartId: String?
    enum CodingKeys: String,CodingKey {
        case productId = "product_id"
        case priceId = "price_id"
        case priceTitle = "price_title"
        case priceValue = "price_value"
        case InPackage = "in_package"
        case productName = "product_name"
        case productImage = "product_image"
        case cartId = "cart_id"
        case id,quantity
    }
    
}
