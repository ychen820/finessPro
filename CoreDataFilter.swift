//
//  CoreDataFilter.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/25/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import CoreData
open class CoreDataFilter: NSObject {
    open class func getFetchResult(fromDate from:Date,toDate to:Date, forEntity entityName:String)->NSFetchRequest<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = CoreDataFilter.getPredicate(from: from, to: to)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    open class func getCurrentYearRange(fordate:Date)->(startdate:Date,endDate:Date){
        let dateComponent:Set<Calendar.Component> =  [.year,.month,.day]
        let components = NSCalendar.current.dateComponents(dateComponent, from:fordate)
        var startComponent = components
        startComponent.month = 1
        startComponent.day = 1
        
        var endComponent = components
        endComponent.year = endComponent.year!+1
        endComponent.month = 1
        endComponent.day = 1
        
        var startDate = Calendar.current.date(from: startComponent)
        startDate = Calendar.current.startOfDay(for: startDate!)
        
        var endDate = Calendar.current.date(from: endComponent)
        endDate = Calendar.current.startOfDay(for: endDate!)
    
        return (startDate!,endDate!)
    }
    open class func getMonthRange(forYear year:Int, formonth month:Int) ->(startDate:Date,endDate:Date){
       let calandarComponent = NSDateComponents()
        calandarComponent.year = year
        calandarComponent.month = month
        calandarComponent.day = 1
        let startDate = Calendar.current.date(from: calandarComponent as DateComponents)
        
        calandarComponent.month = month+1
        let endDate = Calendar.current.date(from: calandarComponent as DateComponents)
        return(startDate!,endDate!)
    }
    open class func getWeekData(forDate date:Date) -> (startDate:Date,endDate:Date){
        let calendarComponent : Set<Calendar.Component> = [.year,.month,.day,.weekday]
        var dateComponent = Calendar.current.dateComponents(calendarComponent, from: date)
        dateComponent.weekday = 1
        let startDate = Calendar.current.date(from: dateComponent)
        dateComponent.weekday = 7
        let endDate = Calendar.current.date(from: dateComponent)
        return (startDate!,endDate!)
        
    }
    open class func getPredicate(from fromdate:Date,to todate:Date) ->NSPredicate{
        let predicate = NSPredicate(format: "timestamp>%@ AND timestamp<%@", fromdate as NSDate,todate as NSDate)
        return predicate
    }
    
    
}
