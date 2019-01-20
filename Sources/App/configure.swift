import FluentSQLite
import Vapor
import Leaf
import Logging

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())
	services.register(PrintLogger(), as: Logger.self)

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
	middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    let migrations = MigrationConfig()
    services.register(migrations)

	try services.register(LeafProvider())
	
	config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
	
	config.prefer(LeafRenderer.self, for: ViewRenderer.self)
	

}
