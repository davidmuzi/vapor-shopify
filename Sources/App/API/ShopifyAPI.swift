//
//  ProductsAPI.swift
//
//  Created by David Muzi on 2019-01-01.
//

import Foundation

enum ShopifyAPI {}

protocol ShopifyResource {
	static var path: String { get }
}

protocol ShopifyCreatableResource: ShopifyResource {
	static var identifier: String { get }
}

extension Array: ShopifyResource where Element: ShopifyResource {
	static var path: String { return Element.path }
}

protocol ResourceContainer {
	associatedtype Resource
	var contents: [Resource] { get }
}

typealias CodableResource = ShopifyResource & Codable

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
