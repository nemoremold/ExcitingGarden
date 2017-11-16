//
//  ScheduleTableViewCell.swift
//  Excited
//
//  Created by Emoin Lam on 31/03/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit

/*
 ScheduleTableViewCell Functionalities
    - Set reused cell for schedule display
*/
class ScheduleTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var PlantName: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var ActionName: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
