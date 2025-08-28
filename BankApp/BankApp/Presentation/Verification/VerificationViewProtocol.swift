protocol VerificationViewProtocol: AnyObject {
    func showError(message: String)
    func showLoading(_ isLoading: Bool)
    func navigateToMainScreen()
    func setPhoneNumber(_ phoneNumber: String)
}
