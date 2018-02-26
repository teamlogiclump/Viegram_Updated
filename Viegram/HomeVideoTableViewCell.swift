//
//  HomeVideoTableViewCell.swift
//  Viegram
//
//  Created by Relinns on 18/08/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class HomeVideoTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imgPostHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var lbl_postTime: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lbl_postText: UILabel!
    @IBOutlet weak var auserbtn: UIButton!
    @IBOutlet weak var deletebtn: UIButton!
    
    @IBOutlet weak var videoview: UIView!
    @IBOutlet weak var lbl_points: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var openphototime: UILabel!
    
    
    @IBOutlet weak var star: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
