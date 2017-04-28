//
//  PlantManager.swift
//  Excited
//
//  Created by Emoin Lam on 15/04/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
import os.log

let DEFAULT_STARTER = 0
let DEFAULT_END = 1
let ERROR_MARK = -1

/*
 PlantManager Functionalities
    - The overall manager of all plants and schedules
    - Stores all the information of plants and their schedules
    - Arranges overall schedules
*/
class PlantManager {
    // MARK: Properties
    private var plants = [Plant]()
    private var plantsHash = [Bool]()
    private var schedules = [Schedule]()
    private var schedulesHash = [Bool]()
    private var schedulesSort = [Int]()
    private var plantsManager: ListManager
    private var schedulesManager: ListManager
    private var schedulesCount: Int
    private var plantsCount: Int
    
    // MARK: Initialization
    init() {
        plantsManager = ListManager(id: DEFAULT_STARTER, end: DEFAULT_END)
        schedulesManager = ListManager(id: DEFAULT_STARTER, end: DEFAULT_END)
        schedulesCount = 0
        plantsCount = 0
    }
    
    // MARK: Methods
    func addPlant(name: String, type: PlantType) -> Int {
        let newPlantIndex = plantsManager.getNextIndex()
        let newPlant = Plant(name: name, ID: newPlantIndex, plantType: type)
        if newPlantIndex >= plants.count {
            plants += [newPlant]
            plantsHash += [true]
        }
        else {
            plants[newPlantIndex] = newPlant
            plantsHash[newPlantIndex] = true
        }
        plantsCount += 1
        return newPlantIndex
    }
    
    func deletePlant(id: Int) -> Bool {
        if (id >= plantsManager._end) || (plantsHash[id] == false) {
            return false
        }
        else {
            plantsManager = plantsManager.deleteIndex(index: id)
            plantsHash[id] = false
            let deletedSchedules = plants[id].deleteAllSchedules()
            for index in deletedSchedules {
                let check = deleteSchedule(id: index)
                if check == false {
                    return false
                }
            }
            
            plantsCount -= 1
            return true
        }
    }
    
    func addSchedule(id: Int, schedule: Schedule) -> Bool {
        if (plantsHash[id] == true) {
            schedule.setPID(id: id)
            if plants[id].addSchedule(schedule: schedule) {
                schedule.setSIDVice(id: plants[id].getSIDVice())
                let newScheduleIndex = schedulesManager.getNextIndex()
                schedule.setSIDPrime(id: newScheduleIndex)
                if newScheduleIndex >= schedules.count {
                    schedules += [schedule]
                    schedulesHash += [true]
                    schedulesSort += [newScheduleIndex]
                }
                else {
                    schedules[newScheduleIndex] = schedule
                    schedulesHash[newScheduleIndex] = true
                }
                schedulesCount += 1
                return true
            }
            return false
        }
        else {
            os_log("Failed to schedule ...", log: OSLog.default, type: .error)
            return false
        }
    }
    
    func deleteSchedule(id: Int) -> Bool {
        if (id >= schedulesManager._end) || (schedulesHash[id] == false) {
            return false
        }
        else {
            schedulesManager = schedulesManager.deleteIndex(index: id)
            schedulesHash[id] = false
            schedulesCount -= 1
            return true
        }
    }
    
    func countSchedules() -> Int {
        return schedulesCount
    }
    
    func getSchedule(id: Int) -> Schedule {
        return schedules[id]
    }
    
    func getPlantNameOfSchedule(id: Int) -> String {
        return plants[schedules[id].getPID()].getName()
    }
    
    func sortSchedules() {
        schedulesSort = schedulesSort.sorted(by: { (id1: Int, id2: Int) -> Bool in return schedulesHash[id2] && (!schedulesHash[id1] || (schedules[id2].getTimeType() > schedules[id1].getTimeType())) })
    }
    
    func getSortedScheduleIDByRank(id: Int) -> Int {
        if id >= schedulesSort.count {
            return ERROR_MARK
        }
        else {
            return schedulesSort[id]
        }
    }
    
    func getPlantByID(id: Int) -> Plant {
        return plants[id]
    }
}
