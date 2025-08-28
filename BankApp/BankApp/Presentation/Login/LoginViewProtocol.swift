protocol LoginViewProtocol: AnyObject {
    func showError(message: String)
    func navigateToVerification(with phoneNumber: String)
}
