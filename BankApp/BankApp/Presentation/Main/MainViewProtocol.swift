import UIKit

protocol MainViewProtocol: AnyObject {
    func displayUserName(_ name: String)
    func displayUserAvatar(_ image: UIImage?)
    func showLoading(_ isLoading: Bool)
    func showError(message: String)
}
