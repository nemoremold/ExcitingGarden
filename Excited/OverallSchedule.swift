//
//  OverallSchedule.swift
//  Excited
//
//  Created by Emoin Lam on 31/03/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit

class OverallSchedule: UITableViewController {
    // MARK: Properties
    var plantManager = PlantManager()
    var transferredPlantManager: PlantManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if (transferredPlantManager != nil) {
            plantManager = transferredPlantManager!
        }
        else {
            loadSamples()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        plantManager.sortSchedules()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantManager.countSchedules()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ScheduleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        let index = indexPath.row
        
        let schedule = plantManager.getSchedule(id: plantManager.getSortedScheduleIDByRank(id: index))

        cell.PlantName.text = plantManager.getPlantNameOfSchedule(id: index)
        cell.ActionName.text = schedule.getTask()
        cell.TimeLabel.text = schedule.getTime()

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Methods
    private func loadSamples() {
        var _ = plantManager.addPlant(name: "TRY1", type: .AppleFlower)
        var time = Time(day: 1, month: 5, year: 2017, hour: 22, minute: 0)
        var schedule = Schedule(time: time, task: .Watering)
        var errorCheck = plantManager.addSchedule(id: 0, schedule: schedule)
        if errorCheck == false {
            return
        }
        _ = plantManager.addPlant(name: "TRY2", type: .AppleFlower)
        time = Time(day: 1, month: 5, year: 2017, hour: 21, minute: 0)
        schedule = Schedule(time: time, task: .Watering)
        errorCheck = plantManager.addSchedule(id: 0, schedule: schedule)
        if errorCheck == false {
            return
        }
        errorCheck = plantManager.deletePlant(id: 0)
        plantManager.sortSchedules()
    }

}
