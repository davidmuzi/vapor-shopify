import Vapor
import Imperial

extension Session {
    
    func shopDomain() throws -> String {
        guard let domain = self["shop_domain"] else { throw Abort(.notFound) }
        return domain
    }
    
    func setShopDomain(_ domain: String) {
        self["shop_domain"] = domain
    }
    
    func setNonce(_ nonce: String?) {
        self["nonce"] = nonce
    }
    
    func nonce() -> String? {
        return self["nonce"]
    }
}
