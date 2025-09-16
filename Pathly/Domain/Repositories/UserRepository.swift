import Foundation

protocol UserRepository {
    func saveUser(_ user: User) async throws
    func getCurrentUser() async throws -> User?
    func updateCurrentUser(_ user: User) async throws
}