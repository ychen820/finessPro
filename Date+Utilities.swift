//
//  Date+Utilities.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/26/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import Foundation
extension Date{
    func startOfToday()->Date{
        let start = Calendar.current.startOfDay(for: self)
        return start
    }
    func endOfTheDay() ->Date{
        var time = Date().startOfToday()
        time.addTimeInterval(24*3600)
        return time
    }
}
