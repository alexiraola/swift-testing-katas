enum UserRepositoryError: Error {
    case databaseError
}

protocol UserRepository {
    func save(user: User) async
    func find(by id: UserId) async -> Result<User?, UserRepositoryError>
    func find(by email: Email) async -> Result<User?, UserRepositoryError>
    func findAll() async -> Result<[User], UserRepositoryError>
    func remove(user: User) async
}

class InMemoryUserRepository: UserRepository {
    private var users: [User] = []

    func save(user: User) async {
        if let index = users.firstIndex(of: user) {
            users[index] = user
        } else {
            users.append(user)
        }
    }

    func find(by id: UserId) async -> Result<User?, UserRepositoryError> {
        return .success(users.first { $0.isMatchingId(id) })
    }

    func find(by email: Email) async -> Result<User?, UserRepositoryError> {
        return .success(users.first { $0.isMatchingEmail(email) })
    }

    func findAll() async -> Result<[User], UserRepositoryError> {
        return .success(users)
    }

    func remove(user: User) async {
        users.removeAll { $0 == user }
    }
}
