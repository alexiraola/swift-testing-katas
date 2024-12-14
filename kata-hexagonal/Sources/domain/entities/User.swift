enum UserError: Error {
    case samePassword
}

struct UserDto {
    let id: String
    let email: String
}

class User: Equatable {

    private let id: UserId
    private let email: Email
    private var password: Password

    init(id: UserId, email: Email, password: Password) {
        self.id = id
        self.email = email
        self.password = password
    }

    func changePassword(with newPassword: Password) -> Result<EquatableVoid, UserError> {
        if password == newPassword {
            return .failure(.samePassword)
        }
        self.password = newPassword
        return .success(EquatableVoid())
    }

    func isMatchingId(_ id: UserId) -> Bool {
        return self.id == id
    }

    func isMatchingEmail(_ email: Email) -> Bool {
        return self.email == email
    }

    func isMatchingPassword(_ password: Password) -> Bool {
        return self.password == password
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.isMatchingId(rhs.id)
    }

    func toDto() -> UserDto {
        return UserDto(id: id.toString(), email: email.toString())
    }
}
