//
//  FacebookLoginProvider.swift
//  argus
//
//  Created by Saurabh Gupta on 07/09/17.
//  Copyright © 2017 moldedbits. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Result

protocol FaceBookLoginProviderDataSource {
    func displayLoginButton() -> UIView
}

protocol FaceBookLoginProviderDelegate: class {
    func signInError(error: LoginError)
}

class FacebookLoginProvider: BaseProvider {
    
    var permissions: [ReadPermission] = [ .publicProfile ]
    
    // MARK: creates and returns login button
    func displayLoginButton(readPermissions: [ReadPermission] = [ .publicProfile ]) -> UIView {
        let loginButton = LoginButton(readPermissions: readPermissions)
        
        return loginButton
    }
    
    // MARK: returns accessToken if permission is already granted else return nil
    func getAccessToken() -> AccessToken? {
        if let accessToken = AccessToken.current {
            return accessToken
        }
        
        return nil
    }
    
    // MARK: returns userId if permission is already granted else return nil
    func getUserId() -> String? {
        if let accessToken = getAccessToken() {
            return accessToken.userId
        }
        
        return nil
    }
    
    // MARK: returns authentication token if permission is already granted else return nil
    func getAuthenticationToken() -> String? {
        if let accessToken = getAccessToken() {
            return accessToken.authenticationToken
        }
        
        return nil
    }
    
    // MARK: creates and returns a custom login button to your app
    func displayLoginButtonWithText(_ text: String, readPermissions: [ReadPermission] = [ .publicProfile ]) -> UIButton {
        let loginButton = UIButton(type: .custom)
        loginButton.setTitle(text, for: .normal)
        permissions = readPermissions
        loginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        return loginButton
    }
    
    // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(self.permissions) { loginResult in
            switch loginResult {
            case .failed(let error):
                // TODO: wrap this response in Result<T> class
                print(error)
            case .cancelled:
                // TODO: wrap this response in Result<T> class
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                // TODO: wrap this response in Result<T> class
                print("Logged in!")
            }
        }
    }
    
}
