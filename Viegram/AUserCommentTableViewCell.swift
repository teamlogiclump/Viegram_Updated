//
//  AUserCommentTableViewCell.swift
//  Viegram
//
//  Created by Relinns on 31/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class AUserCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var _img: UIImageView!
    @IBOutlet weak var _name: UILabel!
    @IBOutlet weak var _comment: UITextView!
    @IBOutlet weak var _time: UILabel!
    @IBOutlet weak var _likebtn: UIButton!
    @IBOutlet weak var _totallikes: UILabel!
    @IBOutlet weak var _imgstar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

