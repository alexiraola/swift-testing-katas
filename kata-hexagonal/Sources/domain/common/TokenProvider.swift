enum TokenError: Error {
    case invalidToken(Error)
    case signError(Error)
}

protocol TokenProvider {
    func sign(user: String) async -> Result<String, TokenError>
    func verify(token: String) async -> Result<String, TokenError>
}
