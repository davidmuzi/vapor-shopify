//
//  ShopifyAPI+Products.swift
//  App
//
//  Created by David Muzi on 2019-01-07.
//

import Foundation

struct ShopifyProduct: Codable {
	let title: String
}

struct ShopifyProducts: Codable {
	let products: [ShopifyProduct]
}

extension ShopifyProducts: ShopifyResource {
	static var path: String { return "products.json" }
}

extension ShopifyProducts: ResourceContainer {
	var contents: [ShopifyProduct] { return products }
}
