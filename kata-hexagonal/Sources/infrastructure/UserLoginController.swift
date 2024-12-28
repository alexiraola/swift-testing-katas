import Vapor

struct LoginRequest: Content {
    let email: String
    let password: String

    func toRequest() -> UserLoginRequest {
        return UserLoginRequest(email: email, password: password)
    }
}

struct LoginResponse: Content {
    let token: String
}

extension UserLoginError: AbortError {
    var reason: String {
        switch self {
        case .emailError:
            return "Invalid email"
        case .passwordError:
            return "Invalid password"
        case .notFound:
            return "Invalid email or password"
        }
    }

    var status: HTTPStatus {
        return .badRequest
    }
}

struct UserLoginController: RouteCollection {
    private let loginService = Factory.createUserLoginService()
    private let tokenProvider: TokenProvider

    init() async {
        self.tokenProvider = await Factory.createTokenProvider()
    }

    func boot(routes: any RoutesBuilder) throws {
        routes.post("login", use: login)
    }

    func login(req: Request) async throws -> LoginResponse {
        let loginRequest = try req.content.decode(LoginRequest.self)

        let userId = try await loginService.login(loginRequest.toRequest()).map {
            $0.id
        }.get()

        let token = try await tokenProvider.sign(user: userId).get()

        return LoginResponse(token: token)
    }
}
