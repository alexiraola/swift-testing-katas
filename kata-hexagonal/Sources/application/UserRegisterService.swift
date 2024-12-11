enum UserRegisterError: Error, Equatable {
    case emailError
    case passwordError(PasswordError)
    case alreadyExists
}

struct UserRegisterRequest {
    let email: String
    let password: String
}

class UserRegisterService {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func register(_ request: UserRegisterRequest) async -> Result<EquatableVoid, UserRegisterError>
    {
        guard let email = Email.create(email: request.email) else {
            return .failure(.emailError)
        }

        if await existsUser(email: email) {
            return .failure(.alreadyExists)
        }

        let userResult = createUser(request: request)

        switch userResult {
        case .success(let user):
            await repository.save(user: user)
            return .success(EquatableVoid())
        case .failure(let error):
            return .failure(error)
        }
    }

    private func createUser(request: UserRegisterRequest) -> Result<User, UserRegisterError> {
        guard let email = Email.create(email: request.email) else {
            return .failure(.emailError)
        }

        return Password.create(fromPlaintext: request.password).map { password in
            return User(id: UserId.generateUniqueIdentifier(), email: email, password: password)
        }.mapError { .passwordError($0) }
    }

    private func existsUser(email: Email) async -> Bool {
        let result = await repository.find(by: email)

        if case let .success(user) = result, user != nil {
            return true
        }
        return false
    }
}
