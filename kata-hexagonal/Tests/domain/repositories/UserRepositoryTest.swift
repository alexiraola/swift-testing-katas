import Testing

@testable import KataHexagonal

@Suite("User repository") struct UserRepositoryTest {
    @Test("Finds a user by id")
    func findById() async {
        let id = UserId.generateUniqueIdentifier()
        let user = createUserById(id)
        let repository = InMemoryUserRepository()

        await repository.save(user: user)

        let result = await repository.find(by: id)

        #expect(result == .success(Optional.some(user)))
    }

    @Test("Does not find a non-existing user by id")
    func doesNotFind() async {
        let id = UserId.generateUniqueIdentifier()
        let repository = InMemoryUserRepository()
        let result = await repository.find(by: id)

        #expect(result == .success(.none))
    }

    @Test("Finds a user by email")
    func findByEmail() async {
        let email = try! Email.create(email: "test@example.com").get()
        let user = createUserByEmail(email)
        let repository = InMemoryUserRepository()

        await repository.save(user: user)

        let result = await repository.find(by: email)

        #expect(result == .success(Optional.some(user)))
    }

    @Test("Does not find a non-existing user by email")
    func doesNotFindByEmail() async {
        let email = try! Email.create(email: "test@example.com").get()
        let repository = InMemoryUserRepository()
        let result = await repository.find(by: email)

        #expect(result == .success(.none))
    }

    @Test("Finds all users")
    func findAll() async {
        let aUser = createUserByEmail(try! Email.create(email: "test1@example.com").get())
        let anotherUser = createUserByEmail(try! Email.create(email: "test2@example.com").get())
        let repository = InMemoryUserRepository()

        await repository.save(user: aUser)
        await repository.save(user: anotherUser)

        let result = await repository.findAll()
        let users = try! result.get()

        #expect(users.count == 2)
        #expect(users == [aUser, anotherUser])
    }

    @Test("Finds no users when repository is empty")
    func emptyRepository() async {
        let repository = InMemoryUserRepository()
        let result = await repository.findAll()
        let users = try! result.get()

        #expect(users.count == 0)
        #expect(users == [])
    }

    @Test("Removes a user")
    func removeUser() async {
        let repository = InMemoryUserRepository()
        let id = UserId.generateUniqueIdentifier()
        let user = createUserById(id)

        await repository.save(user: user)

        await repository.remove(user: user)

        let result = await repository.find(by: id)

        #expect(result == .success(.none))
    }

    @Test("Updates a user when it already exists")
    func updateUser() async {
        let aUser = createUserByEmail(try! Email.create(email: "test1@example.com").get())
        let anotherUser = aUser
        let repository = InMemoryUserRepository()

        await repository.save(user: aUser)
        await repository.save(user: anotherUser)

        let result = await repository.findAll()
        let users = try! result.get()

        #expect(users.count == 1)
        #expect(users == [aUser])
    }
}

func createUserById(_ id: UserId) -> User {
    let password = try! Password.create(fromPlaintext: "SecurePass123_").get()
    let email = try! Email.create(email: "test@example.com").get()
    return User(id: id, email: email, password: password)
}

func createUserByEmail(_ email: Email) -> User {
    let id = UserId.generateUniqueIdentifier()
    let password = try! Password.create(fromPlaintext: "SecurePass123_").get()
    return User(id: id, email: email, password: password)
}
