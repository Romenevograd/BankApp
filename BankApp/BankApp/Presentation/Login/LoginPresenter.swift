import Foundation

final class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    private let phoneNumberValidator: PhoneNumberValidatorProtocol
    
    init(phoneNumberValidator: PhoneNumberValidatorProtocol = PhoneNumberValidator()) {
        self.phoneNumberValidator = phoneNumberValidator
    }
    
    func viewDidLoad() {
    }
    
    func loginButtonTapped(phoneNumber: String?) {
        guard let phoneNumber = phoneNumber, !phoneNumber.isEmpty else {
            view?.showError(message: "Пожалуйста, введите номер телефона")
            return
        }
        
        guard phoneNumberValidator.isValid(phoneNumber: phoneNumber) else {
            view?.showError(message: "Некорректный номер телефона")
            return
        }
        
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        view?.navigateToVerification(with: cleanedNumber)
    }
}
