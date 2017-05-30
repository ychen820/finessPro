//
//  TotalGoal+CoreDataProperties.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/28/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import Foundation
import CoreData


extension TotalGoal {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<TotalGoal>(entityName: "TotalGoal") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var step: Int32

}
