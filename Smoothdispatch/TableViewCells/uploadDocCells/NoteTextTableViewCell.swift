//
//  NoteTextTableViewCell.swift
//  Smoothdispatch
//
//  Created by Ravinder on 18/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit

class NoteTextTableViewCell: UITableViewCell {
    
    @IBOutlet var noteLbl: UILabel!
    
    @IBOutlet var noteTxView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteTxView.layer.cornerRadius = 5
        
        noteTxView.layer.borderWidth = 2
        
        noteTxView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}
