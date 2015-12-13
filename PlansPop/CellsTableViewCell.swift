//
//  CellsTableViewCell.swift
//  PlansPop
//
//  Created by Aplimovil on 12/10/15.
//  Copyright © 2015 Aplimovil. All rights reserved.
//

import UIKit

class CellsTableViewCell: UITableViewCell {

    @IBOutlet var title:UILabel!
    @IBOutlet var desc:UITextView!
    @IBOutlet var date:UILabel!
    @IBOutlet var hour:UILabel!
    @IBOutlet var place:UITextView!
    @IBOutlet var assist:UILabel!
    @IBOutlet var img:UIImageView!
    @IBOutlet weak var view_cell: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
