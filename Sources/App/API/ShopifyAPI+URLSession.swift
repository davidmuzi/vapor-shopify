//
//  ShopifyAPI+URLSession.swift
//  App
//
//  Created by David Muzi on 2019-01-10.
//

import Foundation

extension ShopifyAPI {

	class URLSession {
		
		private let session: Foundation.URLSession
		private let host: URL
		
		init(token: String, domain: String) {
			
			let config = URLSessionConfiguration.default
			config.httpAdditionalHeaders = ["X-Shopify-Access-Token": token,
											"Content-Type": "application/json; charset=utf-8"]
			self.session = Foundation.URLSession(configuration: config)
			
			self.host = URL(string: "https://\(domain)/admin/")!
		}

		func get<Q: QueryBuilder<R>, R: CodableResource>(query: Q, callback: @escaping (Q.Resource?) -> Void) {
			let url = host.appendingPathComponent(Q.Resource.path)
			var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
			components.queryItems = query.queryItems()
			
			session.dataTask(with: components.url!) { (data, response, error) in
				callback(self.decodeResource(data: data, error: error))
			}.resume()
		}
		
		func get<R: CodableResource>(resource: R.Type, callback: @escaping (R?) -> Void) {
			let url = host.appendingPathComponent(resource.path)

			session.dataTask(with: url) { (data, response, error) in
				callback(self.decodeResource(data: data, error: error))
			}.resume()
		}
		
		func post<R: Codable & ShopifyCreatableResource>(resource: R, callback: @escaping (R?) -> Void) throws {
			let url = host.appendingPathComponent(R.path)
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			
			let encoder = JSONEncoder()
			if #available(OSX 10.12, *) {
				encoder.dateEncodingStrategy = .iso8601
			} else {
				// Fallback on earlier versions
			}
			
			request.httpBody = try encoder.encode([R.identifier: resource])
			
			session.dataTask(with: request) { (data, response, error) in
				guard let data = data, error == nil else { return callback(nil) }
				typealias Container = [String: R]
				
				let decoder = JSONDecoder()
				if #available(OSX 10.12, *) {
					decoder.dateDecodingStrategy = .iso8601
				} else {
					// Fallback on earlier versions
				}
				
				let contained = try! decoder.decode(Container.self, from: data)
				callback(contained[R.identifier]!)
			}.resume()
		}
		
		private func decodeResource<R: Codable>(data: Data?, error: Error?) -> R? {
			guard let data = data, error == nil else { return nil }
			return try! JSONDecoder().decode(R.self, from: data)
		}
	}

}
