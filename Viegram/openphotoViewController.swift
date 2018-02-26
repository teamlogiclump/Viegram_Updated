//
//  openphotoViewController.swift
//  Viegram
//
//  Created by Relinns on 23/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import AVFoundation
import MMPlayerView
import MBProgressHUD


protocol OpenPhotoViewControllerDelegate: class
{
    func postDeleted(from position:Int)
    func backCalling()

}

class openphotoViewController: UIViewController {
    weak var delegate: OpenPhotoViewControllerDelegate?
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravityResizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
    var feeditem : FeedPostModel?
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var navbar: UINavigationBar!
    var postData = [String:Any]()
    var circularview:CircularMenu?
    var userid = String()
    var postid = String()
    var deletephoto = false
    var indexofPost: Int = Int()
    var isSelected = true
    @IBOutlet weak var homepopupimg: UIImageView!
    
    //AVplayer
    
    var avPlayer  = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addShadow(view: self.navbar, opacity: 0.3, radius: 2.5)
        
        DispatchQueue.main.async {
            self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        }
       // animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        
        self.tableview.rowHeight = UITableViewAutomaticDimension
        self.tableview.estimatedRowHeight = 200
        
        self.opcatityview.isHidden = true
        
        self.repostimview.isHidden = true
        self.opcatityview.layer.opacity = 0.7
        self.repostview.isHidden = true
        self.delteview.isHidden = true
        
