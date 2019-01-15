import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
	
	router.get("products") { request -> Future<[Product]> in
		try Products.get(request: request)
	}
	
	router.get("orders") { request -> Future<[Order]> in
		try Orders.get(request: request)
	}
	
	try router.register(collection: ImperialController())
}

