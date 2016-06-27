//
//  InputCell.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/26/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class InputCell: UITableViewCell {

    @IBOutlet weak var meetingTitle: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
