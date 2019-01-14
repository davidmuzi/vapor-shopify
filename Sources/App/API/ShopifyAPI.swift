//
//  ProductsAPI.swift
//
//  Created by David Muzi on 2019-01-01.
//

import Foundation

protocol ShopifyResource {
	static var path: String { get }
}

extension Array: ShopifyResource where Element: ShopifyResource {
	static var path: String { return Element.path }
}

protocol ResourceContainer {
	associatedtype Resource
	var contents: [Resource] { get }
}
