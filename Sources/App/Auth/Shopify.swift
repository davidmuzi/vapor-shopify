import Vapor
import Imperial

public class Shopify: FederatedService {
    
    public var tokens: FederatedServiceTokens {
        return self.router.tokens
    }
    
    public var router: FederatedServiceRouter {
        return shopifyRouter
    }
    
    public var shopifyRouter: ShopifyRouter
    
    public required init(router: Router,
                         authenticate: String,
                         callback: String,
                         scope: [String],
                         completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        
        self.shopifyRouter = try ShopifyRouter(callback: callback, completion: completion)
        self.shopifyRouter.scope = scope
        
        try self.router.configureRoutes(withAuthURL: authenticate, on: router)
    }
}
