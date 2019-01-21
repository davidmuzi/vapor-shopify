//
//  AuthenticationMiddleware.swift
//  App
//
//  Created by David Muzi on 2019-01-18.
//

import Vapor

class AuthenticationMiddleware: Middleware {
	func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
		guard (try? request.accessToken()) != nil else {
			
			let com = URLComponents(url: request.http.url, resolvingAgainstBaseURL: false)!
			let shop = com.queryItems!.first{ $0.name == "shop"}!.value!
			
			return request.future(request.redirect(to: "/begin_auth?shop=\(shop)"))
		}
		
		return try next.respond(to: request)
	}
}
