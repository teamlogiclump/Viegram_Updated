//
//  RAnkingTableViewCell.swift
//  Viegram
//
//  Created by Relinns on 29/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class RAnkingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title1lbl: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var trophy: UIImageView!

    @IBOutlet weak var linelbl: UILabel!
    @IBOutlet weak var postion2: UILabel!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var namelbl2: UILabel!
    @IBOutlet weak var postionlbl2: UILabel!
    @IBOutlet weak var profileview: UIButton!
    @IBOutlet weak var linelbl1: UILabel!
    @IBOutlet weak var trophyicon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
