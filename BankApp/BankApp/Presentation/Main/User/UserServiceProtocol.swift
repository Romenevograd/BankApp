import Foundation

protocol UserServiceProtocol {
    func fetchUserData(completion: @escaping (Result<User, Error>) -> Void)
    func verifyPhoneNumber(_ phoneNumber: String, code: String, completion: @escaping (Result<User, Error>) -> Void)
    func findUserByPhoneNumber(_ phoneNumber: String, completion: @escaping (Result<User, Error>) -> Void)
}
