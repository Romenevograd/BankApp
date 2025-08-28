import Foundation

protocol VerificationServiceProtocol {
    func verifyCode(_ code: String, for phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class VerificationService: VerificationServiceProtocol {
    func verifyCode(_ code: String, for phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Реальная логика проверки кода
        // Например, запрос к API
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if code == "1234" { 
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "", code: 401,
                                          userInfo: [NSLocalizedDescriptionKey: "Неверный код подтверждения"])))
            }
        }
    }
}
