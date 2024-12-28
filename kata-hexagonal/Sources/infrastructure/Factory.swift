actor Factory {
    private static let userRepository: UserRepository = InMemoryUserRepository()

    static func createUserRegisterService() -> UserRegisterService {
        return UserRegisterService(repository: userRepository)
    }

    static func createUserLoginService() -> UserLoginService {
        return UserLoginService(repository: userRepository)
    }

    static func createTokenProvider() async -> TokenProvider {
        return await JwtTokenProvider()
    }
}
