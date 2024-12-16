class Factory {
    private static var userRepository: UserRepository = InMemoryUserRepository()

    static func createUserRegisterService() -> UserRegisterService {
        return UserRegisterService(repository: userRepository)
    }
}