        self.tableview.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.updateByContentOffset()
            self.startLoading()
        }
        fetchdetals( postid: postid)
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        self.view.addSubview(circularview!)
    }
    
    
    
    func addShadow(view:UIView,opacity:Float,radius:CGFloat){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = radius
    }
    
    //MARK:mmplayer
    fileprivate func updateByContentOffset() {
        let p = CGPoint(x: tableview.frame.width/2, y: tableview.contentOffset.y + tableview.frame.width/2)
        if let path = tableview.indexPathForRow(at: p), self.presentedViewController == nil {
            self.updateCell(at:path)
        }
        
        
    }
    
    fileprivate func updateDetail(at indexPath: IndexPath) {
        self.mmPlayerLayer.thumbImageView.sd_setImage(with: URL.init(string: feeditem!.getimgurl()), placeholderImage: placeholder)
        self.mmPlayerLayer.set(url: URL(string:self.feeditem!.getVideoLink())!, state: { (status) in
            
        })
        self.mmPlayerLayer.startLoading()
    }
    
    fileprivate func updateCell(at indexPath: IndexPath) {
        if let cell = tableview.cellForRow(at: indexPath) as? VideoCellTableViewCell {
            // this thumb use when transition start and your video dosent start
            mmPlayerLayer.thumbImageView.image = cell.imgPost.image
            // set video where to play
            if !MMLandscapeWindow.shared.isKeyWindow {
                mmPlayerLayer.playView = cell.imgPost
            }
            
            // set url prepare to load
            mmPlayerLayer.set(url: URL(string:(self.feeditem!.getVideoLink())), state: { (status) in
                switch status {
                case .failed(let _): break
                    //                    let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
                    //                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //                    self.present(alert, animated: true, completion: nil)
                case .ready:
                    print("Ready to Play")
                case .playing:
                    print("Playing")
                case .pause:
                    print("Pause")
                case .end:
                    print("End")
                default: break
                }
            })
        }
    }
    @objc fileprivate func startLoading() {
        if self.presentedViewController != nil {
            return
        }
        // start loading video
        mmPlayerLayer.startLoading()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            self.updateByContentOffset()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(startLoading), with: nil, afterDelay: 0.3)
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    var totatllike = String()
    var index = IndexPath()
    
    @IBAction func likeAction(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableview)
        guard let indexpath = self.tableview.indexPathForRow(at: point) else{
            print("error")
            return
        }
        self.index = indexpath
        let post_id = self.feeditem!.getrepost_id1()
        let guestId = self.feeditem!.getuser_id()
        print(post_id)
        print(guestId)
        
        if sender.imageView?.image == #imageLiteral(resourceName: "imgLike") {
            sender.setImage(#imageLiteral(resourceName: "imgLikeFilled"), for: .normal)
            
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 5.0,
                           options: .curveEaseOut,
                           animations: {
                            
                            sender.transform = .identity
            },
                           completion: {
                            action in
                            print ("complete")
                            
            })
            
            LikeApicall(postid: post_id, postuserID: guestId)
            
        }else{
            sender.setImage(#imageLiteral(resourceName: "imgLike"), for: .normal)
            LikeApicall(postid: post_id, postuserID: guestId)
        }
        
        
    }
    
    
    
    // MARK: -  commentbtn
    @IBAction func commentAction(_ sender: UIButton) {

        let post_id = self.feeditem!.getrepost_id1()
        let guestId = self.feeditem!.getuser_id()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
        vc.repostid = post_id
        vc.guest_id = guestId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func repostAction(_ sender: UIButton) {
        let repost_id = self.feeditem!.getrepost_id1()
        let post_id = self.feeditem!.getrepost_id1()
        let post_type = self.feeditem!.getfile_type1()
        let guestId = self.feeditem!.getuser_id()
        let second_userid = self.feeditem!.getuser_id()
        var dict = [String:Any]()
        if post_type == "repost post" {
            dict["post_id"] = post_id
            dict["postUserId"] = second_userid
        }else {
            dict["post_id"] = repost_id
            dict["postUserId"] = guestId
        }
        
        dict["postimage"] = self.feeditem!.getimgurl()
        dict["filetype"] = self.feeditem!.getfile_type1()
        dict["video"] = self.feeditem!.getVideoLink()
        dict["imgWidth"] = self.feeditem!.getimage_width()
        dict["imgHeight"] = self.feeditem!.getimage_height()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepostViewController") as! RepostViewController
        vc.data = dict
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBOutlet weak var repostview: UIView!
    @IBOutlet weak var repostimg: UIImageView!
    @IBAction func cancel(_ sender: UIButton) {
        self.opcatityview.isHidden = true
        self.repostview.isHidden = true
        self.repostimview.isHidden = true
    }
    
    @IBAction func repost(_ sender: UIButton) {
        
        let repost_id = self.feeditem!.getrepost_id1()
        let post_id = self.feeditem!.getrepost_id1()
        let post_type = self.feeditem!.getfile_type1()
        let guestId = self.feeditem!.getuser_id()
        let second_userid = self.feeditem!.getuser_id()
        
        var dict = [String:Any]()
        if post_type == "repost post" {
            dict["post_id"] = post_id
            dict["postUserId"] = second_userid
            
        }else {
            dict["post_id"] = repost_id
            dict["postUserId"] = guestId
            
        }
        
        dict["postimage"] = self.feeditem!.getimgurl()
        dict["filetype"] = self.feeditem!.getfile_type1()
        dict["video"] = self.feeditem!.getVideoLink()
        dict["imgWidth"] = self.feeditem!.getimage_width()
        dict["imgHeight"] = self.feeditem!.getimage_height()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepostViewController") as! RepostViewController
        vc.data = dict
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    @IBOutlet weak var repostimview: UIImageView!
    @IBOutlet weak var opcatityview: UIView!
    
    func fetchdetals( postid : String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
        // [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
       // [MBProgressHUD .showAdded(to: self.view, animated: true)]

        

        let parameter: Parameters = ["action":"open_picture","userid": "\(standard.value(forKey: "user_id")!)","postid": postid]
        //\(standard.value(forKey: "user_id"))
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                print("failure")
                //animationView.pause()
                //animationView.removeFromSuperview()
                //[MBProgressHUD .hide(for: self.view, animated: true)]

                //"reason" : "You have no following yet"
                
                return
            }
            DispatchQueue.main.async {
                
                
                let feedvid = json["result"]["timeline_posts"][0]["video"].stringValue
                let feedimg  = json["result"]["timeline_posts"][0]["photo"].stringValue
                let feedDName = json["result"]["timeline_posts"][0]["display_name"].stringValue
                let feedTime = json["result"]["timeline_posts"][0]["time_ago"].stringValue
                let feedprofileimg = json["result"]["timeline_posts"][0]["profile_image"].stringValue
                let feedcaption = json["result"]["timeline_posts"][0]["caption"].stringValue
                let feedrepostid = json["result"]["timeline_posts"][0]["post_id"].stringValue
                let feedpost_like = json["result"]["timeline_posts"][0]["post_like"].stringValue
                let feedtotal_points = json["result"]["timeline_posts"][0]["total_points"].stringValue
                let feeduser_id = json["result"]["timeline_posts"][0]["user_id"].stringValue
                let feedfile_type = json["result"]["timeline_posts"][0]["file_type"].stringValue
                let feedimage_width = json["result"]["timeline_posts"][0]["image_width"].intValue
                let feedimage_height = json["result"]["timeline_posts"][0]["image_height"].intValue
                let feedtagpeople = json["result"]["timeline_posts"][0]["tag_people"].arrayObject as? [[String:Any]]
                let x_cord =  json["result"]["timeline_posts"][0]["x_cord"].stringValue
                let y_cord =  json["result"]["timeline_posts"][0]["y_cord"].stringValue
                let multipleImages =  json["result"]["timeline_posts"][0]["multiple_images"].stringValue
                
                self.feeditem = FeedPostModel.init(video: feedvid, imgurls: feedimg, DNames: feedDName, time: feedTime, caption: feedcaption, repost_id1: feedrepostid, post_like: feedpost_like, total_points1: feedtotal_points, user_id: feeduser_id, file_type1: feedfile_type, profileImage: feedprofileimg, image_width: feedimage_width, image_height: feedimage_height, tagpeople: feedtagpeople, x_cord: x_cord, y_cord: y_cord, multipleImages: multipleImages)
                
                DispatchQueue.main.async {
                   // animationView.pause()
                    //animationView.removeFromSuperview()
                    //[MBProgressHUD .hide(for: self.view, animated: true)]
                    self.tableview.reloadData()
                    
                }
                
                
            }
            print("success")
            
        }
        
    }
    
    
    // MARK:- tag people data
    var mainArr = NSMutableArray()
    //var tagpersons = NSMutableArray()
    var displayname = [String]()
    var _Xpos = [CGFloat]()
    var _Ypos = [CGFloat]()
    
    func tapPerson(sender:UITapGestureRecognizer) {
        
        print("tap working",sender.view!.tag)
        
        let point = sender.location(in: self.tableview)
        guard let indexpath = self.tableview.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let cell = self.tableview.cellForRow(at: indexpath) as! HomeTableViewCell
        
        
        
        let a = self.feeditem?.gettagpeople() as! NSArray
        print(a)
        //if let n = NumberFormatter().number(from: string) {
        // let fl = CGFloat(n)
        
        for index1 in 0..<a.count{
            
            if index1 == 0{
                self.displayname.removeAll()
                self._Xpos.removeAll()
                self._Ypos.removeAll()
                self.mainArr.removeAllObjects()
            }
            let dict = a[index1] as! NSDictionary
            self.mainArr.add(dict)
            print(self.mainArr)
            let display_name = (self.mainArr[index1] as! NSDictionary).value(forKey: "display_name")
            let positionX = (self.mainArr[index1] as! NSDictionary).value(forKey: "x_cordinates")
            let positionY = (self.mainArr[index1] as! NSDictionary).value(forKey: "y_cordinates")
            if display_name as? String != nil {
                if let n = NumberFormatter().number(from: positionX as! String) {
                    let fl = CGFloat(n)
                    _Xpos.append(fl)
                }
                if let n = NumberFormatter().number(from: positionY as! String) {
                    let fl = CGFloat(n)
                    _Ypos.append(fl)
                }
                displayname.append(display_name as! String)
            }
            
        }
        
        print(displayname)
        if isSelected == false {
            isSelected = true
            for index in 0..<displayname.count {
                let lbl = cell.viewWithTag(index + 1) as? UILabel
                if lbl != nil {
                    lbl?.removeFromSuperview()
                }
            }
        }
        else{
            isSelected = false
            for index in 0..<displayname.count {
                
                let label = UILabel(frame: CGRect(x: ((_Xpos[index] )*cell.imgPost.frame.size.width)/100 , y: ((_Ypos[index] )*cell.imgPost.frame.size.width)/100, width: 60 , height: 30))
                label.backgroundColor = UIColor.black
                label.alpha = 0.6
                label.font = UIFont(name: "Avenir-Light", size: 11.0)
                label.tag = index + 1
                label.font = UIFont.systemFont(ofSize: 13)
                label.textColor = UIColor.white
                label.textAlignment = NSTextAlignment.center
                label.layer.cornerRadius = 5
                label.layer.masksToBounds = true
                label.text = displayname[index]
                cell.imgPost.addSubview(label)
            }
            
        }
        
    }
    
    
    
    
    
    
    func LikeApicall(postid: String ,postuserID : String){
        self.view.addSubview(animationView)
        //animationView.play()
        //animationView.loopAnimation = true
       // [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"like_post", "liked_userid":"\(standard.value(forKey: "user_id")!)", "postid":"\(postid)" , "post_userid" : "\(postuserID)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "post_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: "Error")
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
               // [MBProgressHUD .hide(for: self.view, animated: true)]
                return
            }
            
            //let user_id = ((json["result"]["details"]["user_id"].stringValue))
            
            
            
            //let photo = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["photo"].stringValue})))
            
            //animationView.pause()
            //animationView.removeFromSuperview()
           // [MBProgressHUD .hide(for: self.view, animated: true)]
            print("success")
            
            DispatchQueue.main.async {
                self.totatllike =  (json["result"]["total_post_points"] .stringValue)
                // self.fetchdetals( postid: self.postid)
                
                let cell = self.tableview.cellForRow(at: self.index) as! HomeTableViewCell
                if self.totatllike != ""  {
                    cell.lbl_points.text = self.totatllike
                }
            }
            
        }
        
    }
    
    
    
    
    
    func repostApi(postid: String ,postuserID : String  ){
        self.view.addSubview(animationView)
        //animationView.play()
        //animationView.loopAnimation = true
        
       // [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"repost_post", "repost_userid":"\(standard.value(forKey: "user_id")!)", "postid":"\(postid)" , "post_userid" : "\(postuserID)","repost_text" : "welcome"]
        //let parameter: Parameters = ["action":"repost_post", "repost_userid":"\(standard.value(forKey: "user_id")!)", "postid":"\(postid)" , "post_userid" : "\(postuserID)","repost_text" : "welcome"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: "Error")
                print("failure")
               // animationView.pause()
                //animationView.removeFromSuperview()
                //[MBProgressHUD .hide(for: self.view, animated: true)]

                
                
                return
            }
            
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            
           // [MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            self.showalertViewcontroller(message: "Reposted on your Timeline", handler:
                {
                    DispatchQueue.main.async {
                        self.opcatityview.isHidden = true
                        self.repostview.isHidden = true
                        self.repostimview.isHidden = true
                    }
                    
            })
            
        }
        
    }
    
    
    
    
    func delete(postid: String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        //[MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"delete_post", "userid":"\(standard.value(forKey: "user_id")!)", "postid":postid ,]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: "Error")
                print("failure")
               // animationView.pause()
               // animationView.removeFromSuperview()
                //[MBProgressHUD .hide(for: self.view, animated: true)]

                return
            }
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            
           // [MBProgressHUD .hide(for: self.view, animated: true)]

          print("success")
            DispatchQueue.main.async {
                self.delteview.isHidden = true
                self.delegate?.postDeleted(from: self.indexofPost)
                photoposted = false
                _=self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
        @IBAction func back(_ sender: UIBarButtonItem)
    
    {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.backCalling ()
    }
    
    
    
    func delete(sender:UIButton){
        self.delteview.isHidden = false
    }
    
    
    
    @IBOutlet weak var delteview: UIView!
    
    @IBAction func deletecancel(_ sender: Any) {
        self.delteview.isHidden = true
    }
    
    
    
    @IBAction func deletephoto(_ sender: UIButton) {
        self.delete(postid: postid)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.tableview.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}

extension openphotoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feeditem == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell
        cell.selectionStyle = .none
        cell.auserbtn.addTarget(self, action: #selector(self.userProfile(sender:)), for: .touchUpInside)
        cell.videoview.isHidden = true
        let width = self.feeditem?.getimage_width()
        let height = self.feeditem?.getimage_height()
        let screenWidth = UIScreen.main.bounds.width
        if self.feeditem?.getfile_type1() == "image"{
            
            if (width != nil) && height != nil && (width! != 0) && (height != 0) {
                let ratio : CGFloat  = (CGFloat(width!) / CGFloat(height!))
                
                let imageheight = ((screenWidth) / (ratio))
                cell.imgPostHeightConstraint.constant = imageheight
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(openphotoViewController.tapPerson1(sender:)))
            cell.imgPost.tag = indexPath.row
            cell.imgPost.isUserInteractionEnabled = true
            cell.imgPost.addGestureRecognizer(tap)
        }else{
            if (width != nil) && height != nil && (width! != 0) && (height != 0) {
                let ratio : CGFloat  = (CGFloat(width!) / CGFloat(height!))

                let imageheight = ((screenWidth) / (ratio))
                if imageheight > UIScreen.main.bounds.height - 70{
                    cell.imgPostHeightConstraint.constant = UIScreen.main.bounds.height - 70
                }else{
                    cell.imgPostHeightConstraint.constant = imageheight
                }
            }
            let videolink = self.feeditem!.getVideoLink()
            
            let videoURL = URL(string: videolink)
            mmPlayerLayer.playView = cell.imgPost
            mmPlayerLayer.set(url: videoURL, state: { (status) in
            })
            mmPlayerLayer.startLoading()
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(openphotoViewController.tapFunction))
        cell.imgPost.sd_setImage(with: URL(string: self.feeditem!.getimgurl()), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
        cell.lbl_points.tag = indexPath.row
        cell.lbl_points.isUserInteractionEnabled = true
        cell.star.tag = indexPath.row
        cell.star.isUserInteractionEnabled = true
        cell.star.addGestureRecognizer(tap1)
        cell.lbl_points.addGestureRecognizer(tap1)
        
        cell.imgProfilePic.sd_setImage(with: URL(string: self.feeditem!.getProfileImage()), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
        cell.lbl_username.text = self.feeditem!.getDnames()
        cell.lbl_postText.text = self.feeditem!.getCaption()
        cell.lbl_points.text = self.feeditem!.gettotal_points1()
        cell.lbl_name.text = self.feeditem!.getDnames()
        cell.openphototime.text = self.feeditem!.getTime()

        cell.likeButton.setImage(self.feeditem!.getpost_like() == "1" ? #imageLiteral(resourceName: "imgLikeFilled") : #imageLiteral(resourceName: "imgLike"), for: .normal)

        cell.deletebtn.isHidden = deletephoto ? true : false
       
        cell.deletebtn.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        
        print("tap working",sender.view!.tag)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PointOnPostViewController") as! PointOnPostViewController
        
        vc.guestID = self.feeditem!.getuser_id()
        vc.postID = self.feeditem!.getrepost_id1()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userProfile(sender:UIButton){
        
        let guest_id = self.feeditem!.getuser_id()
        print(guest_id)
        if guest_id == standard.value(forKey: "user_id") as! String{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Anotheruserprofile(userid2: guest_id)
        }
        
    }
    
    
    func tapPerson1(sender:UITapGestureRecognizer) {
        
        
        print("tap working",sender.view!.tag)
        let point = sender.location(in: tableview)
        guard let indexpath = tableview.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let  cell = tableview.cellForRow(at: indexpath) as! HomeTableViewCell
        guard self.feeditem?.getmultipleImages().isEmpty == true else {
            
            let pointInImage = sender.location(in: cell.imgPost)
            print("point in poinst \(pointInImage)")
            let touchableView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 75, height: 75))
            touchableView.backgroundColor = UIColor.clear
            cell.imgPost.addSubview(touchableView)
            let multipleImageIds = self.feeditem?.getmultipleImages().components(separatedBy: "/,")
            let multipleXCords = self.feeditem?.getx_cord().components(separatedBy: ",")
            let multipleYCords = self.feeditem?.gety_cord().components(separatedBy: ",")
            for index in 0..<multipleImageIds!.count {
                let xPoint = (CGFloat(Float(multipleXCords![index] ) ?? 0.0)*cell.imgPost.frame.size.width)/100
                print("xPoint after translation \(xPoint)")
                let yPoint = (CGFloat(Float(multipleYCords![index] ) ?? 0.0)*cell.imgPost.frame.size.height)/100
                print("yPoint after translation \(yPoint)")
                let centrePoint = CGPoint.init(x: xPoint, y: yPoint)
                print("centre point \(centrePoint)")
                touchableView.frame.origin = centrePoint
                if touchableView.frame.contains(pointInImage) {
                    print("contains")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewPhotoTourController") as! ViewPhotoTourController
                        vc.imageIds = multipleImageIds![index]
                        let dict = [
                            "profileImage": self.feeditem?.getProfileImage(),
                            "username": self.feeditem?.getDnames(),
                            "time": self.feeditem?.getTime(),
                            "points": self.feeditem?.gettotal_points1()
                        ]
                        vc.postDetails = dict
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            return
        }
        
        _=cell.imgPost.subviews.map({ $0.isHidden = !$0.isHidden})

    }
    
    
    
    
    //api
    func Anotheruserprofile(userid2: String){
        // self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
       // [MBProgressHUD .showAdded(to: self.view, animated: true)]
       let parameter: Parameters = ["action":"fetch_user_profile", "userid":"\(standard.value(forKey: "user_id")!)", "userid2":"\(userid2)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: "Error")
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
               // [MBProgressHUD .hide(for: self.view, animated: true)]
               return
            }
            
            let user_id = ((json["result"]["details"]["user_id"].stringValue))
            let scorepoint = ((json["result"]["details"]["scorepoint"].stringValue))
            let link = ((json["result"]["details"]["link"].stringValue))
            let privacy_status = ((json["result"]["details"]["privacy_status"].stringValue))
            let profile_image1 = ((json["result"]["details"]["profile_image"].stringValue))
            let bio_data = ((json["result"]["details"]["bio_data"].stringValue))
            let cover_image1 = ((json["result"]["details"]["cover_image"].stringValue))
            let follower_status = ((json["result"]["details"]["follower_status"].stringValue))
            let full_name = ((json["result"]["details"]["full_name"].stringValue))
            let display_name = ((json["result"]["details"]["display_name"].stringValue))
            
            let post_id = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["post_id"].stringValue})))
            let photo = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["photo"].stringValue})))
            let video = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["video"].stringValue})))
            let type = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["type"].stringValue})))
            
            
            print("success")
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
            vc.cover_image = cover_image1
            vc.profile_image = profile_image1
            vc.fullname = full_name
            vc.displayname1 = display_name
            vc.scorepoint = scorepoint
            vc.link  = link
            vc.bio_data = bio_data
            vc.privacy_status = privacy_status
            vc.guest_id = user_id
            vc.followStatus = follower_status
            vc.postId = post_id as NSArray
            vc.postimageArr = photo as NSArray
            vc.type1 = type as NSArray
            self.navigationController?.pushViewController(vc, animated: true)
//            animationView.pause()
//            animationView.removeFromSuperview()
            //[MBProgressHUD .hide(for: self.view, animated: true)]

        }
        
    }
    
   
    
}
