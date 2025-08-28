import Foundation

protocol LoginPresenterProtocol {
    var view: LoginViewProtocol? {get set}
    func loginButtonTapped(phoneNumber: String?)
    func viewDidLoad()
}

