//
//  LoginVC.swift
//  ToDoApp
//
//  Created by IOS DEV on 25/09/2019.
//  Copyright © 2019 IOS DEV. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn

class LoginVC: UIViewController, UINavigationControllerDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
//        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
//            navigateToHome()
//        } else {
//            GIDSignIn.sharedInstance()?.signInSilently()
//        }
    }

    @IBAction func signInUsingGoogle(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func skipSignIn(_ sender: UIButton) {
        navigateToHome()
    }
    
    func navigateToHome() {
        let navigationController = storyboard?.instantiateViewController(withIdentifier: VCIdentifiers.HomeNavigationIdentifier) as! UINavigationController
        let viewController = storyboard?.instantiateViewController(withIdentifier: VCIdentifiers.HomeVCIdentifier)
        navigationController.setViewControllers([viewController!], animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationController
    }
}
extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        navigateToHome()
    }
}
