//
//  AppDelegate.swift
//  argus
//
//  Created by Saurabh Gupta on 07/09/17.
//  Copyright © 2017 moldedbits. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize Google sign-in context
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
}

extension AppDelegate: GIDSignInDelegate {
    
    // MARK: Google SignIN delegate method
    // TODO: Move this method in an extention to App Delegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            
            // TODO: Give a callback here to GoogleSignInProvider and set this user properties there only using init(user: User)
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            // TODO:
            print("\(error.localizedDescription)")
        }
    }
    
    // MARK: Delegate method to handle user disconnection from the app
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

