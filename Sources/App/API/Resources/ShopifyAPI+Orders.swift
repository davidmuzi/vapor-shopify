//
//  ShopifyAPI+Orders.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//
import Foundation

// Orders
struct ShopifyOrder: Codable {
	let email: String
	let totalPrice: String
	let id: Int
	
	enum CodingKeys: String, CodingKey {
		case totalPrice = "total_price"
		case email
		case id
	}
}

struct ShopifyOrders: Codable {
	let orders: [ShopifyOrder]
}

extension ShopifyOrders: ShopifyResource {
	static var path: String { return "orders.json" }
}

extension ShopifyOrders: ResourceContainer {
	var contents: [ShopifyOrder] { return orders }
}
