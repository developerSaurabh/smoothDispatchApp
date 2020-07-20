//
//  SaveSettingsBtnTableViewCell.swift
//  Smoothdispatch
//
//  Created by Ravinder on 18/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit

class SaveSettingsBtnTableViewCell: UITableViewCell {
    
    @IBOutlet var setingsBrn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setingsBrn.layer.cornerRadius = 5
        setingsBrn.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
