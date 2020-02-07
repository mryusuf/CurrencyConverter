//
//  CurrencyResult.swift
//  Currency Converter
//
//  Created by Indra Permana on 06/02/20.
//  Copyright © 2020 Yusuf Indra. All rights reserved.
//

import Foundation

struct CurrencyResult: Codable {
    var base: String
    var date: String
    var rates: Rates
}

struct Rates: Codable {
    var IDR: Double
    var USD: Double
    var THB: Double
    var SGD: Double

}
enum CurrencyCode: String {
    case IDR = "IDR"
    case USD = "USD"
    case THB = "THB"
    case SGD = "SGD"
}

enum CurrencyPickerViewTag: Int {
    case CurrencySource = 0
    case CurrencyDestination = 1
}

