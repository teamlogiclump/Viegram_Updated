//
//  followingTableViewCell.swift
//  Viegram
//
//  Created by Relinns on 30/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class followingTableViewCell: UITableViewCell {

    @IBOutlet weak var folloerImg: UIImageView!
    @IBOutlet weak var folloersName: UILabel!
    
    
    @IBOutlet weak var followyouT1: UIButton!
      @IBOutlet weak var followT1: UIButton!
      @IBOutlet weak var followT2: UIButton!
    
    @IBOutlet weak var unfollowT1: UIButton!
    @IBOutlet weak var unfollowT2: UIButton!
    @IBOutlet weak var profileview: UIButton!
    @IBOutlet weak var _img2: UIImageView!
    @IBOutlet weak var _name2: UILabel!
    @IBOutlet weak var _followyou: UIButton!
    @IBOutlet weak var _profile: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
