//
//  Step+CoreDataProperties.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/22/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import Foundation
import CoreData


extension Step {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<Step>(entityName: "Step") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var count: Int32
    @NSManaged public var timestamp: Date?

}
