protocol VerificationPresenterProtocol {
    var view: VerificationViewProtocol? { get set }
    func verifyCode(_ code: String)
    func viewDidLoad()
}
