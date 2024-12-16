import Vapor

struct LoginRequest: Content {
    var email: String
    var password: String

    func toRequest() -> UserLoginRequest {
        return UserLoginRequest(email: email, password: password)
    }
}

struct LoginResponse: Content {
    var id: String
    var email: String

    static func from(response: UserLoginResponse) -> LoginResponse {
        return LoginResponse(id: response.id, email: response.email)
    }
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

    func boot(routes: any RoutesBuilder) throws {
        routes.post("login", use: login)
    }

    func login(req: Request) async throws -> LoginResponse {
        let loginRequest = try req.content.decode(LoginRequest.self)

        return try await loginService.login(loginRequest.toRequest()).map {
            LoginResponse.from(response: $0)
        }.get()
    }
}
