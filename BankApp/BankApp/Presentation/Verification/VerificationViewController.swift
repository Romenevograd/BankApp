import UIKit

final class VerificationViewController: UIViewController, VerificationViewProtocol {
    private var presenter: VerificationPresenterProtocol
    
    // UI элементы
    private let titleLabel = UILabel()
    private let codeTextField = UITextField()
    private let verifyButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView()
    
    init(phoneNumber: String) {
        self.presenter = VerificationPresenter(phoneNumber: phoneNumber)
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - VerificationViewProtocol
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        verifyButton.isEnabled = !isLoading
        verifyButton.alpha = isLoading ? 0.7 : 1.0
    }
    
    func navigateToMainScreen() {
        let mainPresenter = MainPresenter()
        let mainVC = MainViewController(presenter: mainPresenter)
        navigationController?.setViewControllers([mainVC], animated: true)
    }
    
    func setPhoneNumber(_ phoneNumber: String) {
        titleLabel.text = "Введите код для номера\n+\(phoneNumber)"
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupActions()
        configureAppearance()
    }
    
    private func setupViews() {
        [titleLabel, codeTextField, verifyButton, activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            codeTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: 120),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            verifyButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 30),
            verifyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            verifyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            verifyButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupActions() {
        verifyButton.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
    }
    
    private func configureAppearance() {
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        codeTextField.placeholder = "XXXX"
        codeTextField.keyboardType = .numberPad
        codeTextField.borderStyle = .roundedRect
        codeTextField.textAlignment = .center
        codeTextField.delegate = self
        codeTextField.font = UIFont.monospacedSystemFont(ofSize: 24, weight: .medium)
        
        verifyButton.setTitle("Подтвердить", for: .normal)
        verifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        verifyButton.backgroundColor = .systemOrange
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.layer.cornerRadius = 22
        
        activityIndicator.hidesWhenStopped = true
    }
    
    @objc private func verifyButtonTapped() {
        presenter.verifyCode(codeTextField.text ?? "")
    }
}

// MARK: - UITextFieldDelegate
extension VerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 4
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count == 4 {
            verifyButtonTapped()
        }
    }
}
