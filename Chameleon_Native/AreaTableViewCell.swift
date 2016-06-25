//
//  AreaTableViewCell.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/21/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class AreaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var deslabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

