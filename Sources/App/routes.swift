import Vapor

func routes(_ app: Application) throws {
    let personController = PersonController()

    let apiRoutes = app.grouped("api", "v1")
    try apiRoutes.grouped("persons").register(collection: personController)
}
