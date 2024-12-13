enum UserRegisterError: Error, Equatable {
    case emailError(EmailError)
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
            return .failure(.emailError(.invalid))
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
        let password = Password.create(fromPlaintext: request.password).mapError {
            UserRegisterError.passwordError($0)
        }
        let email = Email.createResult(email: request.email).mapError {
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
