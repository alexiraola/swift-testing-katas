import Testing

@testable import KataHexagonal

@Suite("The User") struct UserTest {
    @Test("Changes the password when a different one is provided")
    func changePassword() {
        let initialPassword = try! Password.create(fromPlaintext: "SafePass123_").get()
        let user = createUser(password: initialPassword)
        let newPassword = try! Password.create(fromPlaintext: "AnotherSafePass123_").get()

        let result = user.changePassword(with: newPassword)

        #expect(result == .success(EquatableVoid()))
        #expect(user.isMatchingPassword(newPassword))
    }

    @Test("Does not allow to change the password when the given one is the same")
    func changePasswordSame() {
        let initialPassword = try! Password.create(fromPlaintext: "SafePass123_").get()
        let user = createUser(password: initialPassword)

        let result = user.changePassword(with: initialPassword)

        #expect(result == .failure(UserError.samePassword))
    }
}

func createUser(password: Password) -> User {
    return User(
        id: UserId.generateUniqueIdentifier(),
        email: try! Email.create(email: "test@example.com").get(),
        password: password
    )
}
