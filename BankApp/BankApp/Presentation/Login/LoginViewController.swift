import UIKit

final class LoginViewController: UIViewController, LoginViewProtocol {
    private var presenter: LoginPresenterProtocol
    
    private let titleLabel = UILabel()
    private let phoneTextField = UITextField()
    private let loginButton = UIButton()
    
    private lazy var tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(handleTap)
    )
    
    // MARK: - Initialization
    init(presenter: LoginPresenterProtocol = LoginPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        presenter.viewDidLoad()
    }
    
    
    // MARK: - LoginViewProtocol
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToVerification(with phoneNumber: String) {
        let verificationVC = VerificationViewController(phoneNumber: phoneNumber)
        navigationController?.pushViewController(verificationVC, animated: true)
    }
    
    @objc
    private func loginButtonTapped() {
        presenter.loginButtonTapped(phoneNumber: phoneTextField.text)
    }
    
    @objc
    private func handleTap() {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    private func setupView() {
            titleLabel.text = "Вход по номеру телефона"
            titleLabel.font = UIFont.systemFont(ofSize: 22)
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            phoneTextField.placeholder = "+7 (XXX) XXX-XX-XX"
            phoneTextField.keyboardType = .phonePad
            phoneTextField.borderStyle = .roundedRect
            phoneTextField.translatesAutoresizingMaskIntoConstraints = false
            phoneTextField.delegate = self
            
            loginButton.setTitle("Получить код", for: .normal)
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            loginButton.backgroundColor = .systemOrange
            loginButton.setTitleColor(.white, for: .normal)
            loginButton.layer.cornerRadius = 22
            loginButton.translatesAutoresizingMaskIntoConstraints = false
        }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addGestureRecognizer(tapGesture)
        setupViews()
        setupConstraints()
        setupActions()
        setupTextFieldAppearance()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(phoneTextField)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            phoneTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private func setupTextFieldAppearance() {
        phoneTextField.backgroundColor = .systemGray6
        phoneTextField.layer.cornerRadius = 8
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.systemGray3.cgColor
        phoneTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: phoneTextField.frame.height))
        phoneTextField.leftViewMode = .always
    }
    
    private func formatPhoneNumber(number: String) -> String {
        var cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if cleanPhoneNumber.count == 1, cleanPhoneNumber.first != "7" {
            cleanPhoneNumber.removeFirst()
            cleanPhoneNumber = "7" + cleanPhoneNumber
        }
        
        let mask = "+# (###) ###-##-##"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        
        for symbol in mask where index < cleanPhoneNumber.endIndex {
            if symbol == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(symbol)
            }
        }
        
        return result
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        
        textField.text = formatPhoneNumber(number: newString)
        
        return false
    }
}
