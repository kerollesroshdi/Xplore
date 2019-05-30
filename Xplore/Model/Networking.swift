//
//  Networking.swift
//  Xplore
//
//  Created by Kerolles Roshdi on 5/29/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private static let sharedNetworkManager = NetworkManager()
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    func getCountries(completion: @escaping (_ countries: [Country]) -> Void) {
        
        debugPrint("getting countries")
        
        guard let countryAPIURL = URL(string: "http://countryapi.gear.host/v1/Country/getCountries") else { print("--- error in URL")
            return
            
        }
        
        URLSession.shared.dataTask(with: countryAPIURL) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let getCountries = try decoder.decode(GetCountries.self, from: data)
                completion(getCountries.Response)
                
            } catch let err {
                print("----------- Error : \(err)")
            }
        }.resume()
    }
    
}
