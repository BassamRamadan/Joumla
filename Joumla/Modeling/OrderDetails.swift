//
//  OrderDetails.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

struct OrderDetails : Codable{
    let code : Int?
    let message : String
    let data : OrderInformation
    init(code : Int? , message : String , data : OrderInformation) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct OrderInformation : Codable {
    let id: Int
    let userId,cartId,shippingId,tax,shipping,totalCost,status,createdAt: String
    let items: [PurchasesDetails]
    let shippingData: shippingInfo
    enum CodingKeys:String,CodingKey{
        case userId = "user_id"
        case cartId = "cart_id"
        case shippingId = "shipping_id"
        case totalCost = "total_cost"
        case shippingData = "shipping_data"
        case id,tax,shipping,status,createdAt,items
    }
    init(id: Int,userId: String,cartId: String,shippingId: String,tax: String,shipping: String,totalCost: String,status: String,createdAt: String,items: [PurchasesDetails],shippingData: shippingInfo) {
        self.id = id
        self.userId = userId
        self.cartId = cartId
        self.shippingId = shippingId
        self.tax = tax
        self.shipping = shipping
        self.totalCost = totalCost
        self.status = status
        self.createdAt = createdAt
        self.items = items
        self.shippingData = shippingData
    }
}
struct PurchasesDetails : Codable {
    let id: Int
    let Pricetitle,PriceValue,InPackage,quantity : String
    let product : ProductDetails
    enum CodingKeys : String , CodingKey{
        case InPackage = "in_package"
        case PriceValue = "price_value"
        case Pricetitle = "price_title"
        case id,quantity,product
    }
    init(id: Int,Pricetitle : String,PriceValue : String,InPackage : String,quantity : String,product : ProductDetails) {
        self.id = id
        self.Pricetitle = Pricetitle
        self.PriceValue = PriceValue
        self.product = product
        self.InPackage = InPackage
        self.quantity = quantity
    }
}
struct ProductDetails : Codable{
    let name,imagePath : String
    enum CodingKeys : String , CodingKey{
        case imagePath = "image_path"
        case name
    }
    init(name : String,imagePath : String) {
        self.name = name
        self.imagePath = imagePath
    }
}
struct shippingInfo : Codable {
    let id : Int
    let UserId,CartId,PaymentId,name,type,phone,address,lat,lon : String
    let payment : paymentInfo
    enum CodingKeys: String,CodingKey{
        case UserId = "user_id"
        case CartId = "cart_id"
        case PaymentId = "payment_id"
        case id,name,type,phone,address,lat,lon,payment
    }
    init(id : Int,UserId : String,CartId : String,PaymentId : String,name : String,type : String,phone : String,address : String,lat : String,lon : String,payment : paymentInfo) {
        self.id = id
        self.UserId = UserId
        self.CartId = CartId
        self.PaymentId = PaymentId
        self.name = name
        self.phone = phone
        self.address = address
        self.lat = lat
        self.lon = lon
        self.payment = payment
        self.type = type
    }
}
struct paymentInfo : Codable {
    let id : Int
    let name : String
    init(id : Int , name : String) {
        self.id = id
        self.name = name
    }
}
