//import Foundation
//
//class LoginPresenterTests: XCTestCase {
//    var presenter: LoginPresenter!
//    var mockView: MockLoginView!
//    var mockValidator: MockPhoneNumberValidator!
//    
//    override func setUp() {
//        mockView = MockLoginView()
//        mockValidator = MockPhoneNumberValidator()
//        presenter = LoginPresenter(view: mockView, phoneNumberValidator: mockValidator)
//    }
//    
//    func testEmptyPhoneNumber() {
//        presenter.loginButtonTapped(phoneNumber: nil)
//        XCTAssertTrue(mockView.showErrorCalled)
//        XCTAssertEqual(mockView.errorMessage, "Пожалуйста, введите номер телефона")
//    }
//    
//    func testInvalidPhoneNumber() {
//        mockValidator.isValid = false
//        presenter.loginButtonTapped(phoneNumber: "123")
//        XCTAssertTrue(mockView.showErrorCalled)
//    }
//    
//    func testValidPhoneNumber() {
//        mockValidator.isValid = true
//        presenter.loginButtonTapped(phoneNumber: "79998887766")
//        XCTAssertTrue(mockView.navigateCalled)
//    }
//}
//
//class MockLoginView: LoginViewProtocol {
//    var showErrorCalled = false
//    var errorMessage: String?
//    var navigateCalled = false
//    
//    func showError(message: String) {
//        showErrorCalled = true
//        errorMessage = message
//    }
//    
//    func navigateToVerification(with phoneNumber: String) {
//        navigateCalled = true
//    }
//}
//
//class MockPhoneNumberValidator: PhoneNumberValidatorProtocol {
//    var isValid = true
//    
//    func isValid(phoneNumber: String) -> Bool {
//        return isValid
//    }
//}
