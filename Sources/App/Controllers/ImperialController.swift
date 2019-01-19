//
//  ImperialController.swift
//  App
//
//  Created by David Muzi on 2018-12-27.
//

import Vapor
import Imperial
import Authentication

class ImperialController {
	var shopifyRouter: Shopify!
}

extension ImperialController {

	
	// This uses App Bridge to escape the iFrame and redirect to Shopify for OAuth
	func escape(_ req: Request) throws -> Future<AnyResponse> {
		
		let com = URLComponents(url: req.http.url, resolvingAgainstBaseURL: false)!
		let shop = com.queryItems!.first{ $0.name == "shop"}!.value!
		let apiKey = try ShopifyAuth().clientID
		
		let authURL = try shopifyRouter.shopifyRouter.generateAuthenticationURL(request: req)
		
		let html = """
		<html>
		<script src="https://unpkg.com/@shopify/app-bridge"></script>
		<script src="/scripts/redirect.js"></script>
		<script>redirect("\(apiKey)", "\(shop)", "\(authURL)")</script>
		</html>
		"""
		
		let promise: EventLoopPromise<View> = req.eventLoop.newPromise()
		promise.succeed(result: View(data: html.data(using: .utf8)!))
		return promise.futureResult.map(AnyResponse.init)
	}
}

extension ImperialController: RouteCollection {
	func boot(router: Router) throws {
		guard let callbackURL = Environment.get("SHOPIFY_CALLBACK_URL") else { fatalError("Callback not set") }
		
		shopifyRouter = try Shopify(router: router,
									authenticate: "login-shopify",
									callback: callbackURL,
									scope: ["read_products", "read_orders"]) { request, _ in
										return request.future(request.redirect(to: "/products"))
		}
		
		router.get("escape", use: escape)
	}
}
