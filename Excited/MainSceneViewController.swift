//
//  ViewController.swift
//  Excited
//
//  Created by Emoin Lam on 29/03/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit

class MainSceneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var ShowPlant: UIButton!
    @IBOutlet weak var ShowPrivateSchedule: UIButton!
    @IBOutlet weak var ShowInteraction: UIButton!
    @IBOutlet weak var SubviewController: UIView!
    @IBOutlet weak var PlantDisplayer: UIView!
    @IBOutlet weak var PrivateSchedule: UITableView!
    
    private var plantManager = PlantManager()
    private var displayedPlantID = Int(0)
    private var displayedPlant = Plant(name: "Default", ID: -1, plantType: .Default)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.PrivateSchedule.delegate = self
        self.PrivateSchedule.dataSource = self
        //PrivateSchedule.deleteSections([0], with: .none)
        /*
        let countRows = PrivateSchedule.numberOfRows(inSection: 0)
        for _ in 0 ..< countRows {
            PrivateSchedule.deleteRows(at: PrivateSchedule.indexPathsForVisibleRows!, with: .none)
        }
        */
        
        //self.view.addSubview(self.PrivateSchedule)
        //self.PrivateSchedule.tableFooterView = UIView()
        if displayedPlant.getID() == -1 {
            loadSamples()
        }
        //print("VIEWDIDLOAD PLACE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("VIEWWILLAPPEAR PLACE")
        displayedPlant.sortSchedules()
        rearrange()
        /*
        var reloadIndexPaths = [IndexPath]()
        for index in 0 ..< tableView(PrivateSchedule, numberOfRowsInSection: 0) {
            reloadIndexPaths += [IndexPath(row: index, section: 0)]
        }
        PrivateSchedule.reloadRows(at: reloadIndexPaths, with: .none)
        */
        PrivateSchedule.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func DisplayPlantInformation(_ sender: UIButton) {
        SubviewController.bringSubview(toFront: PlantDisplayer)
    }
    
    @IBAction func DisplayPrivateSchedule(_ sender: UIButton) {
        SubviewController.bringSubview(toFront: PrivateSchedule)
    }
    
    @IBAction func unwindToMainScene(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? AddPlantViewController else {
            return
        }
        let plantType = sourceViewController.getNewPlantType()
        let plantName = sourceViewController.getNewPlantName()
        
        addNewPlant(name: plantName, type: plantType)
    }
    
    
    // MARK: Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("QUERYED!")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedPlant.countSchedules()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ScheduleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        //print("\(displayedPlant.countSchedules()) \(indexPath.row) \(tableView.numberOfRows(inSection: 0))")
        let index = indexPath.row
        
        let schedule = displayedPlant.getSchedule(id: displayedPlant.getSortedScheduleIDByRank(id: index))
        
        cell.PlantName.text = displayedPlant.getName()
        cell.ActionName.text = schedule.getTask()
        cell.TimeLabel.text = schedule.getTime()
        
        return cell
    }
    
    
    // MARK: Private Methods
    private func loadSamples() {
        var _ = plantManager.addPlant(name: "TRY1", type: .AppleFlower)
        var time = Time(day: 1, month: 5, year: 2017, hour: 22, minute: 0)
        var schedule = Schedule(time: time, task: .Watering)
        var errorCheck = plantManager.addSchedule(id: 0, schedule: schedule)
        if errorCheck == false {
            return
        }
        time = Time(day: 1, month: 5, year: 2017, hour: 12, minute: 0)
        schedule = Schedule(time: time, task: .Watering)
        if errorCheck == false {
            return
        }
        errorCheck = plantManager.addSchedule(id: 0, schedule: schedule)
        _ = plantManager.addPlant(name: "TRY2", type: .AppleFlower)
        for _ in 0 ..< 20 {
            time = Time(day: 1, month: 5, year: 2017, hour: 21, minute: 0)
            schedule = Schedule(time: time, task: .Watering)
            errorCheck = plantManager.addSchedule(id: 1, schedule: schedule)
            if errorCheck == false {
                return
            }
        }
        displayedPlantID = 1
        displayedPlant = plantManager.getPlantByID(id: displayedPlantID)
    }
    
    private func addNewPlant(name: String, type: PlantType) {
        let newPlantID = plantManager.addPlant(name: name, type: type)
        let time = Time(day: 1, month: 5, year: 2017, hour: 22, minute: 0)
        let schedule = Schedule(time: time, task: .Watering)
        let errorCheck = plantManager.addSchedule(id: newPlantID, schedule: schedule)
        if errorCheck == false {
            return
        }
        displayedPlantID = newPlantID
        displayedPlant = plantManager.getPlantByID(id: displayedPlantID)
        
        rearrange()
        //print("\(tableView(PrivateSchedule, numberOfRowsInSection: 0)) \(displayedPlantID)")
        //let newIndexPath = IndexPath(row: 0, section: 0)
        //PrivateSchedule.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    private func rearrange() {
        let countRows = PrivateSchedule.numberOfRows(inSection: 0)
        let newRowsCount = displayedPlant.countSchedules()
        var disparity = newRowsCount - countRows
        
        if disparity == 0 {
            return
        }
        else if disparity > 0 {
            var tmp = [IndexPath]()
            for Index in 0 ..< disparity {
                tmp += [IndexPath(row: countRows + Index, section: 0)]
            }
            PrivateSchedule.insertRows(at: tmp, with: .none)
        }
        else {
            var tmp = [IndexPath]()
            disparity = -disparity
            for index in 0 ..< disparity {
                tmp += [IndexPath(row: countRows - 1 - index, section: 0)]
            }
            PrivateSchedule.deleteRows(at: tmp, with: .none)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowOverallSchedule":
            guard let showOverallScheduleViewController = segue.destination as? OverallSchedule else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            showOverallScheduleViewController.transferredPlantManager = plantManager
            break
            
        default:
            print("Default")
        }
    }

}

