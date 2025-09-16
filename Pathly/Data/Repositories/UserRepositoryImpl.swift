import Foundation

class UserRepositoryImpl: UserRepository {
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    
    func saveUser(_ user: User) async throws {
        let data = try JSONEncoder().encode(user)
        userDefaults.set(data, forKey: userKey)
    }
    
    func getCurrentUser() async throws -> User? {
        guard let data = userDefaults.data(forKey: userKey) else {
            return nil
        }
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func updateCurrentUser(_ user: User) async throws {
        try await saveUser(user)
    }
}