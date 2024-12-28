import Vapor

struct MeResponse: Content {
    let id: String
    let email: String
}

struct UserInfoController: RouteCollection {
    private let loginService = Factory.createUserLoginService()
    private let tokenProvider: TokenProvider

    init() async {
        self.tokenProvider = await Factory.createTokenProvider()
    }

    func boot(routes: any RoutesBuilder) throws {
        routes.grouped(UserAuthenticator())
            .get("me", use: me)
    }

    func me(req: Request) async throws -> MeResponse {
        let user = try req.auth.require(AuthUser.self)

        return MeResponse(id: user.id.toString(), email: "asdf")
    }
}
