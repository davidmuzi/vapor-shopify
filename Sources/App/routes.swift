import Vapor
import Imperial

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
	
	// This uses App Bridge to escape the iFrame and redirect to Shopify for OAuth
	router.get("escape") { req -> Future<AnyResponse> in
		
		let com = URLComponents(url: req.http.url, resolvingAgainstBaseURL: false)!
		let shop = com.queryItems?.first{ $0.name == "shop"}?.value
		let apiKey = try ShopifyAuth().clientID
		guard let callbackURL = Environment.get("SHOPIFY_CALLBACK_URL") else { fatalError("Callback not set") }

		if (try? req.accessToken()) != nil {
			let redirect = req.redirect(to: "products")
			return req.future(AnyResponse(redirect))
		}
		
		let html = """
		<html>
		<script src="https://unpkg.com/@shopify/app-bridge"></script>
		<script src="/scripts/redirect.js"></script>
		<script>redirect("\(shop!)", "\(apiKey)", "\(callbackURL)")</script>
		</html>
		"""
		
		let promise: EventLoopPromise<View> = req.eventLoop.newPromise()
		promise.succeed(result: View(data: html.data(using: .utf8)!))
		return promise.futureResult.map(AnyResponse.init)
	}
	
	router.get("start") { req -> Future<Response> in
		let session = try req.session()
		guard session["shop_domain"] != nil else {
			let com = URLComponents(url: req.http.url, resolvingAgainstBaseURL: false)!
			let shop = com.queryItems?.first{ $0.name == "shop"}?.value
			
			let redirect = req.redirect(to: "login-shopify?shop=\(shop!)")
			return req.eventLoop.newSucceededFuture(result: redirect)
		}
		
		let redirect = req.redirect(to: "products")
		return req.eventLoop.newSucceededFuture(result: redirect)
	}
	
	router.get("products.json") { request -> Future<[Product]> in
		try Products.get(request: request)
	}
	
	router.get("orders.json") { request -> Future<[Order]> in
		try Orders.get(request: request)
	}
	
	router.get("products", use: ProductsController().showProducts)
	router.get("dummy", use: ProductsController().dummy)

	try router.register(collection: ImperialController())
}

