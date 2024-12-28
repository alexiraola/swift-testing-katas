import Vapor

struct AuthUser: Authenticatable {
    let id: UserId
}

struct UserAuthenticator: AsyncBearerAuthenticator {
    func authenticate(
        bearer: BearerAuthorization,
        for request: Request
    ) async throws {
        let tokenProvider = await Factory.createTokenProvider()
        let id = try await tokenProvider.verify(token: bearer.token).get()
        let userId = try UserId.create(from: id).get()

        request.auth.login(AuthUser(id: userId))
    }
}
