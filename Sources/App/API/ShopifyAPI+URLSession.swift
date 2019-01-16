//
//  ShopifyAPI+URLSession.swift
//  App
//
//  Created by David Muzi on 2019-01-10.
//

import Foundation

class ShopifySessionAPI {
	
	private let session: URLSession
	private let host: URL
	
	init(token: String, domain: String) {
		
		let config = URLSessionConfiguration.default
		config.httpAdditionalHeaders = ["X-Shopify-Access-Token": token,
										"Content-Type": "application/json; charset=utf-8"]
		self.session = URLSession(configuration: config)
		
		self.host = URL(string: "https://\(domain)/admin/")!
	}
	
	func get<R: CodableResource>(resource: R.Type, callback: @escaping (R?) -> Void) {
		let url = host.appendingPathComponent(resource.path)

		session.dataTask(with: url) { (data, response, error) in
			guard let data = data, error == nil else { return callback(nil) }
			let res = try! JSONDecoder().decode(R.self, from: data)
			callback(res)
		}.resume()
	}
	
	func post<R: Codable & ShopifyCreatableResource>(resource: R, callback: @escaping (R?) -> Void) throws {
		let url = host.appendingPathComponent(R.path)
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		
		let encoder = JSONEncoder()
		//encoder.dateEncodingStrategy = .iso8601
		
		request.httpBody = try encoder.encode([R.identifier: resource])
		
		session.dataTask(with: request) { (data, response, error) in
			guard let data = data, error == nil else { return callback(nil) }
			let res = try! JSONDecoder().decode(R.self, from: data)
			callback(res)
		}.resume()
	}
}

