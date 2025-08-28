import Foundation

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    private let userService: UserServiceProtocol
    
    init(view: MainViewProtocol? = nil, userService: UserServiceProtocol = UserService()) {
        self.view = view
        self.userService = userService
    }
    
    func viewDidLoad() {
        loadUserData()
    }
    
    private func loadUserData() {
        view?.showLoading(true)
        
        userService.fetchUserData { [weak self] result in
            self?.view?.showLoading(false)
            
            switch result {
            case .success(let user):
                self?.view?.displayUserName(user.name)
                self?.view?.displayUserAvatar(user.avatar)
            case .failure(let error):
                self?.view?.showError(message: "Пользователь не найден")
            }
        }
    }
}
