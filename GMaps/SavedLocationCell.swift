//
//  SavedLocationCell.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 5/13/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit

class SavedLocationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
