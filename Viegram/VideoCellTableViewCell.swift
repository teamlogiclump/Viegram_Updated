//
//  VideoCellTableViewCell.swift
//  Viegram
//
//  Created by Relinns on 24/08/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCellTableViewCell: UITableViewCell {

    
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
   
     @IBOutlet weak var openProfileBtn: UIButton!
    @IBOutlet weak var videoview: UIView!
    @IBOutlet weak var lbl_points: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var star: UIImageView!
    
    
    
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    var timeWatcher : AnyObject!
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.setupMoviePlayer()
    }
    
    func setupMoviePlayer(){
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
       // avPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspect
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
//        if UIScreen.main.bounds.width == 375 {
//            let widthRequired = self.frame.size.width - 20
//            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
//        }else if UIScreen.main.bounds.width == 320 {
//            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: (self.frame.size.height - 120) * 1.78, height: self.frame.size.height - 120)
//            
//        }else{
//            let widthRequired = self.frame.size.width
//            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
//        }
        videoview.backgroundColor = UIColor.red
        avPlayerLayer?.frame = videoview.layer.bounds
       videoview.layer.addSublayer(avPlayerLayer!)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
        
        
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }
    
    func startPlayback(){
        self.avPlayer?.play()
    }
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
}



