import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
	
	router.get("products") { request -> Future<[ShopifyProduct]> in
		try ShopifyProducts.get(request: request)
	}
	
	router.get("orders") { request -> Future<[ShopifyOrder]> in
		try ShopifyOrders.get(request: request)
	}
	
	try router.register(collection: ImperialController())
}

// where should this go?
extension ShopifyProduct: Content {}
extension ShopifyOrder: Content {}

extension ResourceContainer where Self: Decodable & ShopifyResource {
	static func get(request: Request) throws -> Future<[Resource]> {
		let api = try ShopifyAPI(session: request.session())
		return try api.get(resource: self, request: request).map { return $0.contents }
	}
}
