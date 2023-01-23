import Vapor
import telegram_vapor_bot

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
   // app.http.server.configuration.hostname = "0.0.0.0"
// app.http.server.configuration.port = 80
    
    let tgApi: String = "5951973965:AAEMXR0lBME7ZAs6juVZUyoe9rBeiNNrD48"
    let connection: TGConnectionPrtcl = TGLongPollingConnection()
    TGBot.configure(connection: connection, botId: tgApi, vaporClient: app.client)
    try TGBot.shared.start()
    TGBot.log.logLevel = .error
    DefaultBotHandlers.addHandlers(app: app, bot: TGBot.shared)
    
    // register routes
    try routes(app)
}
