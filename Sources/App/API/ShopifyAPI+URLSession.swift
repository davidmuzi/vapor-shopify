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

		func get<Q: QueryBuilder<R>, R: ResourceContainer>(query: Q, callback: @escaping (Q.Resource?) -> Void) where R: Decodable {
			let url = host.appendingPathComponent(Q.Resource.Resource.path).appendingPathExtension("json")
			var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
			components.queryItems = query.queryItems()
			decodeResource(url: components.url!, callback: callback)
		}
		
		func get<R: ResourceContainer>(resource: R.Type, callback: @escaping (R?) -> Void) where R: Decodable {
			let url = host.appendingPathComponent(R.Resource.path).appendingPathExtension("json")
			decodeResource(url: url, callback: callback)
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
				guard let data = data, data.count > 0, error == nil else { return callback(nil) }
				typealias Container = [String: R]
				
				let decoder = JSONDecoder()
				if #available(OSX 10.12, *) {
					decoder.dateDecodingStrategy = .iso8601
				} else {
					// Fallback on earlier versions
				}
				
				if let contained = try? decoder.decode(Container.self, from: data), let contents = contained[R.identifier] {
					callback(contents)
				} else { callback(nil) }
			}.resume()
		}
		
		func delete<R: ShopifyResource>(resource: R, callback: @escaping (Error?) -> Void) throws {
			guard let id = resource.id else { return }
			let url = host.appendingPathComponent(R.path)
				.appendingPathComponent("\(id)")
				.appendingPathExtension("json")
			
			var request = URLRequest(url: url)
			request.httpMethod = "DELETE"
			
			session.dataTask(with: request) { (data, response, error) in
				if let error = error { return callback(error) }
				guard let r = response as? HTTPURLResponse, r.statusCode == 200 else { return callback(BadResponse()) }
				callback(nil)
				}.resume()
		}
		
		private func decodeResource<R: Decodable>(url: URL, callback: @escaping (R?) -> Void) {
			session.dataTask(with: url) { (data, response, error) in
				guard let data = data, error == nil else { return callback(nil) }
				callback(try! JSONDecoder().decode(R.self, from: data))
				}.resume()
		}
	}
}

private struct BadResponse: Error { }
