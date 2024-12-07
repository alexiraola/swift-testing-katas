import Foundation

enum UserIdError: Error {
    case invalidFormat
}

struct UserId: Hashable {
    private let uuid: UUID

    static func generateUniqueIdentifier() -> UserId {
        return UserId(uuid: UUID())
    }

    static func create(from id: String) -> Result<UserId, UserIdError> {
        guard let uuid = UUID(uuidString: id) else {
            return .failure(.invalidFormat)
        }
        return .success(UserId(uuid: uuid))
    }

    func toString() -> String {
        return uuid.uuidString
    }
}
