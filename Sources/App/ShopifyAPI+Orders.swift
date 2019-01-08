//
//  ShopifyAPI+Orders.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//

import Vapor

// Orders
struct ShopifyOrder: Content {
	let email: String
	let totalPrice: String
	
	enum CodingKeys: String, CodingKey {
		case totalPrice = "total_price"
		case email
	}
}

struct ShopifyOrders: Content {
	let orders: [ShopifyOrder]
}

extension ShopifyOrders: ShopifyResource {
	static var path: String { return "orders.json" }
}

extension ShopifyOrders {
	static func get(on request: Request) throws -> Future<[ShopifyOrder]> {
		
		let api = try ShopifyAPI(session: request.session())
		return try api.get(resource: ShopifyOrders.self, request: request).map({ orders in
			return orders.orders
		})
	}
}
