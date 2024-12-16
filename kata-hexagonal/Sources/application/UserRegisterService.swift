enum UserRegisterError: Error, Equatable {
    case emailError(EmailError)
    case passwordError(PasswordError)
    case alreadyExists
}

struct UserRegisterRequest {
    let email: String
    let password: String
}

struct UserRegisterResponse: Equatable {
    let id: String
    let email: String

    static func from(dto: UserDto) -> UserRegisterResponse {
        return UserRegisterResponse(id: dto.id, email: dto.email)
    }
}

class UserRegisterService {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func register(_ request: UserRegisterRequest) async -> Result<
        UserRegisterResponse, UserRegisterError
    > {
        let email = Email.create(email: request.email)

        if case let .failure(error) = email {
            return .failure(.emailError(error))
        }

        if await existsUser(email: try! email.get()) {
            return .failure(.alreadyExists)
        }

        let userResult = createUser(request: request)

        switch userResult {
        case .success(let user):
            await repository.save(user: user)
            return .success(UserRegisterResponse.from(dto: user.toDto()))
        case .failure(let error):
            return .failure(error)
        }
    }

    private func createUser(request: UserRegisterRequest) -> Result<User, UserRegisterError> {
        let password = Password.create(fromPlaintext: request.password).mapError {
            UserRegisterError.passwordError($0)
        }
        let email = Email.create(email: request.email).mapError {
            UserRegisterError.emailError($0)
        }

        return email.flatMap { email in
            return password.map { password in
                return User(id: UserId.generateUniqueIdentifier(), email: email, password: password)
            }
        }
    }

    private func existsUser(email: Email) async -> Bool {
        let result = await repository.find(by: email)

        if case let .success(user) = result, user != nil {
            return true
        }
        return false
    }
}
