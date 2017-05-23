//
//  DailyGoal+CoreDataProperties.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/22/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import Foundation
import CoreData


extension DailyGoal {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<DailyGoal>(entityName: "DailyGoal") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var goalstep: Int32
    @NSManaged public var date: Date?
    @NSManaged public var achieved: Bool
    @NSManaged public var actualStep: Int32

}
