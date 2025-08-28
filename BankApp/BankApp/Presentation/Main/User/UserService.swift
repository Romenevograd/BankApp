import Foundation
import UIKit

final class UserService: UserServiceProtocol {
    
    private let users: [User] = [
        User(
            name: "Maria",
            avatar: UIImage(named: "MariaAvatar"),
            phoneNumber: "79078787840",
            verificationCode: "1234"
        ),
        User(
            name: "Sergey",
            avatar: UIImage(named: "SergeyAvatar"),
            phoneNumber: "79317896549",
            verificationCode: "4550"
        )
    ]
    
    func fetchUserData(completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let currentPhone = UserDefaults.standard.string(forKey: "currentUserPhone"),
               let user = self.users.first(where: { $0.phoneNumber == currentPhone }) {
                completion(.success(user))
            } else if let user = self.users.first {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "UserService", code: 404,
                                          userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"])))
            }
        }
    }
    
    func verifyPhoneNumber(_ phoneNumber: String, code: String, completion: @escaping (Result<User, Error>) -> Void) {
        let cleanedPhone = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        guard let user = users.first(where: {
            $0.phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) == cleanedPhone
        }) else {
            completion(.failure(NSError(domain: "UserService", code: 404,
                                        userInfo: [NSLocalizedDescriptionKey: "Пользователь с таким номером не найден"])))
            return
        }
        
        // Проверяем код
        if user.verificationCode == code {
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "UserService", code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "Неверный код подтверждения"])))
        }
    }
    
    func findUserByPhoneNumber(_ phoneNumber: String, completion: @escaping (Result<User, Error>) -> Void) {
            let cleanedPhone = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            guard let user = users.first(where: {
                $0.phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) == cleanedPhone
            }) else {
                completion(.failure(NSError(domain: "UserService", code: 404,
                                          userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"])))
                return
            }
            
            completion(.success(user))
        }
}
