//
//  ShopifyAPI+Products.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//

import Foundation

struct Product: Codable {
	let title: String
	let id: Int
}

struct Products: Codable {
	let products: [Product]
}

extension Products: ShopifyResource {
	static var path: String { return "products.json" }
}

extension Products: ResourceContainer {
	var contents: [Product] { return products }
}

extension Products: Queryable {
		
	enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		
		func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim):
				return URLQueryItem(name: "limit", value: "\(lim)")
				
			case .page(let page):
				return URLQueryItem(name: "page", value: "\(page)")
			}
		}
	}
}
