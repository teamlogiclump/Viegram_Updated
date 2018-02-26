//
//  notiTableViewCell.swift
//  Viegram
//
//  Created by Relinns on 02/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class notiTableViewCell: UITableViewCell {

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var titile: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var event: UILabel!
    
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var decline: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
