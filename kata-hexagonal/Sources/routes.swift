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

func routes(_ app: Application, repository: UserRepository) throws {
    let registerService = UserRegisterService(repository: repository)

    app.get { req async in
        "It works!"
    }

    app.post("register") { req async throws -> RegisterResponse in
        let registerRequest = try req.content.decode(RegisterRequest.self)

        return try await registerService.register(registerRequest.toRequest()).map {
            RegisterResponse.from(response: $0)
        }.get()
    }
}
