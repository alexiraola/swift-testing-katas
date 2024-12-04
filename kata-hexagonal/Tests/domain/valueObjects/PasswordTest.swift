import Foundation
import Testing

@testable import KataHexagonal

@Suite("Password") struct PasswordTest {
    @Test("Creates a password when the given value meets the requirements for a strong password")
    func testCorrect() throws {
        let password = Password.create(fromPlaintext: "SecurePass123_")
        _ = try password.get()
    }

    @Test("Fails when the password is too short")
    func tooShort() {
        let password = Password.create(fromPlaintext: "1aaA_")
        #expect(password == .failure(PasswordError([.tooShort])))
    }

    @Test("Fails when the password is missing a number")
    func noDigits() {
        let password = Password.create(fromPlaintext: "aaaaaA_")
        #expect(password == .failure(PasswordError([.mustContainNumber])))
    }

    @Test("Fails when the password is missing a lowercase")
    func noLowercase() {
        let password = Password.create(fromPlaintext: "A1234_")
        #expect(password == .failure(PasswordError([.mustContainLowercase])))
    }

    @Test("Fails when the password is missing an uppercase")
    func noUppercase() {
        let password = Password.create(fromPlaintext: "a1234_")
        #expect(password == .failure(PasswordError([.mustContainUppercase])))
    }

    @Test("Fails when the password is missing an underscore")
    func noUnderscore() {
        let password = Password.create(fromPlaintext: "aA2345")
        #expect(password == .failure(PasswordError([.mustContainUnderscore])))
    }

    @Test("Fails when the password is missing several requirements")
    func severalRequirements() {
        let password = Password.create(fromPlaintext: "abc")
        #expect(
            password
                == .failure(
                    PasswordError([
                        .tooShort, .mustContainNumber, .mustContainUppercase,
                        .mustContainUnderscore,
                    ])))
    }

    @Test("Ensures password is hashed")
    func passwordHashed() throws {
        let plaintext = "SecurePass123_"
        let password = try Password.create(fromPlaintext: plaintext).get()
        let hashedValue = password.toString()

        #expect(hashedValue != plaintext)
        #expect(hashedValue.count == 64)
        #expect(isHashed(hashedValue: hashedValue))
    }

    @Test("Matches when some given passwords are the same")
    func testEqual() {
        let plaintext = "SecurePass123_"
        let aPassword = Password.create(fromPlaintext: plaintext)
        let anotherPassword = Password.create(fromPlaintext: plaintext)

        #expect(aPassword == anotherPassword)
    }

    @Test("Does not match when some given passwords are different")
    func testNotEqual() {
        let aPassword = Password.create(fromPlaintext: "SecurePass123_")
        let anotherPassword = Password.create(fromPlaintext: "DifferentPass123_")

        #expect(aPassword != anotherPassword)
    }
}

func isHashed(hashedValue: String) -> Bool {
    let regex = "^[a-fA-F0-9]{64}$"
    let predicate = NSPredicate { evaluatedObject, _ in
        guard let text = evaluatedObject as? String else { return false }
        return text.range(of: regex, options: .regularExpression) != nil
    }
    return predicate.evaluate(with: hashedValue)
}
