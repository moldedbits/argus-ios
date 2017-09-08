//
//  EmailLoginProvider.swift
//  argus
//
//  Created by Amit Kumar Swami on 07/09/17.
//  Copyright © 2017 moldedbits. All rights reserved.
//

import Foundation
import UIKit

enum ValidationType {
    case email
    case characterLength(Int)
    case specialCharacterExist
    case upperCaseExist
    case lowerCaseExist
}

protocol EmailLoginProviderDataSource {
    func emailTextField() -> UITextField
    func passwordTextField() -> UITextField
    func emailFieldValidation() -> [ValidationType]
    func passwordFieldValidation() -> [ValidationType]
}

class EmailLoginProvider: BaseProvider {
    
    var dataSource: EmailLoginProviderDataSource!
    private var emailTextField: UITextField? {
        didSet {
            emailTextField?.keyboardType = .emailAddress
            emailTextField?.delegate = self
        }
    }
    private var passwordTextField: UITextField? {
        didSet {
            passwordTextField?.isSecureTextEntry = true
            passwordTextField?.delegate = self
        }
    }
    
    private var email: String? {
        return emailTextField?.text
    }
    
    private var password: String? {
        return passwordTextField?.text
    }
    
    init(dataSource: EmailLoginProviderDataSource) {
        self.dataSource = dataSource
        
        self.emailTextField = dataSource.emailTextField()
        self.passwordTextField = dataSource.passwordTextField()
    }
}

extension EmailLoginProvider: UITextViewDelegate {
    
}
