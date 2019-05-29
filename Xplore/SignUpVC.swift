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

class SignUpVC: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        
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
                        if error != nil {
                            print("sign up Error : \(error.debugDescription)")
                        } else {
                            // user is signed up -> sign in user :
                            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in

                                if error != nil {
                                    print("sign in Error : \(error.debugDescription)")
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
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        activityStart()
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
