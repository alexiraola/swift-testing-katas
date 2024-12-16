actor Factory {
    private static let userRepository: UserRepository = InMemoryUserRepository()

    static func createUserRegisterService() -> UserRegisterService {
        return UserRegisterService(repository: userRepository)
    }
}
