//
//  ImperialController.swift
//  App
//
//  Created by David Muzi on 2018-12-27.
//

import Vapor
import Imperial
import Authentication

struct ImperialController {

}

extension ImperialController: RouteCollection {
	func boot(router: Router) throws {
		guard let callbackURL = Environment.get("SHOPIFY_CALLBACK_URL") else { fatalError("Callback not set") }

		try router.oAuth(from: Shopify.self,
						 authenticate: "login-shopify",
						 callback: callbackURL,
						 scope: ["read_products", "read_orders"],
						 redirect: "/products")
	}
	
}
