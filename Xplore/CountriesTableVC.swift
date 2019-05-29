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
            self.countriesArray = countries
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorStop()
                self?.tableView.reloadData()
            }
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func SignOutButtonTapped(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        
        let FBlogutManager = FBSDKLoginManager()
        FBlogutManager.logOut()
        
        
//        if let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "signin") {
//            self.navigationController?.present(signinVC, animated: true, completion: nil)
//        }
        
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
