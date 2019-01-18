//
//  ProductsController.swift
//  App
//
//  Created by David Muzi on 2019-01-15.
//

import Vapor
import Imperial

struct ProductsController {
	
	func dummy(_ req: Request) throws -> Future<View> {
		return try req.view().render("products", ["domain": "davidmuzi.myshopify.com"])
	}
	
	func showProducts(_ req: Request) throws -> Future<View> {
		let api = try ShopifyAPI(session: req.session())
		
		return try api.get(resource: Products.self, request: req)
			.flatMap(to: View.self) { products in
				
				struct Ctx: Content {
					let products: Products
					let domain: String
					let apiKey: String
				}
				
				let domain = try req.session().shopDomain()
				let apiKey = try ShopifyAuth().clientID
				let ctx = Ctx(products: products, domain: domain, apiKey: apiKey)
				return try req.view().render("products", ctx)
			}
	}
}
