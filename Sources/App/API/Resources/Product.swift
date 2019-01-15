//
//  ShopifyAPI+Products.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//

import Foundation

struct Product: Codable {
	let title: String
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
