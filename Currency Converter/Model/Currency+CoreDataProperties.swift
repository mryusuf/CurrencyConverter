//
//  Currency+CoreDataProperties.swift
//  Currency Converter
//
//  Created by Indra Permana on 06/02/20.
//  Copyright © 2020 Yusuf Indra. All rights reserved.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var code: String?
    @NSManaged public var detail: String?

}
