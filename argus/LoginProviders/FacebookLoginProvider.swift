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

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, email"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

enum ProfileKeys: String {
    case facebookName = "name"
    case facebookId = "id"
    case registeredEmail = "email"
}

class FacebookLoginProvider: BaseProvider {
    
    var permissions: [ReadPermission] = [ .publicProfile ]
    var userName: String?
    var userId: String?
    var registeredEmail: String?
    
    // MARK: creates and returns login button
    private func displayLoginButton(readPermissions: [ReadPermission] = [ .publicProfile ]) -> UIView {
        let loginButton = LoginButton(readPermissions: readPermissions)
        
        return loginButton
    }
    
    // MARK: creates and returns a custom login button to your app
    private func displayLoginButtonWithText(_ text: String, readPermissions: [ReadPermission] = [ .publicProfile ]) -> UIButton {
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
    
    // MARK: returns accessToken if permission is already granted else return nil
    private func getAccessToken() -> AccessToken? {
        if let accessToken = AccessToken.current {
            return accessToken
        }
        
        return nil
    }
    
    // MARK: returns userId if permission is already granted else return nil
    private func getUserId() -> String? {
        if let accessToken = getAccessToken() {
            return accessToken.userId
        }
        
        return nil
    }
    
    // MARK: returns authentication token if permission is already granted else return nil
    private func getAuthenticationToken() -> String? {
        if let accessToken = getAccessToken() {
            return accessToken.authenticationToken
        }
        
        return nil
    }

    private func getUserProfile() -> UserProfile? {
        if let _ = getAccessToken() {
            return UserProfile.current
        }
        
        return nil
    }
    
    private func getConnection() {
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                // TODO: wrap this response in custom result
                break
            case .failed(let error):
                // TODO: wrap this in custom Error class
                print("Custom Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }

}
