import Foundation

protocol PhoneNumberValidatorProtocol {
    func isValid(phoneNumber: String) -> Bool
}

final class PhoneNumberValidator: PhoneNumberValidatorProtocol {
    func isValid(phoneNumber: String) -> Bool {
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleanedNumber.count >= 10 
    }
}
