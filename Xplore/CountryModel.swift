//
//  CountryModel.swift
//  Xplore
//
//  Created by Kerolles Roshdi on 5/29/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct Country: Codable {
    let Name: String
    let Region: String
    let NativeLanguage: String
    let CurrencyName: String
    let FlagPng: String
}


struct GetCountries: Codable {
    let IsSuccess: Bool
    let TotalCount: Int
    let Response: [Country]
}
