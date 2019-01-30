//
//  ProductsController.swift
//  App
//
//  Created by David Muzi on 2019-01-15.
//

import Vapor
import Imperial
import Logging

struct ProductsController {

	func dummy(_ req: Request) throws -> Future<View> {
		return try req.view().render("products", ["domain": "davidmuzi.myshopify.com"])
	}
	
	func showProducts(_ req: Request) throws -> Future<AnyResponse> {
		
		let logger = try req.make(Logger.self)
		logger.info("fetching products: \(req.http.url.absoluteURL)")
		
		let api = try ShopifyAPI.Vapor(session: req.session())
		logger.info("got api")

		return try api.get(resource: Products.self, request: req)
			.map(to: AnyResponse.self) { products in
				
				struct Ctx: Content {
					let products: Products
					let domain: String
					let apiKey: String
				}
				
				let domain = try req.session()["shop_domain"]!
				let apiKey = try ShopifyAuth().clientID
				let ctx = Ctx(products: products, domain: domain, apiKey: apiKey)
				return try AnyResponse(req.view().render("products", ctx))
			}
	}
}

extension ProductsController: RouteCollection {
	func boot(router: Router) throws {
		router.get("products.json") { request -> Future<[Product]> in
			try Products.get(request: request)
		}
		
		router.get("orders.json") { request -> Future<[Order]> in
			try Orders.get(request: request)
		}
		
		router.get("products", use: showProducts)
		router.get("dummy", use: dummy)
		
		let authedRouter = router.grouped(AuthenticationMiddleware())
		authedRouter.get("products", use: showProducts)
	}
}
