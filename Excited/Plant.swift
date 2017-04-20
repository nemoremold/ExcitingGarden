//
//  Plant.swift
//  Excited
//
//  Created by Emoin Lam on 15/04/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
import os.log

/*
 save use as define in cpp
 sets the magic numbers in PlantStatus class
*/
let EXP_BONUS = 500
let START_LEVEL = 1
let START_EXP = 0

/*
 PlantType Functionalities
    - presents the type of a plant
    - it is an enum type
 
 PlantType Properties
    - use .Default to represent a plant that is not defined
    - use .(typename) to represent a plant type
*/
enum PlantType {
    case Default
    case AppleFlower
}

/*
 PlantStatus Functionalities
    - the class object manages the level attribute of the plant
    - at present the status is irrelevant to PlantType
    - the status should be relevant to PlantType
    - the design of the relationship between PlantStatus and PlantType is impossible without the support of database
 
 PlantStatus Properties
    - _exp stores the current experience of a plant, it is changed by whether tasks are finished on schedule(the changing method is yet to be implemented)
    - _expLimit limits the maximum value of _exp. When _exp reaches or exceeds _expLimit, _level will be changed correspondingly
    - _level represents the current stage of the plant
*/
class PlantStatus {
    // MARK: Properties
    var _expLimit: Int
    var _exp: Int {
        didSet {
            setupLevel()
        }
    }
    var _level: Int {
        didSet {
            setupLimit()
        }
    }
    
    // MARK: Initialization
    init() {
        _expLimit = EXP_BONUS
        _level = START_LEVEL
        _exp = START_EXP
    }
    
    // MARK: Private Methods
    private func setupLevel() {
        while _exp >= _expLimit {
            _exp = _exp - _expLimit
            _level = _level + 1;
        }
    }
    
    private func setupLimit() {
        _expLimit = _level * EXP_BONUS
    }
}

/*
 Plant Functionalities
    - stores the information of a created and initialized plant
    - manages the schedules of its own
 
 Plant Properties
    - _ID is the index of the plant in the plantManager
    - _schedules array stores the private schedules of the certain plant
    - _schedulesHash helps to determine whether the index of the _schedules array is used
    - _schedulesSort helps to sort the schedules by their time, it stores the index of the _schedules array, and is sorted without changing _schedules array
    - _schedulesManager is a ListManager type object that helps to manage adding and deleting of schedules
    - _newlyScheduled stores the lastest added schedule's SIDVice(vice schedule ID), representing the schedule's index in _schedules array
    - _schedulesCount stores the number of valid schedules in _schedules array and is used when adding schedules
 
 Plant Methods
    - addSchedule(schedule: Schedule) inserts a non-nil Schedule object into the _schedules array. If the insertion succeeds the function will return with true, else it returns with false
    - deleteSchedule(id: Int) will change _schedulesHash array element with index id to false, indicating that this schedule is deleted and this index of the _schedules array is able to be reused
    - sortSchedules() will sort the _schedulesSort array. it will be sorted by the time of schedules in _schedules array from nearest task to the further most task
    - getSortedScheduleIDByRank(id: Int) get the (id)st nearest task. The return type is Int
*/
class Plant {
    // MARK: Properties
    private var _name: String
    private var _ID: Int
    private var _plantType: PlantType
    private var _plantStatus = PlantStatus()
    private var _schedules = [Schedule]()
    private var _schedulesHash = [Bool]()
    private var _schedulesSort = [Int]()
    private var _schedulsManager = ListManager(id: DEFAULT_STARTER, end: DEFAULT_END)
    private var _newlyScheduled: Int
    private var _schedulesCount: Int
    
    // MARK: Initialization
    init(name: String, ID: Int, plantType: PlantType) {
        self._name = name
        self._ID = ID
        self._plantType = plantType
        self._schedulesCount = 0
        self._newlyScheduled = -1
    }
    
    // MARK: Public Methods
    func addSchedule(schedule: Schedule) -> Bool {
        if schedule.getPID() != self._ID {
            os_log("Failed to schedule ...", log: OSLog.default, type: .error)
            return false
        }
        else {
            let newScheduleIndex = _schedulsManager.getNextIndex()
            _newlyScheduled = newScheduleIndex
            schedule.setSIDVice(id: newScheduleIndex)
            if newScheduleIndex >= _schedules.count {
                _schedules += [schedule]
                _schedulesHash += [true]
                _schedulesSort += [newScheduleIndex]
            }
            else {
                _schedules[newScheduleIndex] = schedule
                _schedulesHash[newScheduleIndex] = true
            }
            _schedulesCount += 1
            return true
        }
    }
    
    func deleteSchedule(id: Int) -> Bool {
        if (id >= _schedulsManager._end) || (_schedulesHash[id] == false) {
            return false
        }
        _schedulsManager = _schedulsManager.deleteIndex(index: id)
        _schedulesHash[id] = false
        _schedulesCount -= 1
        return true
    }
    
    func getID() -> Int {
        return _ID
    }
    
    func getSIDVice() -> Int {
        return _newlyScheduled
    }
    
    func getName() -> String {
        return _name
    }
    
    func getSchedule(id: Int) -> Schedule {
        return _schedules[id]
    }
    
    func sortSchedules() {
        _schedulesSort = _schedulesSort.sorted(by: { (id1: Int, id2: Int) -> Bool in return _schedulesHash[id2] && (!_schedulesHash[id1] || (_schedules[id2].getTimeType() > _schedules[id1].getTimeType())) })
    }
    
    func getSortedScheduleIDByRank(id: Int) -> Int {
        if id >= _schedulesSort.count {
            return ERROR_MARK
        }
        else {
            return _schedulesSort[id]
        }
    }
    
    func deleteAllSchedules() -> [Int] {
        sortSchedules()
        var ret = [Int]()
        for index in 0 ..< _schedulesCount {
            ret += [_schedules[_schedulesSort[index]].getPID()]
            let check = deleteSchedule(id: _schedulesSort[index])
            if check == false {
                fatalError("delete all schedules of plant: \(_ID) failed.")
            }
        }
        return ret
    }
    
    func countSchedules() -> Int {
        return _schedulesCount
    }
    // MARK: Private Methods
    
}
