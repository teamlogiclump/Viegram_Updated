//
//  FolllowpeopleTableViewCell.swift
//  Viegram
//
//  Created by Jagdeep on 04/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class FolllowpeopleTableViewCell: UITableViewCell {
    @IBOutlet weak var imgBlockUser: UIImageView!

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var btn1following: UIButton!
    @IBOutlet weak var btnBlock: UIButton!
    
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var profilebtn: UIButton!
    @IBOutlet weak var profilebtn1: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
