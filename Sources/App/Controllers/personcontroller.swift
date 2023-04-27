import Vapor

final class PersonController {
    static var people = [
        Person(id: UUID(uuidString: "ea6e7347-9cf3-4b57-b5ef-4d042b22e4fa")!, firstName: "Jane", lastName: "Doe", gender: .female, age: 25, address: Address(streetAddress: "123 Main Street", city: "Mobile", state: "AL", postalCode: "36695"), phoneNumbers: [PhoneNumber(type: .home, number: "2519897878")]),
        Person(id: UUID(uuidString: "e42c43e4-2ee3-4e41-9ca1-a9550e0a7738")!, firstName: "John", lastName: "Smith", gender: .male, age: 28, address: Address(streetAddress: "123 Anywhere Street", city: "Mobile", state: "AL", postalCode: "36695"), phoneNumbers: [PhoneNumber(type: .home, number: "2519897890")]),
        Person(id: UUID(uuidString: "e6b5fb5c-2e25-4057-a17c-a96ad4075e2a")!, firstName: "Bubba", lastName: "Jones", gender: .male, age: 35, address: Address(streetAddress: "123 Main Street", city: "Birmingham", state: "AL", postalCode: "35502"), phoneNumbers: [PhoneNumber(type: .home, number: "2059897878")]),
        Person(id: UUID(uuidString: "656652e5-3892-4c3d-a3e0-3d198ff79559")!, firstName: "Joe", lastName: "Johnson", gender: .female, age: 29, address: Address(streetAddress: "123 Anywhere Street", city: "Birmingham", state: "AL", postalCode: "35146"), phoneNumbers: [PhoneNumber(type: .home, number: "2059897800")])
    ]

    func getPeople(req: Request) -> [Person] {
        return Self.people
    }

    func getPerson(req: Request) throws -> Person {
        guard 
            let personIDString = req.parameters.get("personID"),

            let personID = UUID(uuidString: personIDString),

            let person = Self.people.first(where: {$0.id == personID})

        else {
            throw Abort(.notFound)
        }            

        return person
    }

    func updatePerson(req: Request) throws -> Bool {
        do {
            let decoder = JSONDecoder()
            let personData = Data(req.body.description.utf8)
            let person = try decoder.decode(Person.self, from: personData)

            if let i = Self.people.firstIndex(of: person) {
                Self.people[i] = person
                return true
            } else {
                return false
            }

        } catch {
            req.logger.error("error decoding person")
            throw Abort(.badRequest)
        }
    }

    func addPerson(req: Request) throws -> Bool {
        do {
            let decoder = JSONDecoder()
            let personData = Data(req.body.description.utf8)
            let person = try decoder.decode(Person.self, from: personData)

            if let i = Self.people.firstIndex(of: person) {
                req.logger.info("person already exists")
                return false
            } else {
                Self.people.append(person)
                return true
            }

        } catch {
            req.logger.error("error decoding person")
            throw Abort(.badRequest)
        }
    }

    func deletePerson(req: Request) throws -> Bool {
        guard 
            let personIDString = req.parameters.get("personID"),

            let personID = UUID(uuidString: personIDString)

        else {
            throw Abort(.notFound)
        }            

        Self.people.removeAll(where: {$0.id == personID})
        
        return true
    }

}

extension PersonController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: getPeople)
        routes.get(":personID", use: getPerson)
        routes.put("update", use: updatePerson)
        routes.post("add", use: addPerson)
        routes.delete(["delete", ":personID"], use: deletePerson)
    }
}