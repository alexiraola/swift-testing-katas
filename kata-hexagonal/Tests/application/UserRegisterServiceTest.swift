import Testing

@testable import KataHexagonal

@Suite("The User Registration Service")
struct UserRegisterServiceTest {
    @Test("Registers a new user successfully when given credentials are valid")
    func registerUser() async {
        let repository = InMemoryUserRepository()
        let service = UserRegisterService(repository: repository)

        let _ = await service.register(createRegisterRequest())
        let expectedEmail = Email.create(email: createRegisterRequest().email)!
        let result = await repository.find(by: expectedEmail)

        let foundUser = try! result.get()!

        #expect(foundUser.isMatchingEmail(expectedEmail))
    }

    @Test(
        "Does not allow to register a new user when another one with the same email already exists")
    func emailExists() async {
        let repository = InMemoryUserRepository()
        let service = UserRegisterService(repository: repository)

        let _ = await service.register(createRegisterRequest())
        let result = await service.register(createRegisterRequest())

        #expect(result == .failure(.alreadyExists))
    }
}

func createRegisterRequest() -> UserRegisterRequest {
    return UserRegisterRequest(email: "test@example.com", password: "TestPassword123_")
}
