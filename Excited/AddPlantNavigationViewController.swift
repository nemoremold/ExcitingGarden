//
//  AddPlantNavigationViewController.swift
//  Excited
//
//  Created by Emoin Lam on 19/04/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
import os.log

// Used for global data transferring as alternative to segue data passing
class PassNewType {
    static private var newType: PlantType?
    /*
    func set(type: PlantType) {
        PassNewType.newType = type
    }
    */
    func set(nav: AddPlantNavigationViewController) {
        let guardian = nav.getPlantType()
        if guardian == .Default {
            return
        }
        PassNewType.newType = nav.getPlantType()
    }
    func get() -> PlantType {
        return PassNewType.newType!
    }
}

class AddPlantNavigationViewController: UINavigationController {
    // MARK: Properties
    private var newPlantType: PlantType = .Default
    private var passNewType = PassNewType()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print("Navigation Received PlantType: \(newPlantType)")
        
        //passValue = newPlantType
        //passNewType.set(type: newPlantType)
        passNewType.set(nav: self)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AddPlantViewController") as? AddPlantViewController
        viewController?.setPlantType(type: newPlantType)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override init(rootViewController: UIViewController) {
        let getNewControllerType = rootViewController as! AddPlantViewController
        super.init(rootViewController: getNewControllerType)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let getNewControllerType = viewController as! AddPlantViewController
        getNewControllerType.setPlantType(type: newPlantType)
        super.pushViewController(getNewControllerType, animated: animated)
    }
 
    func show(_ vc: AddPlantViewController, sender: Any?) {
        super.show(vc, sender: sender)
        //vc.setPlantType(type: newPlantType)
    }
    */
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "presentAddPlant" {
            print("Stage Check: Navigation Did Present Its Root View.")
            guard let newPlantAddingViewController = segue.destination as? AddPlantViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            newPlantAddingViewController.setPlantType(type: newPlantType)
            
        }
    }
    
    // MARK: Public Methods
    func setPlantType(type: PlantType) {
        newPlantType = type
    }
    
    func getPlantType() -> PlantType {
        return newPlantType
    }

}
