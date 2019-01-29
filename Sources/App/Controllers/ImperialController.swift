//
//  ImperialController.swift
//  App
//
//  Created by David Muzi on 2018-12-27.
//

import Vapor

class ImperialController {
	var shopifyRouter: Shopify!
	
	let authenticateSlug = "authenticate"
}

extension ImperialController {
	
	// 1. Called from iFrame will redirect to app as main frame using App Bridge
	func begin_auth(_ req: Request) throws -> Future<HTTPResponse> {
		
		print("1. Redirecting to self via App Bridge to escape iFrame")
		
		let com = URLComponents(url: req.http.url, resolvingAgainstBaseURL: false)!
		let shop = com.queryItems!.first{ $0.name == "shop"}!.value!
		let host = req.http.headers[.host].first!
		let url = "https://\(host)/\(authenticateSlug)?shop=\(shop)"
		let apiKey = try ShopifyAuth().clientID
		
		let html = """
		<html>
		<script src="https://unpkg.com/@shopify/app-bridge"></script>
		<script src="/scripts/redirect.js"></script>
		<script>redirect("\(apiKey)", "\(shop)", "\(url)")</script>
		</html>
		"""
		
		var response = HTTPResponse(status: .ok, body: html)
		response.contentType = .xml
		return req.future(response)
	}
	
	// 2. Called in main frame, initiates OAuth (which has write access to cookies) via a window redirect
	func authenticate(_ req: Request) throws -> Future<AnyResponse> {
		
		print("2. Redirecting to authentication flow")
		
		let authURL = try shopifyRouter.shopifyRouter.generateAuthenticationURL(request: req)
		
		let html = """
		<html><script>location.href = "\(authURL)"</script></html>
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
		
		router.get(authenticateSlug, use: authenticate)
		router.get("begin_auth", use: begin_auth)
	}
}
