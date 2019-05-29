//
//  ViewController.swift
//  Xplore
//
//  Created by Kerolles Roshdi on 5/28/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.isHidden = true
    }
    
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        
        activityStart()
        
        if isValidEmail(testStr: emailTextField.text!) {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                
                if let error = error {
                    print("sign in Error : \(error.localizedDescription)")
                    self!.activityStop()
                    showAlert(VC: self!, title: "Sign in Error", message: (error.localizedDescription), actionTitle: "OK")
                } else {
                    if let CountriesVC = self?.storyboard?.instantiateInitialViewController() {
                        self?.present(CountriesVC, animated: true, completion: nil)
                    }
                }
            }
            
        } else {
            activityStop()
            showAlert(VC: self, title: "Email Error", message: "email isn't valid", actionTitle: "OK")
        }
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

extension SignInVC: UITextFieldDelegate {
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

