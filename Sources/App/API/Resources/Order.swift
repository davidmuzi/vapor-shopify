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

extension Orders: Queryable {
	
	enum Status: String {
		case open
		case closed
		case cancelled
	}
	
	enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		case status(Status)
		
		func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim):
				return URLQueryItem(name: "limit", value: "\(lim)")
			case .page(let page):
				return URLQueryItem(name: "page", value: "\(page)")
			case .status(let status):
				return URLQueryItem(name: "status", value: status.rawValue)

			}
		}
	}
}
