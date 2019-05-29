//
//  Validation.swift
//  Xplore
//
//  Created by Kerolles Roshdi on 5/29/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import UIKit


func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func isValidPassword(password: String) -> Bool {
    return password.count < 6 ? false : true
}


func showAlert(VC: UIViewController, title: String, message: String, actionTitle: String) {
    let alertController = UIAlertController(title: title, message:
        message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: actionTitle, style: .default))
    VC.present(alertController, animated: true, completion: nil)
}
