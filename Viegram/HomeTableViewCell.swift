//
//  HomeTableViewCell.swift
//  Viegram
//
//  Created by Apple on 5/25/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import AVFoundation


public enum kJPPlayUnreachCellStyle : Int {
    
    case none // normal cell.
    
    case up // top .
    
    case down // bottom .
}
class HomeTableViewCell: UITableViewCell {

    var isPlaying = "stopped"
    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var imgPostHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lbl_postTime: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lbl_postText: UILabel!
    @IBOutlet weak var auserbtn: UIButton!
    @IBOutlet weak var deletebtn: UIButton!
    
    @IBOutlet weak var videoview: UIView!
    @IBOutlet weak var lbl_points: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var openProfileBtn: UIButton!
    @IBOutlet weak var openphototime: UILabel!

    @IBOutlet weak var star: UIImageView!
    var fileTypeImage = false
   
    
    public var videoPath = String()
    
    public var indexPath: IndexPath {
        get {
            return self.indexPath
        }
        set {
            
        }
    }
    public var cellStyle : kJPPlayUnreachCellStyle?
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func prepareForReuse() {
        self.playbutton.isHidden = self.fileTypeImage
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
