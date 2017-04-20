//
//  PlantListTableViewController.swift
//  Excited
//
//  Created by Emoin Lam on 18/04/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit

class PlantListTableViewController: UITableViewController {
    // MARK: Properties
    var defaultPlantTypes = DefaultPlantTypes()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadSamples()
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
        // #warning Incomplete implementation, return the number of rows
        return defaultPlantTypes.countPlantTypes()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewPlantTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewPlantTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewPlantTableViewCell.")
        }
        
        let index = indexPath.row
        cell.PlantName.text = defaultPlantTypes.getDefaultPlantNameByID(id: index)
        cell.PlantImage.image = defaultPlantTypes.getDefaultPlantImageByID(id: index)
        
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
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        /*
        guard let newPlantAddingViewController = segue.destination as? AddPlantViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        */
        
        guard let newPlantAddingViewController = segue.destination as? AddPlantNavigationViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedPlantCell = sender as? NewPlantTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        guard let indexPath = tableView.indexPath(for: selectedPlantCell) else {
            fatalError("The selected cell is not being displayed by the table.")
        }
        
        let selectedPlantType = defaultPlantTypes.getDefaultPlantTypeByID(id: indexPath.row)
        //print("Selected Type: \(selectedPlantType)")
        newPlantAddingViewController.setPlantType(type: selectedPlantType)
        
        /*
        let vc = AddPlantViewController()
        vc.setPlantType(type: selectedPlantType)
        newPlantAddingViewController.pushViewController(vc, animated: true)
        newPlantAddingViewController.popToRootViewController(animated: true)
        newPlantAddingViewController
        */
     }
 
    
    // MARK: Methods
    func loadSamples() {
        
    }

}
