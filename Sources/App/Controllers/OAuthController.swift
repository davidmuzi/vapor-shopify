//
//  OAuthController.swift
//  App
//
//  Created by David Muzi on 2019-01-25.
//

import Vapor
import Imperial

class OAuthController {
	
	var imperial: ImperialController!
	
	func redirectToScheme(_ req: Request) throws -> Future<Response> {
		
		var comps = URLComponents(url: req.http.url, resolvingAgainstBaseURL: false)!
		comps.scheme = "shop"
		comps.host = "auth"

		let redirect: Response = req.redirect(to: comps.url!.absoluteString, type: .temporary)
		return req.eventLoop.newSucceededFuture(result: redirect)
	}
	
	func fetchToken(_ req: Request) throws -> Future<String> {
		return try imperial.shopifyRouter.shopifyRouter.fetchToken(from: req)
	}
	
}

extension OAuthController: RouteCollection {
	func boot(router: Router) throws {
		
		router.get("redirect", use: redirectToScheme)
		router.get("fetch_token", use: fetchToken)
	}
		
}
