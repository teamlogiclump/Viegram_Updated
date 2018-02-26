//
//  StatusviewTableViewCell.swift
//  
//
//  Created by Relinns on 29/05/17.
//
//

import UIKit

class StatusviewTableViewCell: UITableViewCell {

    @IBOutlet weak var earned_point: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var lastlbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
