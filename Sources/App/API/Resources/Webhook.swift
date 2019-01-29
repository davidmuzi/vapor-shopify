import Foundation

struct Webhook: Codable {
	let topic: String
	let address: String
	let format = "json"
	let id: Int?
}

extension Webhook: ShopifyResource {
	var path: String { return "delete_me.json" }
}


extension Webhook: ShopifyCreatableResource {
	static var path: String { return "webhooks" }
	static var identifier: String { return "webhook" }
}

struct Webhooks: Codable {
	let webhooks: [Webhook]
}

extension Webhooks: ResourceContainer {
	var contents: [Webhook] { return webhooks }
}

extension Webhooks: Queryable {
	enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		case topic(String)
		
		func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim): return URLQueryItem(name: "limit", value: "\(lim)")
			case .page(let page): return URLQueryItem(name: "page", value: "\(page)")
			case .topic(let topic): return URLQueryItem(name: "topic", value: "\(topic)")
			}
		}
	}
}
