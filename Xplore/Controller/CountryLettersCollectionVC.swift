//
//  CountryLettersCollectionVC.swift
//  Xplore
//
//  Created by Kerolles Roshdi on 6/19/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

private let reuseIdentifier = "letterCell"

class CountryLettersCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let lettersArray = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z".split(separator: " ")

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                if let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "signin") {
                    self.navigationController?.present(signinVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 26
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LetterCell
    
        // Configure the cell
        cell.letter.text = String(lettersArray[indexPath.row])
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let countriesTableVC = storyboard?.instantiateViewController(withIdentifier: "countriesTableVC") as? CountriesTableVC {
            countriesTableVC.countryLetter = String(lettersArray[indexPath.row])
            navigationController?.pushViewController(countriesTableVC, animated: true)
        }
        
    }
    
    

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 40) / 3, height: collectionView.frame.width / 3)
    }
    
    @IBAction func logoutButtonTaped(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let FBlogutManager = FBSDKLoginManager()
        FBlogutManager.logOut()
    }
    
    
}
