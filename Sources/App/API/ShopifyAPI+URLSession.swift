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
		config.httpAdditionalHeaders = ["X-Shopify-Access-Token": token]
		self.session = URLSession(configuration: config)
		
		self.host = URL(string: "https://\(domain)/admin/")!
	}
	
	func get<R: ShopifyResource & Decodable>(resource: R.Type, callback: @escaping (R?) -> Void) {
		let url = host.appendingPathComponent(resource.path)

		session.dataTask(with: url) { (data, response, error) in
			guard let data = data, error == nil else { return callback(nil) }
			let res = try! JSONDecoder().decode(R.self, from: data)
			callback(res)
		}.resume()
	}
}

