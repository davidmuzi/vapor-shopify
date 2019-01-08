//
//  ShopifyAPI+Products.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//

import Foundation
import Vapor

struct ShopifyProduct: Content {
	let title: String
}

struct ShopifyProducts: Content {
	let products: [ShopifyProduct]
}

extension ShopifyProducts: ShopifyResource {
	static var path: String { return "products.json" }
}

extension ShopifyProducts {
	static func get(on request: Request) throws -> Future<[ShopifyProduct]> {
		
		let api = try ShopifyAPI(session: request.session())
		return try api.get(resource: ShopifyProducts.self, request: request).map({ (products) in
			return products.products
		})
	}
}
