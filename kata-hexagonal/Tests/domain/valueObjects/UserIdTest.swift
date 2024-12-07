import Foundation
import Testing

@testable import KataHexagonal

@Suite("Id") struct IdTest {
    @Test("Generates a valid identifier")
    func valid() {
        let id = UserId.generateUniqueIdentifier()

        #expect(isValidUuid(id))
    }

    @Test("Creates an ID from a given valid identifier")
    func createFromString() {
        let validId = UUID().uuidString
        let id = UserId.create(from: validId)

        #expect(id.map { $0.toString() } == .success(validId))
    }

    @Test("Does not allow to create an ID from a given invalid identifier")
    func invalid() {
        let invalidId = "invalid-id"
        let id = UserId.create(from: invalidId)

        #expect(id == .failure(.invalidFormat))
    }

    @Test("Identifies two identical identifiers as equal")
    func equals() {
        let validId = UUID().uuidString
        let id1 = UserId.create(from: validId)
        let id2 = UserId.create(from: validId)

        #expect(id1 == id2)
    }

    @Test("Identifies two different identifiers as not equal")
    func notEquals() {
        let id1 = UserId.create(from: UUID().uuidString)
        let id2 = UserId.create(from: UUID().uuidString)

        #expect(id1 != id2)
    }
}

func isValidUuid(_ id: UserId) -> Bool {
    let regex =
        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
    let predicate = NSPredicate { evaluatedObject, _ in
        guard let text = evaluatedObject as? String else { return false }
        return text.range(of: regex, options: .regularExpression) != nil
    }
    return predicate.evaluate(with: id.toString())
}
