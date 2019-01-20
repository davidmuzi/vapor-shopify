// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VaporShop",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
		.package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc"),
		.package(url: "https://github.com/vapor-community/Imperial.git", from: "0.8.0"),
		.package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc"),
		.package(url: "https://github.com/vapor/console.git", from: "3.0.0")
	],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor", "Authentication", "Imperial", "Leaf", "Logging"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

