//
//  SignUpVC.swift
//  Xplore
//
//  Created by Kerolles Roshdi on 5/28/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class SignUpVC: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        activityIndicator.isHidden = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        
        activityStart()
        
        // form validation:
        
        if isValidEmail(testStr: emailTextField.text!) {
            if isValidPassword(password: passwordTextField.text!) && isValidPassword(password: confirmPasswordTextField.text!) {
                if passwordTextField.text == confirmPasswordTextField.text {
                    
                    // input is Valid -> Sign up a new user :
                    
                    let email = emailTextField.text!
                    let password = passwordTextField.text!
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        // ...
                        if let error = error {
                            self.activityStop()
                            print("sign up Error : \(error.localizedDescription)")
                            showAlert(VC: self, title: "Signup Error", message: error.localizedDescription, actionTitle: "OK")
                        } else {
                            // user is signed up -> sign in user :
                            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in

                                if let error = error {
                                    print("sign in Error : \(error.localizedDescription)")
                                } else {
                                    if let CountriesVC = self?.storyboard?.instantiateInitialViewController() {
                                        self?.present(CountriesVC, animated: true, completion: nil)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                } else {
                    activityStop()
                    showAlert(VC: self, title: "Password Error", message: "password doesn't match", actionTitle: "OK")
                }
            } else {
                activityStop()
                showAlert(VC: self, title: "Password Error", message: "password should be 6 characters at least", actionTitle: "OK")
            }
        } else {
            activityStop()
            showAlert(VC: self, title: "Email Error", message: "email isn't valid", actionTitle: "OK")
        }
        
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        
        let LoginManager = FBSDKLoginManager()
        LoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
                if let error = error {
                    showAlert(VC: self, title: "Facebook Login Error", message: error.localizedDescription, actionTitle: "OK")
                    return
                } else {
                    if let CountriesVC = self.storyboard?.instantiateInitialViewController() {
                        self.present(CountriesVC, animated: true, completion: nil)
                    }
                }

            }
        }
        
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // activityIndicator :
    
    func activityStop() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func activityStart() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    

}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let nextTag = textField.tag + 1
            if let nextResponder = textField.superview?.superview?.viewWithTag(nextTag)?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            }
        } else if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
}
