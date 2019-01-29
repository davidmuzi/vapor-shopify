import Foundation

struct MarketingEvents: Codable {
	enum CodingKeys: String, CodingKey {
		case marketingEvents = "marketing_events"
	}
	
	let marketingEvents: [MarketingEvent]
}

struct MarketingEvent: Codable {
	enum EventType: String, Codable {
		case ad
		case post
		case message
		case retargeting
		case affiliate
		case loyalty
		case newsletter
		case abandonedCart = "abandoned_cart"
	}
	
	enum MarketingChannel: String, Codable {
		case search
		case display
		case social
		case email
		case referral
	}
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case description = "description"
		case eventType = "event_type"
		case marketingChannel = "marketing_channel"
		case paid = "paid"
		case startedAt = "started_at"
	}
	
	let id: Int?
	let description: String
	let eventType: EventType
	let marketingChannel: MarketingChannel
	let paid: Bool
	let startedAt: Date
}

extension MarketingEvents: ResourceContainer {
	var contents: [MarketingEvent] { return marketingEvents }
}

extension MarketingEvent: ShopifyCreatableResource {
	static var path: String { return "marketing_events" }
	static var identifier = "marketing_event"
}

extension MarketingEvent: ShopifyResource {}
