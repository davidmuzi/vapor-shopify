import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
	
	router.get("products.json") { request -> Future<[Product]> in
		try Products.get(request: request)
	}
	
	router.get("orders.json") { request -> Future<[Order]> in
		try Orders.get(request: request)
	}
	
	router.get("products", use: ProductsController().showProducts)
	
	try router.register(collection: ImperialController())
}

