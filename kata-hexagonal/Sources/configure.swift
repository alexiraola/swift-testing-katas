import Vapor

// configures your application
func configure(_ app: Application, repository: UserRepository) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app, repository: repository)
}
