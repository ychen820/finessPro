//
//  Yearly+CoreDataProperties.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/25/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import Foundation
import CoreData


extension Yearly {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<Yearly>(entityName: "Yearly") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var actualStep: Int32
    @NSManaged public var date: NSDate?

}
