//
//  AUserfollowerTableViewCell.swift
//  Viegram
//
//  Created by Relinns on 31/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class AUserfollowerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var folloerImg: UIImageView!
    @IBOutlet weak var folloersName: UILabel!
    
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var restrictBtn: UIButton!
  
    @IBOutlet weak var followyou: UIButton!
    @IBOutlet weak var unfollowT2: UIButton!
   
  

   
    
    @IBOutlet weak var prfileviewbtn: UIButton!
   
    
    @IBOutlet weak var prfileviewbtncell3: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
