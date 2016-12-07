//
//  beaconTableViewCell.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/17/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class beaconTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var frontIcon: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = bgView.frame.size.height/2
        bgView.layer.masksToBounds = true
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 1
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
