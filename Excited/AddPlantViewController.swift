//
//  AddPlantViewController.swift
//  Excited
//
//  Created by Emoin Lam on 31/03/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
import os.log

class AddPlantViewController: UIViewController,UITextFieldDelegate,  UINavigationControllerDelegate {
    // MARK: Properties
    private var newPlantType: PlantType = .Default
    private var newType = PassNewType()
    @IBOutlet weak var addPlant: UIBarButtonItem!
    @IBOutlet weak var plantName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //newPlantType = passValue!
        newPlantType = newType.get()
        //print("New View Controller Received PlantType: \(newPlantType)")
        
        /*
        let owningNavigationController = presentingViewController as! AddPlantNavigationViewController
        newPlantType = owningNavigationController.getPlantType()
        */
        
        plantName.delegate = self
        
        updateAddPlantButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        plantName.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addPlant.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateAddPlantButtonState()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === addPlant else {
            return
        }
    }
 
    
    // MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Public Methods
    func setPlantType(type: PlantType) {
        newPlantType = type
    }
    
    func getNewPlantType() -> PlantType {
        return newPlantType
    }
    
    func getNewPlantName() -> String {
        return plantName.text!
    }
    
    
    // MARK: Private Methods
    private func updateAddPlantButtonState() {
        let text = plantName.text ?? ""
        addPlant.isEnabled = !text.isEmpty
    }

}
