//
//  DefaultPlantTypes.swift
//  Excited
//
//  Created by Emoin Lam on 18/04/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
import os.log

/*
 DefaultPlantTypes Functionalities
    - Stores the preset types of plants for adding
    - The content is determined by plant database which is now unaccessible
    - Used in PlantListTableViewController
    - Change the content by implementing loadSamples() function
*/
class DefaultPlantTypes {
    // MARK: Properties
    private var _defaultPlantNames = [String]()
    private var _defaultPlantImages = [UIImage]()
    private var _defaultPlantTypes = [PlantType]()
    private var _typesCount: Int
    
    init() {
        _typesCount = 0
        
        loadSamples()
    }
    
    // MARK: Public Methods
    func countPlantTypes() -> Int {
        return _typesCount
    }
    
    func getDefaultPlantNameByID(id: Int) -> String {
        return _defaultPlantNames[id]
    }
    
    func getDefaultPlantImageByID(id: Int) -> UIImage {
        return _defaultPlantImages[id]
    }
    
    func getDefaultPlantTypeByID(id: Int) -> PlantType {
        return _defaultPlantTypes[id]
    }
    
    func getDefaultPlantIDByType(type: PlantType) -> Int {
        for index in 0 ..< _typesCount {
            if _defaultPlantTypes[index] == type {
                return index
            }
        }
        return -1
    }
    
    // MARK: Private Methods
    private func loadSamples() {
        for index in 0 ..< 3 {
            addDefaultPlant(name: "AppleFlower\(index)", image: #imageLiteral(resourceName: "defaultImage"), type: .AppleFlower)
        }
    }
    
    private func addDefaultPlant(name: String, image: UIImage, type: PlantType) {
        _defaultPlantTypes += [type]
        _defaultPlantImages += [image]
        _defaultPlantNames += [name]
        _typesCount += 1
    }
}
