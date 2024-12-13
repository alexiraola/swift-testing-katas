import Foundation

enum EmailError: Error {
    case invalid
}

struct Email: Hashable {
    private let email: String

    private init(email: String) {
        self.email = email
    }

    static func create(email: String) -> Email? {
        if isValidEmail(email: email) {
            return Email(email: email)
        }
        return nil
    }

    static func createResult(email: String) -> Result<Email, EmailError> {
        if isValidEmail(email: email) {
            return .success(Email(email: email))
        }
        return .failure(.invalid)
    }

    private static func isValidEmail(email: String) -> Bool {
        let emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"
        let predicate = NSPredicate { evaluatedObject, _ in
            guard let emailString = evaluatedObject as? String else { return false }
            return emailString.range(of: emailRegex, options: .regularExpression) != nil
        }
        return predicate.evaluate(with: email)
    }
}
