//
//  CountriesTableVC.swift
//  Xplore
//
//  Created by Kerolles Roshdi on 5/28/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class CountriesTableVC: UITableViewController {
    
    var countryLetter = ""
    var countriesArray = [Country]()
    
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
        
        activityIndicator()
        activityIndicatorStart()

        NetworkManager.shared().getCountries { (countries) in
            self.countriesArray = countries.filter { String($0.Name.first ?? " ") == self.countryLetter }
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorStop()
                self?.tableView.reloadData()
            }
        }
        
    }
    
    
    @IBAction func SignOutButtonTapped(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        
        let FBlogutManager = FBSDKLoginManager()
        FBlogutManager.logOut()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countriesArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)

        // Configure the cell...
        
        let country = countriesArray[indexPath.row]
        
        cell.textLabel?.text = country.Name
        cell.detailTextLabel?.text = country.Region
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let countryDetailsVC = storyboard?.instantiateViewController(withIdentifier: "countryDetailsVC") as? CountryDetailsVC {
            countryDetailsVC.country = countriesArray[indexPath.row]
            navigationController?.pushViewController(countryDetailsVC, animated: true)
        }
    }
    
    
    
    // Setup Activity Indicator :
    
    var indicator = UIActivityIndicatorView()
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = .whiteLarge
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func activityIndicatorStart() {
        indicator.startAnimating()
        indicator.backgroundColor = .white
        indicator.color = .gray
    }
    
    func activityIndicatorStop() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    

}
