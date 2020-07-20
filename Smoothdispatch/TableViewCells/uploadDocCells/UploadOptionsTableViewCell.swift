//
//  UploadOptionsTableViewCell.swift
//  Smoothdispatch
//
//  Created by Ravinder on 18/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class UploadOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet var billOfLandingPAge: UIButton!
    
    @IBOutlet var diversionImageBtn: UIButton!
    
    @IBOutlet var detentionBtn: UIButton!
    
    @IBOutlet var miscBtn: UIButton!
    
    @IBOutlet var radio1: UIImageView!
    
    @IBOutlet var radio2: UIImageView!
    
    @IBOutlet var radio3: UIImageView!
    
    @IBOutlet var radio4: UIImageView!
    
    @IBOutlet var orderTxtfld: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
