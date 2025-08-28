import UIKit

final class MainViewController: UIViewController {
    private var presenter: MainPresenterProtocol
    
    private let nameLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let profileButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let cardCircle = UIView()
    
    init(presenter: MainPresenterProtocol = MainPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        presenter.viewDidLoad()
        
    }
    
    private func setupView() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 32
        avatarImageView.backgroundColor = .systemOrange
        avatarImageView.tintColor = .white
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = ""
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 22)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        cardCircle.backgroundColor = .white
        cardCircle.layer.cornerRadius = 16
        cardCircle.layer.shadowRadius = 16
        cardCircle.layer.shadowOpacity = 0.1
        cardCircle.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardCircle.layer.shadowColor = UIColor.black.cgColor
        cardCircle.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
    }
    
    private func setupViews() {
        view.addSubview(profileButton)
        profileButton.addSubview(nameLabel)
        profileButton.addSubview(avatarImageView)
        view.addSubview(cardCircle)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            profileButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -15),
            profileButton.heightAnchor.constraint(equalToConstant: 64),
            
            avatarImageView.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            avatarImageView.heightAnchor.constraint(equalToConstant: 64),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: profileButton.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor),
            
            cardCircle.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 30),
            cardCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            cardCircle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -15),
            cardCircle.heightAnchor.constraint(equalToConstant: 150),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc private func profileButtonTapped() {
        print("Профиль нажат")
    }
}

extension MainViewController: MainViewProtocol {
    func displayUserName(_ name: String) {
        nameLabel.text = name
    }
    
    func displayUserAvatar(_ image: UIImage?) {
        avatarImageView.image = image ?? UIImage(systemName: "person.circle.fill")
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
