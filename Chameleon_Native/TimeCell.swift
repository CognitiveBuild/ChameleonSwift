//
//  TimeCell.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/26/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {

    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var timeContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
