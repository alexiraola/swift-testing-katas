import JWTKit

class JwtTokenProvider: TokenProvider {
    private let keys = JWTKeyCollection()

    init() async {
        await keys.add(hmac: "secret", digestAlgorithm: .sha256)
    }

    func sign(user: String) async -> Result<String, TokenError> {
        let payload = UserPayload(
            subject: SubjectClaim.init(value: user), expiration: .init(value: .distantFuture))

        do {
            return try await .success(keys.sign(payload))
        } catch {
            return .failure(.signError(error))
        }
    }

    func verify(token: String) async -> Result<String, TokenError> {
        do {
            let payload = try await keys.verify(token, as: UserPayload.self)

            return .success(payload.subject.value)
        } catch {
            return .failure(.invalidToken(error))
        }
    }
}

struct UserPayload: JWTPayload {
    // Maps the longer Swift property names to the
    // shortened keys used in the JWT payload.
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
    }

    // The "sub" (subject) claim identifies the principal that is the
    // subject of the JWT.
    var subject: SubjectClaim

    // The "exp" (expiration time) claim identifies the expiration time on
    // or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim

    // Run any additional verification logic beyond
    // signature verification here.
    // Since we have an ExpirationClaim, we will
    // call its verify method.
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }
}
