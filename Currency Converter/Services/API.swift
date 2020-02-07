//
//  API.swift
//  Currency Converter
//
//  Created by Indra Permana on 06/02/20.
//  Copyright © 2020 Yusuf Indra. All rights reserved.
//

import Foundation

class API {
    
    private let baseUrl = "https://api.exchangerate-api.com/v4/latest/"
    static var rates: Rates?
    
    func fetchRates(source: String, completionHandler: @escaping (Rates?, String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: baseUrl+source)!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
                completionHandler(nil, error?.localizedDescription ?? "")
            } else {
                guard let responsData = data, response != nil else { print("Something Wrong")
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let fetchedRates = try decoder.decode(CurrencyResult.self, from: responsData)
                    type(of: self).rates = fetchedRates.rates
                    print("rates ARE \(String(describing: API.rates))")
                    
                    completionHandler(type(of: self).rates!, nil)
                } catch {
                    print(error)
                    completionHandler(nil,error.localizedDescription)
                }
            }
        })
        
        dataTask.resume()
    }
}
