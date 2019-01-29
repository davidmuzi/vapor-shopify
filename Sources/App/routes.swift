import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }

	try router.register(collection: ProductsController())
	let imperial = ImperialController()
	try router.register(collection: imperial)
	
	
	let appGroup = router.grouped("app")
	let authController = OAuthController()
	authController.imperial = imperial
	try appGroup.register(collection: authController)

}
