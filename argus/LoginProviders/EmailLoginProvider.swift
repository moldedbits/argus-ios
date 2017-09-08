//
//  EmailLoginProvider.swift
//  argus
//
//  Created by Amit Kumar Swami on 07/09/17.
//  Copyright © 2017 moldedbits. All rights reserved.
//

import Foundation
import UIKit
import Result

protocol EmailLoginProviderDataSource {
    func usernameTextField() -> UITextField
    func passwordTextField() -> UITextField
    func usernameFieldValidation() -> [ValidationType]
    func passwordFieldValidation() -> [ValidationType]
    func signInButton() -> UIButton
}

extension EmailLoginProviderDataSource {
    func usernameFieldValidation() -> [ValidationType] {
        return [.characterLength(min: 8, max: 40), .upperCaseExist, .lowerCaseExist, .specialCharacterExist]
    }
    
    func passwordFieldValidation() -> [ValidationType] {
        return [.email]
    }
}

protocol EmailLoginProviderDelegate: class {
    func usernameValidationError(error: ValidationError)
    func passwordValidationError(error: ValidationError)
    func signIn(username: String, password: String)
}

class EmailLoginProvider: NSObject, BaseProvider {
    
    var dataSource: EmailLoginProviderDataSource!
    weak var delegate: EmailLoginProviderDelegate?
    fileprivate var usernameTextField: UITextField {
        let emailTextField = dataSource.usernameTextField()
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        
        return emailTextField
    }
    fileprivate var passwordTextField: UITextField {
        let passwordTextField = dataSource.passwordTextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        return passwordTextField
    }
    private var signInButton: UIButton {
        let button = dataSource.signInButton()
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    fileprivate var username: String? {
        return usernameTextField.text
    }
    
    fileprivate var password: String? {
        return passwordTextField.text
    }
    
    init(dataSource: EmailLoginProviderDataSource) {
        self.dataSource = dataSource
    }
    
    fileprivate func toggleSignInButton(_ enable: Bool) {
        
        signInButton.isEnabled = enable
    }
    
    fileprivate func checkIfEmpty(strings: [String?]) -> Bool {
        return strings.contains(where: { (string) -> Bool in
            guard let string = string else { return true }
            return string == ""
        })
    }
    
    @objc fileprivate func signInButtonTapped() {
        if let _ = validateFields() {
            return
        } else {
            delegate?.signIn(username: username ?? "", password: password ?? "")
        }
    }
    
    private func validateFields() -> ValidationError? {
        switch ValidationType.validate(string: username ?? "", validations: dataSource.usernameFieldValidation()) {
        case let .failure(error):
            delegate?.usernameValidationError(error: error)
            return error
        case .success: break
        }
        
        switch ValidationType.validate(string: password ?? "", validations: dataSource.passwordFieldValidation()) {
        case let .failure(error):
            delegate?.passwordValidationError(error: error)
            return error
        case .success: break
        }
        
        return nil
    }
}

extension EmailLoginProvider: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let str = textField.text as NSString? else { return false }
        let updatedString = str.replacingCharacters(in: range, with: string)
        
        switch textField {
        case usernameTextField:
            toggleSignInButton(checkIfEmpty(strings: [updatedString, password]))
        case passwordTextField:
            toggleSignInButton(checkIfEmpty(strings: [updatedString, username]))
        default:
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        default:
            signInButtonTapped()
        }
        
        return true
    }
}
