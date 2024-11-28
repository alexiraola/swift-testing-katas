import Testing

@testable import KataHexagonal

@Suite("Email") struct EmailTest {
    @Test("Creates an email for a given address in a correct format")
    func testEmail() {
        let email = Email.create(email: "example@example.com")
        #expect(email != nil)
    }

    @Test("Does not allow creating an email for a given incorrectly formatted address")
    func testInvalid() {
        let email = Email.create(email: "invalid")
        #expect(email == nil)
    }

    @Test("Considers two emails with the same address as equal")
    func testEqual() {
        let aEmail = Email.create(email: "example@example.com")
        let otherEmail = Email.create(email: "example@example.com")

        #expect(aEmail == otherEmail)
    }

    @Test("Differentiates between two emails with different address")
    func testNotEqual() {
        let aEmail = Email.create(email: "example@example.com")
        let otherEmail = Email.create(email: "anotherexample@example.com")

        #expect(aEmail != otherEmail)
    }
}
