//
//  Schedule.swift
//  Excited
//
//  Created by Emoin Lam on 15/04/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
import os.log

let MONTH_TRANSFER = 100
let YEAR_TRANSFER = 10000
let HOUR_TRANSFER = 100

/*
 Time is a manually defined type for time recording
 comparison operators are overloaded for Time type object comparison
*/
struct Time {
    
    // MARK: Properties
    var _day: Int
    var _month: Int
    var _year: Int
    var _hour: Int
    var _minute: Int
    
    init(day: Int, month: Int, year: Int, hour: Int, minute: Int) {
        _day = day
        _month = month
        _year = year
        _hour = hour
        _minute = minute
    }
    
    func getTime() -> String {
        var ret = String(stringInterpolationSegment: _hour) + ":" + String(stringInterpolationSegment: _minute)
        ret += " " + String(stringInterpolationSegment: _day) + "/" + String(stringInterpolationSegment: _month) + "/" + String(stringInterpolationSegment: _year)
        return ret
    }
}

func >(left: Time, right: Time) -> Bool {
    let leftDate = left._day + left._month * MONTH_TRANSFER + left._year * YEAR_TRANSFER
    let rightDate = right._day + right._month * MONTH_TRANSFER + right._year * YEAR_TRANSFER
    let leftTime = left._minute + left._hour * HOUR_TRANSFER
    let rightTime = right._minute + right._hour * HOUR_TRANSFER
    
    if leftDate == rightDate {
        return (leftTime > rightTime)
    }
    else {
        return (leftDate > rightDate)
    }
}

func <(left: Time, right: Time) -> Bool {
    let leftDate = left._day + left._month * MONTH_TRANSFER + left._year * YEAR_TRANSFER
    let rightDate = right._day + right._month * MONTH_TRANSFER + right._year * YEAR_TRANSFER
    let leftTime = left._minute + left._hour * HOUR_TRANSFER
    let rightTime = right._minute + right._hour * HOUR_TRANSFER
    
    if leftDate == rightDate {
        return (leftTime < rightTime)
    }
    else {
        return (leftDate < rightDate)
    }
}

func ==(left: Time, right: Time) -> Bool {
    let leftDate = left._day + left._month * MONTH_TRANSFER + left._year * YEAR_TRANSFER
    let rightDate = right._day + right._month * MONTH_TRANSFER + right._year * YEAR_TRANSFER
    let leftTime = left._minute + left._hour * HOUR_TRANSFER
    let rightTime = right._minute + right._hour * HOUR_TRANSFER
    
    if leftDate == rightDate {
        return (leftTime == rightTime)
    }
    else {
        return false
    }
}

/*
 Task Functionalities
 - presents the type of a task
 - it is an enum type
 
 Task Properties
 - use .(typename) to represent a plant needs a certain type of operating
 */
enum Task {
    case Watering
    case Illuminating
}

/*
 Schedule Functionalities
    - stores information of a schedule
    - contains the information of its belonging and its carrying-out time and task
 
 Schedule Properties
    - _PID stores the index of the plant it belongs to at in the plantManager.plants array
    - _SIDPrime stores the index it is at in the plantManager.schedules array, representing its place in total scheduling
    - _SIDVice stores the index it is at in the plant._schedules array, representing its place in private scheduling
*/
class Schedule {
    
    // MARK: Properties
    private var _PID: Int?
    private var _SIDPrime: Int?
    private var _SIDVice: Int?
    private var _time: Time
    private var _task: Task
    
    // MARK: Initialization
    init(time: Time, task: Task) {
        self._time = time
        self._task = task
    }
    
    // MARK: Public Methods
    func getPID() -> Int {
        return _PID!
    }
    
    func getSIDPrime() -> Int {
        return _SIDPrime!
    }
    
    func getSIDVice() -> Int {
        return _SIDVice!
    }
    
    func setPID(id: Int) {
        _PID = id
    }
    
    func setSIDPrime(id: Int) {
        _SIDPrime = id
    }
    
    func setSIDVice(id: Int) {
        _SIDVice = id
    }
    
    func getTask() -> String {
        switch _task {
        case .Watering:
            return "watering"
        case .Illuminating:
            return "illuminating"
        }
    }
    
    func getTime() -> String {
        return _time.getTime()
    }
    
    func getTimeType() -> Time {
        return _time
    }
}
