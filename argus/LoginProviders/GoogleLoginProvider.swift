//
//  GoogleLoginProvider.swift
//  argus
//
//  Created by Saurabh Gupta on 07/09/17.
//  Copyright © 2017 moldedbits. All rights reserved.
//

import Foundation
import Google
import GoogleSignIn

class GoogleLoginProvider: BaseProvider {
    
}

// Method to be defined in ViewController

//override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    GIDSignIn.sharedInstance().uiDelegate = self
//    
//    // Uncomment to automatically sign in the user.
//    //GIDSignIn.sharedInstance().signInSilently()
//    
//    // TODO(developer) Configure the sign-in button look/feel
//    // ...
//}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
//func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
//    myActivityIndicator.stopAnimating()
//}
//

//// Present a view that prompts the user to sign in with Google
//func signIn(signIn: GIDSignIn!,
//            presentViewController viewController: UIViewController!) {
//    self.presentViewController(viewController, animated: true, completion: nil)
//}
//

//// Dismiss the "Sign in with Google" view
//func signIn(signIn: GIDSignIn!,
//            dismissViewController viewController: UIViewController!) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//}


// Sign out the user

//@IBAction func didTapSignOut(sender: AnyObject) {
//    GIDSignIn.sharedInstance().signOut()
//}
