//
//  ProductsAPI.swift
//
//  Created by David Muzi on 2019-01-01.
//

import Foundation
import Vapor

protocol ShopifyResource {
	static var path: String { get }
}

extension Array: ShopifyResource where Element: ShopifyResource {
	static var path: String { return Element.path }
}

class ShopifyAPI {
	private let session: Session
	private let host: URL
	
	init(session: Session) throws {
		self.session = session
		let domain = try session.shopDomain()
		self.host = URL(string: "https://\(domain)/admin/")!
	}
	
	func get<R: ShopifyResource & Decodable>(resource: R.Type, request: Request) throws -> Future<R> {
		
		let url = host.appendingPathComponent(resource.path)
		let headers = HTTPHeaders([("X-Shopify-Access-Token", try request.accessToken())])
		
		return try request
			.client()
			.get(url, headers: headers)
			.map(to: R.self) { response in
			
			guard response.http.status == .ok else { throw Abort(.internalServerError) }
			return try response.content.syncDecode(R.self)
		}
	}
}
