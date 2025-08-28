import Foundation

final class VerificationPresenter: VerificationPresenterProtocol {
    weak var view: VerificationViewProtocol?
    private let phoneNumber: String
    private let userService: UserServiceProtocol
    
    init(phoneNumber: String, userService: UserServiceProtocol = UserService()) {
        self.phoneNumber = phoneNumber
        self.userService = userService
    }
    
    func viewDidLoad() {
        userService.findUserByPhoneNumber(phoneNumber) { [weak self] result in
            switch result {
            case .success(let user):
                self?.view?.setPhoneNumber(user.phoneNumber)
            case .failure:
                self?.view?.setPhoneNumber(self?.phoneNumber ?? "")
            }
        }
    }
    
    func verifyCode(_ code: String) {
            guard !code.isEmpty else {
                view?.showError(message: "Пожалуйста, введите код подтверждения")
                return
            }
            
            guard code.count == 4 else {
                view?.showError(message: "Код должен содержать 4 цифры")
                return
            }
            
            view?.showLoading(true)
            
            userService.verifyPhoneNumber(phoneNumber, code: code) { [weak self] result in
                self?.view?.showLoading(false)
                
                switch result {
                case .success(let user):
                    print("Успешная авторизация для пользователя: \(user.name)")
                    UserDefaults.standard.set(user.phoneNumber, forKey: "currentUserPhone")
                    self?.view?.navigateToMainScreen()
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
