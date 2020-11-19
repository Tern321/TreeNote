//
//  ActionTableViewCell.swift
//  TreeNote
//
//  Created by Evgenii Loshchenko on 13.11.2020.
//

import UIKit

class ActionTableViewCell: UITableViewCell {

    public var cellAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        

        if selected
        {
            self.cellAction?();
        }
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
    
}
