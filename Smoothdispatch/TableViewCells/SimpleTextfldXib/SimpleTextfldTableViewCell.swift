//
//  SimpleTextfldTableViewCell.swift
//  Smoothdispatch
//
//  Created by Ravinder on 18/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class SimpleTextfldTableViewCell: UITableViewCell {

    @IBOutlet var textfield: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
