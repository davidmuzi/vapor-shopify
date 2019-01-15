//
//  ShopifyAPI+Orders.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//
import Foundation

struct Order: Codable {
	let email: String
	let totalPrice: String
	let id: Int
	
	enum CodingKeys: String, CodingKey {
		case totalPrice = "total_price"
		case email
		case id
	}
}

struct Orders: Codable {
	let orders: [Order]
}

extension Orders: ShopifyResource {
	static var path: String { return "orders.json" }
}

extension Orders: ResourceContainer {
	var contents: [Order] { return orders }
}
