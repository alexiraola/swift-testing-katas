enum UserLoginError: Error, Equatable {
    case emailError(EmailError)
    case passwordError(PasswordError)
    case notFound
}

struct UserLoginRequest {
    let email: String
    let password: String
}

struct UserLoginResponse: Equatable {
    let id: String
    let email: String

    static func from(dto: UserDto) -> UserLoginResponse {
        return UserLoginResponse(id: dto.id, email: dto.email)
    }
}

class UserLoginService {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func login(_ request: UserLoginRequest) async -> Result<
        UserLoginResponse, UserLoginError
    > {
        let email = Email.create(email: request.email)
        let password = Password.create(fromPlaintext: request.password)

        if case let .failure(error) = email {
            return .failure(.emailError(error))
        }

        if case let .failure(error) = password {
            return .failure(.passwordError(error))
        }

        let user = await repository.find(by: try! email.get())

        switch user {
        case .success(let user):
            if let u = user {
                return .success(UserLoginResponse.from(dto: u.toDto()))
            }
            return .failure(.notFound)
        default:
            return .failure(.notFound)
        }
    }
}
