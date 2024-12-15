import Vapor

func routes(_ app: Application, repository: UserRepository) throws {
    app.get { req async in
        "It works!"
    }

    try app.register(
        collection: UsersController(registerService: UserRegisterService(repository: repository)))
}
