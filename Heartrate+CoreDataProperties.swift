//
//  Heartrate+CoreDataProperties.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/22/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import Foundation
import CoreData


extension Heartrate {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<Heartrate>(entityName: "Heartrate") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var heartrate: Int32
    @NSManaged public var timestamp: Date?

}
