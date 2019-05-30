//
//  CountryDetailsVC.swift
//  Xplore
//
//  Created by Kerolles Roshdi on 5/30/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class CountryDetailsVC: UIViewController {
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let country = country {
            
            self.title = country.Name
            
            regionLabel.text = country.Region
            languageLabel.text = country.NativeLanguage
            currencyLabel.text = country.CurrencyName
            
            let url = URL(string: country.FlagPng)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.flagImage.image = UIImage(data: data!)
                }
            }
            
            
        }
        
    }
    
}
