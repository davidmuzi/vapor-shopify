//
//  ProductsController.swift
//  App
//
//  Created by David Muzi on 2019-01-15.
//

import Vapor

struct ProductsController {
	
	func showProducts(_ req: Request) throws -> Future<View> {
		let api = try ShopifyAPI(session: req.session())
		
		return try api.get(resource: Products.self, request: req)
			.flatMap(to: View.self) { products in
				return try req.view().render("products", products)
			}
	}
}
