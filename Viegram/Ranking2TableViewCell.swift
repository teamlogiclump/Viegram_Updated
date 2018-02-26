//
//  Ranking2TableViewCell.swift
//  Viegram
//
//  Created by Relinns on 29/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class Ranking2TableViewCell: UITableViewCell {

    @IBOutlet weak var headertitle: UILabel!
    @IBOutlet weak var imgT2: UIImageView!
    @IBOutlet weak var nameT2: UILabel!
    @IBOutlet weak var positionT2: UILabel!
    @IBOutlet weak var imgbtn: UIButton!
    @IBOutlet weak var namebtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
