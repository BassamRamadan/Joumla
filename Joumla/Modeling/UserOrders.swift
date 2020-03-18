//
//  UserOrders.swift
//  Joumla
//
//  Created by Bassam Ramadan on 3/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

struct UserOrders : Codable {
    let code : Int?
    let message : String
    let data : [OrdersDetails]
    init(code : Int? , message : String , data : [OrdersDetails]) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct OrdersDetails : Codable {
    let id: Int
    let userId,cartId,shippingId,tax,shipping,totalCost,status,createdAt: String
    
    enum CodingKeys:String,CodingKey{
        case userId = "user_id"
        case cartId = "cart_id"
        case shippingId = "shipping_id"
        case totalCost = "total_cost"
        case id,tax,shipping,status,createdAt
    }
    init(id: Int,userId: String,cartId: String,shippingId: String,tax: String,shipping: String,totalCost: String,status: String,createdAt: String) {
        self.id = id
        self.userId = userId
        self.cartId = cartId
        self.shippingId = shippingId
        self.tax = tax
        self.shipping = shipping
        self.totalCost = totalCost
        self.status = status
        self.createdAt = createdAt
    }
}
