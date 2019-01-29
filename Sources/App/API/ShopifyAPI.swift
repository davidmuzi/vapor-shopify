//
//  ProductsAPI.swift
//
//  Created by David Muzi on 2019-01-01.
//

import Foundation

enum ShopifyAPI {}

protocol ShopifyResource {
	var id: Int? { get }
	static var path: String { get }
}

protocol ResourceContainer {
	associatedtype Resource: ShopifyResource
	var contents: [Resource] { get }
}

protocol ShopifyCreatableResource {
	static var path: String { get }
	static var identifier: String { get }
}

typealias CodableResource = ShopifyResource & Codable

// MARK: - Query Support

protocol Queryable {
	associatedtype Query: QueryItemConvertable
}

protocol QueryItemConvertable {
	func queryItem() -> URLQueryItem
}

class QueryBuilder<Q: Queryable> {
	
	typealias Resource = Q
	
	private var _queryItems = [Q.Query]()
	
	func addQuery(_ item: Q.Query) -> QueryBuilder {
		_queryItems.append(item)
		return self
	}
	
	func queryItems() -> [URLQueryItem] {
		return _queryItems.map{ $0.queryItem() }
	}
}
