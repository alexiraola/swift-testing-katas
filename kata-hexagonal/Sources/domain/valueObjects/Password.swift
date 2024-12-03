enum PasswordErrorType: Error {
    case tooShort
    case mustContainNumber
    case mustContainLowercase
    case mustContainUppercase
    case mustContainUnderscore
}

struct PasswordError: Error, Hashable {
    let errors: [PasswordErrorType]

    init(_ errors: [PasswordErrorType]) {
        self.errors = errors
    }
}

struct Password: Hashable {
    private let value: String

    private init(value: String) {
        self.value = value
    }

    func toString() -> String {
        return value
    }

    static func create(fromPlaintext password: String) -> Result<Password, PasswordError> {
        return ensureIsValidPassword(password).map { Password(value: Hash.hash(for: $0)) }
    }

    private static func ensureIsValidPassword(_ password: String) -> Result<String, PasswordError> {
        var errors: [PasswordErrorType] = []

        if !hasSixCharactersOrMore(password) {
            errors.append(.tooShort)
        }
        if !containsNumber(password) {
            errors.append(.mustContainNumber)
        }
        if !containsLowercase(password) {
            errors.append(.mustContainLowercase)
        }
        if !containsUppercase(password) {
            errors.append(.mustContainUppercase)
        }
        if !containsUnderscore(password) {
            errors.append(.mustContainUnderscore)
        }
        if errors.count > 0 {
            return .failure(PasswordError(errors))
        }
        return .success(password)
    }

    private static func hasSixCharactersOrMore(_ text: String) -> Bool {
        return text.count >= 6
    }

    private static func containsNumber(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: .decimalDigits) != nil
    }

    private static func containsLowercase(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: .lowercaseLetters) != nil
    }

    private static func containsUppercase(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: .uppercaseLetters) != nil
    }

    private static func containsUnderscore(_ text: String) -> Bool {
        return text.contains("_")
    }
}
