 //
 //  PointOnPostViewController.swift
 //  Viegram
 //
 //  Created by Avatar Singh on 2017-07-19.
 //  Copyright © 2017 Relinns. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import SDWebImage
 import SwiftyJSON
 import DZNEmptyDataSet
 
 class PointOnPostViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var lbl_like: UILabel!
    @IBOutlet weak var lbl_Comment: UILabel!
    @IBOutlet weak var lbl_repost: UILabel!
    @IBOutlet weak var lbl_myComment: UILabel!
    @IBOutlet weak var tableComment2: UITableView!
    @IBOutlet weak var tblRepost: UITableView!
    @IBOutlet weak var tblLike: UITableView!
    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var nav: UINavigationBar!

    
    
    var likesData = [PointOnPostModel]()
    var commentData = [PointOnPostModel]()
    var repostData = [PointOnPostModel]()
    var myCommentData = [PointOnPostModel]()
    var guestID = String()
    var postID  = String()
    
    
    @IBOutlet weak var leadingCon: NSLayoutConstraint!
    @IBOutlet weak var btnView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(postID)
        tableComment2.tableFooterView = UIView()
        tblRepost.tableFooterView = UIView()
        tblLike.tableFooterView = UIView()
        tblComment.tableFooterView = UIView()
        
        self.nav.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
        self.nav.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        self.apiCall()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        addshodow(view: self.nav)
        self.nav.layer.masksToBounds = false
        self.nav.layer.shadowColor = UIColor.lightGray.cgColor
        self.nav.layer.shadowOpacity = 0.3
        self.nav.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.nav.layer.shadowRadius = 2.5
        addshodow(view: btnView)
    }
    
    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblLike {
            return  self.likesData.count
        } else if tableView == tblComment{
            return  self.commentData.count
        } else  if tableView == self.tblRepost{
            return self.repostData.count
        }
        return self.myCommentData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func openprofileLike(_ sender: UIButton) {
        
        var userId = String()
        switch sender.tag{
        case 1 :
            
            let indexpath = self.createIndexpath(sender: sender, coordinateSpace: self.tblLike)
            userId = self.likesData[indexpath.row].getUserId()
            break
        case 2:
            let indexpath = self.createIndexpath(sender: sender, coordinateSpace: self.tblComment)
            userId = self.commentData[indexpath.row].getUserId()
            break
        case 3 :
            let indexpath = self.createIndexpath(sender: sender, coordinateSpace: self.tblRepost)
            userId = self.repostData[indexpath.row].getUserId()
            break
        case 4:
            let indexpath = self.createIndexpath(sender: sender, coordinateSpace: self.tableComment2)
            userId = self.myCommentData[indexpath.row].getUserId()
            break
        default:
            break
        }
        
        if userId == standard.value(forKey: "user_id") as! String{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Anotheruserprofile(userid2: userId)
        }
        

    }
    
    func createIndexpath (sender:UIView,coordinateSpace:UITableView) -> IndexPath{
        let point = sender.convert(CGPoint.zero, to: coordinateSpace)
        guard let indexpath = coordinateSpace.indexPathForRow(at: point) else {
            print("error while creating indexpath")
            return IndexPath()
        }
        
        return indexpath
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        
        let img = cell2.viewWithTag(1) as! UIImageView
        let lbl = cell2.viewWithTag(2) as! UILabel
        
        if tableView == self.tblLike {
            img.sd_setImage(with: URL.init(string: self.likesData[indexPath.row].getUserImage()), placeholderImage: placeholder1)
            lbl.text = self.likesData[indexPath.row].getUsername()
        }else if tableView == tblComment{
            img.sd_setImage(with: URL.init(string: self.commentData[indexPath.row].getUserImage()), placeholderImage: placeholder1)
            lbl.text = self.commentData[indexPath.row].getUsername()
            
        }else  if tableView == self.tblRepost {
            img.sd_setImage(with: URL.init(string: self.repostData[indexPath.row].getUserImage()), placeholderImage: placeholder1)
            lbl.text = self.repostData[indexPath.row].getUsername()
            
        }else if  tableView == self.tableComment2 {
            img.sd_setImage(with: URL.init(string: self.myCommentData[indexPath.row].getUserImage()), placeholderImage: placeholder1)
            lbl.text = self.myCommentData[indexPath.row].getUsername()
            
        }
        
        
        
        return cell2
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        leadingCon.constant = scrollView.contentOffset.x/4
    }
    
    func setViewHeights(){
        
        DispatchQueue.main.async {
            self.tableComment2.reloadData()
            self.tblRepost.reloadData()
            self.tblLike.reloadData()
            self.tblComment.reloadData()
        }
    }
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBAction func btnAction(_ sender: UIButton) {
        
        let i = CGFloat(sender.tag - 1)
        self.ScrollView.scrollRectToVisible(CGRect(x: self.ScrollView.frame.width * i, y: 0, width: self.ScrollView.frame.width, height: self.ScrollView.frame.height), animated: true)
    }
    
    
    func Anotheruserprofile(userid2: String){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
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
                animationView.pause()
                animationView.removeFromSuperview()
                
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
            animationView.pause()
            animationView.removeFromSuperview()
        }
    }
    
    func apiCall(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"post_details","postid": self.postID ,"userid":self.guestID]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                self.setViewHeights()
                return
            }
            print(response.result.value!)
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                // self.showalertview(messagestring: "")
                //                animationView.pause()
                self.setViewHeights()
                animationView.removeFromSuperview()
                
                return
            }
            
            animationView.pause()
            animationView.removeFromSuperview()
            print("success")
            
            
            for profile in json["result"]["like_posts"].arrayValue {
                let id = profile["id"].stringValue
                let img = profile["profile_image"].stringValue
                let name = profile["display_name"].stringValue
                
                self.likesData.append(PointOnPostModel.init(with: id, userImg: img, userName: name))
            }
            
            for profile in json["result"]["comment_post"].arrayValue {
                let id = profile["id"].stringValue
                let img = profile["profile_image"].stringValue
                let name = profile["display_name"].stringValue
                
                self.commentData.append(PointOnPostModel.init(with: id, userImg: img, userName: name))
            }
            for profile in json["result"]["repost_post"].arrayValue {
                let id = profile["id"].stringValue
                let img = profile["profile_image"].stringValue
                let name = profile["display_name"].stringValue
                
                self.repostData.append(PointOnPostModel.init(with: id, userImg: img, userName: name))
            }
            
            for profile in json["result"]["my_comments"].arrayValue {
                let id = profile["id"].stringValue
                let img = profile["profile_image"].stringValue
                let name = profile["display_name"].stringValue
                
                self.myCommentData.append(PointOnPostModel.init(with: id, userImg: img, userName: name))
            }
            
            
            
            
            
            DispatchQueue.main.async {
                self.lbl_like.text = json["result"]["like_counter"].stringValue
                self.lbl_Comment.text = json["result"]["comment_counter"].stringValue
                self.lbl_repost.text = json["result"]["repost_counter"].stringValue
                self.lbl_myComment.text = json["result"]["mycomment_counter"].stringValue
                
                self.setViewHeights()
            }
        }
    }
    
 }
 
 extension PointOnPostViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        if scrollView == self.tblLike{
          return UIImage.init(named: "_1comment-1")
        }else if scrollView == self.tblComment{
            return UIImage.init(named: "_1emptycomment")
        }else if scrollView == self.tblRepost{
            return UIImage.init(named: "_1repost")
        }else if scrollView == self.tableComment2{
            return UIImage.init(named: "_1emptycomment")
        }
        return UIImage.init(named: "emptysearch")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var str = String()
        
        if scrollView == self.tblLike{
            str = "No Likes"
        }else if scrollView == self.tblComment{
           str = "No Comments"
        }else if scrollView == self.tblRepost{
            str = "No Reposts"
        }else if scrollView == self.tableComment2{
           str = "No Comments Liked"
        }
        
        let attributes = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 16.0),NSForegroundColorAttributeName:apppurple]
        return NSAttributedString.init(string: str, attributes: attributes ?? [:])
    }
    
    
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        
        animation.toValue = NSValue(caTransform3D:CATransform3DMakeRotation(CGFloat.pi, 0.0, 0.0, 1.0))
        animation.duration = 0.5
        animation.isCumulative = true
        animation.repeatCount = 100
        return animation
    }
 }
