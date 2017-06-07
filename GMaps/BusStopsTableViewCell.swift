//
//  BusStopsTableViewCell.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 6/5/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit

class BusStopsTableViewCell: UITableViewCell {

    @IBOutlet weak var busStopLatLabel: UILabel!
    @IBOutlet weak var busStopLonLabel: UILabel!
    @IBOutlet weak var busStopNameLabel: UILabel!
    @IBOutlet weak var busStopCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
