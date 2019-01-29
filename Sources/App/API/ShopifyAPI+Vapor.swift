//
//  ShopifyAPI+Vapor.swift
//  App
//
//  Created by David Muzi on 2019-01-10.
//

import Vapor

extension ShopifyAPI {

	class Vapor {
		private let session: Session
		private let host: URL
		
		init(session: Session) throws {
			self.session = session
			let domain = session["shop_domain"]!
			self.host = URL(string: "https://\(domain)/admin/")!
		}
	}
}

extension Request {
	func shopifyHeader() throws -> HTTPHeaders {
		return HTTPHeaders([("X-Shopify-Access-Token", try accessToken())])
	}
}

extension ResourceContainer where Resource: CodableResource, Self: Decodable {
	static func get(request: Request) throws -> Future<[Resource]> {
		let api = try ShopifyAPI.Vapor(session: request.session())
		return try api.get(resource: self, request: request).map { return $0.contents }
	}
}

extension ShopifyAPI.Vapor {
	
	func get<R: ResourceContainer & Decodable>(resource: R.Type, request: Request) throws -> Future<R> {
		
		let url = host.appendingPathComponent(R.Resource.path)
			.appendingPathExtension("json")
		
		return try request
			.client()
			.get(url, headers: try request.shopifyHeader())
			.map(to: R.self) { response in
				guard response.http.status == .ok else { throw Abort(response.http.status) }
				return try response.content.syncDecode(R.self)
		}
	}
	
	func post<R: ShopifyCreatableResource & Content>(resource: R, request: Request) throws -> Future<R> {
		
		let url = host.appendingPathComponent(R.path)
			.appendingPathExtension("json")
		
		return try request
			.client()
			.post(url, headers: try request.shopifyHeader()) { post in
				let dict = [R.identifier: resource]
				
				try post.content.encode(dict)
			}
			.map(to: R.self) { response in
				guard response.http.status == .created else { throw Abort(.internalServerError) }
				
				typealias Container = [String: R]
				let contained = try response.content.syncDecode(Container.self)
				
				return contained[R.identifier]!
		}
	}
}

extension Product: Content {}
extension Order: Content {}
extension MarketingEvent: Content {}
