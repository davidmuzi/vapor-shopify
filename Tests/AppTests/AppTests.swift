//
//  AppTests.swift
//  AppTests
//
//  Created by David Muzi on 2019-01-08.
//

import XCTest
@testable import App

class AppTests: XCTestCase {

	let token = ProcessInfo.processInfo.environment["token"]!
	var session: ShopifyAPI.URLSession!
	
    override func setUp() {
		session = ShopifyAPI.URLSession(token: token, domain: "davidmuzi.myshopify.com")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		let expected = expectation(description: "")

		session.get(resource: Products.self) { result in
			XCTAssertEqual("Error Pinterest Product", result?.products.first?.title)
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)

    }
	
	func testQueryItem() {
		let items = QueryBuilder<Products>()
			.addQuery(.limit(5))
			.addQuery(.page(2))
		
		let expected = expectation(description: "")
		
		session.get(query: items) { (result) in
			XCTAssertEqual(5, result?.contents.count)
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testOrderQueryItem() {
		let items = QueryBuilder<Orders>()
			.addQuery(.limit(5))
			.addQuery(.page(2))
		
		let expected = expectation(description: "")
		
		session.get(query: items) { (result) in
			XCTAssertEqual(5, result?.contents.count)
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testMarketingEvent() {
		let expected = expectation(description: "")

		let marketingEvent = MarketingEvent(
			id: nil,
			description: "data.description",
			eventType: .ad,
			marketingChannel: .social,
			paid: true,
			startedAt: Date()
		)
		
		try! session.post(resource: marketingEvent) { (resource) in
			XCTAssertNotEqual(resource?.id, 0)
			expected.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)

	}

}
