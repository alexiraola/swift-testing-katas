import Vapor

struct RegisterRequest: Content {
    var email: String
    var password: String

    func toRequest() -> UserRegisterRequest {
        return UserRegisterRequest(email: email, password: password)
    }
}

struct RegisterResponse: Content {
    var id: String
    var email: String

    static func from(response: UserRegisterResponse) -> RegisterResponse {
        return RegisterResponse(id: response.id, email: response.email)
    }
}

extension UserRegisterError: AbortError {
    var reason: String {
        switch self {
        case .emailError:
            return "Invalid email"
        case .passwordError:
            return "Invalid password"
        case .alreadyExists:
            return "User already exists with these email"
        }
    }

    var status: HTTPStatus {
        return .badRequest
    }
}

struct UsersController: RouteCollection {
    private let registerService = Factory.createUserRegisterService()

    func boot(routes: any RoutesBuilder) throws {
        routes.post("register", use: register)
    }

    func register(req: Request) async throws -> RegisterResponse {
        let registerRequest = try req.content.decode(RegisterRequest.self)

        return try await registerService.register(registerRequest.toRequest()).map {
            RegisterResponse.from(response: $0)
        }.get()
    }
}
