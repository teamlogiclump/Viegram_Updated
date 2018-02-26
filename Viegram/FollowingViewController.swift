//
//  FollowingViewController.swift
//  Viegram
//
//  Created by Relinns on 30/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import MBProgressHUD

class FollowingViewController: UIViewController,UITableViewDataSource , UITableViewDelegate  {
    
    @IBAction func backbtn(_ sender: UIButton) {
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var emptyfollowerview: UIView!
    @IBOutlet weak var followerlbl: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var Imgcover: UIImageView!
    
    @IBOutlet weak var followersbtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var tableview1: UITableView!
    @IBOutlet weak var tableview2: UITableView!
    var _name = String()
    var _profileimg = String()
    var _coverimg = String()
    var userid = String()
    var privateuser1 = String()
    var followerstatus = String()
    
    
    var follower = "0"
    
    var emptyscreenFollwing = Bool()
    var emptyscreenFollower = Bool()
    
    
    @IBAction func folloersBtn(_ sender: UIButton) {
        self.scrollview.delegate = self
        self.scrollview.scrollRectToVisible(CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.tableview1.frame.size.height), animated: true)
        
    }
    
    @IBAction func followingBtn(_ sender: UIButton) {
        
        self.scrollview.setContentOffset(CGPoint(x:self.view.frame.width,y:0), animated: true)
        
//        self.scrollview.scrollRectToVisible(CGRect(x:self.view.frame.width,y:0,width:self.view.frame.size.width,height:self.tableview1.frame.size.height), animated: true)
       
    }
    
    
    @IBOutlet weak var privateview: UIView!
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.scrollview.delegate = self
        if followerstatus == "0"{
            if privateuser1 == "0" {
                self.privateview.isHidden = true
//                FollowinglistApi(guest_id: userid)
                FollowerlistApi(guest_id: userid)
            }else{
                self.privateview.isHidden = false
            }
            
            
        }else {
            self.privateview.isHidden = true
//            FollowinglistApi(guest_id: userid)
            FollowerlistApi(guest_id: userid)
        }
        
        if emptyscreenFollower == false {
            self.emptyfollowerview.isHidden = false
        }else{
            self.emptyfollowerview.isHidden = true
        }
        self.searchtable.isHidden = true
        if _profileimg != ""{
            //self.profileImg.sd_setImage(with: URL(string: _profileimg))
             self.profileImg.sd_setImage(with: URL(string: _profileimg), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
        }
        if _coverimg != "" {
            //self.Imgcover.sd_setImage(with: URL(string: _coverimg))
            self.Imgcover.sd_setImage(with: URL(string: _coverimg), placeholderImage: UIImage.init(named: "imgProfileback"), options: SDWebImageOptions.refreshCached)
        }
        
        self.profileTitle.text = _name
        // Do any additional setup after loading the view.
        self.followersbtn.setTitleColor(UIColor.white, for: .normal)
        
        self.followersbtn.backgroundColor = apppurple
        self.followingBtn.setTitleColor(apppurple, for: .normal)
        self.followingBtn.backgroundColor = UIColor.white
        
        self.setPaddingView(strImgname: "Search", txtField: self.searchTF)
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview)
        
        addshodow(view: self.followingBtn)
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        
        
        self.opacityview.isHidden = true
        self.unfollowview.isHidden = true
        self.imgunfollow.isHidden = true
        
        
    }
    
    func setGradientBackground(view:UIView) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
        //gradientLayer.locations = [ 0.0,0.25,0.50, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setPaddingView(strImgname: String,txtField: UITextField){
        let imageView = UIImageView(image: UIImage(named: strImgname))
        imageView.frame = CGRect(x: -5, y: 0, width: 20 , height: 20)
        let paddingView: UIView = UIView.init(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        paddingView.addSubview(imageView)
        txtField.rightViewMode = .always
        txtField.rightView = paddingView
        
    }
    
    var beizer = UIBezierPath()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBOutlet weak var searchtable: UITableView!
    
    override func viewDidLayoutSubviews() {
        beizer.move(to: CGPoint(x:0,y: 0))
        beizer.addLine(to: CGPoint(x:0,y: self.Imgcover.frame.maxY))
        beizer.addLine(to: CGPoint(x:self.Imgcover.frame.maxX,y: self.Imgcover.frame.size.height*0.8))
        beizer.addLine(to: CGPoint(x:self.Imgcover.frame.maxX,y: 0))
        beizer.addLine(to: CGPoint(x:0,y: 0))
        beizer.close()
        let maskForYourPath = CAShapeLayer()
        maskForYourPath.path = beizer.cgPath
        self.Imgcover.layer.mask = maskForYourPath
        self.Imgcover.layer.rasterizationScale = UIScreen.main.scale;
        self.Imgcover.layer.shouldRasterize = true;
    }
    
    //MARK:- UNfollow popup
    @IBOutlet weak var unfollowview: UIView!
    @IBOutlet weak var imgunfollow: UIImageView!
    @IBOutlet weak var opacityview: UIView!
    
    @IBOutlet weak var poplblunfollow: UILabel!
    
    var  circularview = CircularMenu()
    @IBAction func cancelunfollow(_ sender: UIButton) {
        
        
        self.opacityview.isHidden = true
        self.unfollowview.isHidden = true
        self.imgunfollow.isHidden = true
          circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview)
    }

    @IBAction func unfollow(_ sender: UIButton) {
      
        
        
       
        
        if  bool == true {
            Followstart(guest_id: useridfolloingT1)
        }else {
            self.opacityview.isHidden = true
            self.unfollowview.isHidden = true
            self.imgunfollow.isHidden = true
            
            unfollow(unfollow_id: useridfolloingT1)
            
        }
        
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableview1{
            return follower_list.count
            
        } else if tableView == self.tableview2 {
            return follower_list2.count
        } else {
            return profile_name.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.tableview1{
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1" ) as! followingTableViewCell
            addshodow(view: cell1.followT1)
            if follow_status[indexPath.row] as! String == "0"{
                cell1.followT1.setTitle("Follow", for: .normal)
                cell1.followT1.setTitleColor(apppurple, for: .normal)
                cell1.followT1.backgroundColor = UIColor.white
            }else if follow_status[indexPath.row] as! String == "1" {
                cell1.followT1.setTitle("Unfollow", for: .normal)
                cell1.followT1.setTitleColor(UIColor.white, for: .normal)
                cell1.followT1.backgroundColor = apppurple
            }else{
                cell1.followT1.setTitle("Requested", for: .normal)
                cell1.followT1.setTitleColor( UIColor.white, for: .normal)
                cell1.followT1.backgroundColor = apppurple
                
            }
            cell1.followT1.addTarget(self, action: #selector(followT1(sender:)), for: .touchUpInside)
            cell1.folloerImg.sd_setImage(with: URL(string: (profile_image[indexPath.row] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            cell1.folloersName.text = display_name[indexPath.row] as? String
            cell1.profileview.addTarget(self, action: #selector(profileview1(sender:)), for: .touchUpInside)
            return cell1
            
        }
        if tableView == self.tableview2{
            
            let  cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3" ) as! followingTableViewCell
            addshodow(view: cell3.followT2)
            cell3.followT2.isHidden = false
            if follow_status2[indexPath.row] as! String == "0"{
                cell3.followT2.setTitle("Follow", for: .normal)
                cell3.followT2.setTitleColor(apppurple, for: .normal)
                cell3.followT2.backgroundColor = UIColor.white
                
                
                if user_id2[indexPath.row] as! String == standard.value(forKey: "user_id") as! String{
                    cell3.followT2.isHidden = true
                }
                
                
            }else if follow_status2[indexPath.row] as! String == "1"{
                cell3.followT2.setTitle("Unfollow", for: .normal)
                cell3.followT2.setTitleColor(UIColor.white, for: .normal)
                cell3.followT2.backgroundColor = apppurple
            }   else    {
                cell3.followT2.setTitle("Requested", for: .normal)
                cell3.followT2.setTitleColor( UIColor.white, for: .normal)
                cell3.followT2.backgroundColor = apppurple
                
            }
            cell3.followT2.addTarget(self, action: #selector(followT2(sender:)), for: .touchUpInside)
            cell3._img2.sd_setImage(with: URL(string: (profile_image2[indexPath.row] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            cell3._name2.text = display_name2[indexPath.row] as! String
            cell3._profile.addTarget(self, action: #selector(profileview2(sender:)), for: .touchUpInside)
            return cell3
        }
        if tableView == self.searchtable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchTableViewCell
            cell.namelbl.text = profile_name[indexPath.row] as? String
            cell.img.sd_setImage(with: URL(string: (profile_image1[indexPath.item] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            
            return cell
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchtable {
            
            let point = searchtable.convert(CGPoint.zero, to: self.searchtable)
            guard let indexpath = self.searchtable.indexPathForRow(at: point) else{
                print("error")
                return
            }
            
            let another_userid1 = (self.serachuserid1[indexpath.row] as! String)
            
            
            if another_userid1 != "" {
                
                if another_userid1 == standard.value(forKey: "user_id") as? String{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    Anotheruserprofile(userid2: another_userid1)
                }
                
            }
            
            
            
            
        }
    }
    
    //Unfollowbtn
    var useridfolloingT1 = String()
    var bool = Bool()
    func followT1(sender:UIButton){
        
        
        let point = sender.convert(CGPoint.zero, to: self.tableview1)
        guard let indexpath = self.tableview1.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id[indexpath.row] as! String)
        let name = (self.display_name[indexpath.row] as! String)
        
        self.poplblunfollow.text = "Are you sure you want to unfollow @\(name) ?"
        self.useridfolloingT1 = another_userid1
        //print(useridfolloingT1)
        
        if sender.titleLabel?.text == "Unfollow"{
            bool = false
             animate1()
            self.circularview.removeFromSuperview()
            //unfollow(unfollow_id: another_userid1)
        }else{
            bool = true
             Followstart(guest_id: another_userid1)
        }
        

        
       
        
    }
    
    func animate1(){
        self.opacityview.isHidden = false
        self.unfollowview.isHidden = false
        self.imgunfollow.isHidden = false
        
        self.opacityview.alpha = 0
        self.unfollowview.alpha = 0
        self.imgunfollow.alpha = 0
        
        UIView.animate(withDuration: 2) { () -> Void in
            self.opacityview.alpha = 0.7
            self.unfollowview.alpha = 1
            self.imgunfollow.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    func followT2(sender:UIButton){
        
        
        let point = sender.convert(CGPoint.zero, to: self.tableview2)
        guard let indexpath = self.tableview2.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id2[indexpath.row] as! String)
        let name = (self.display_name2[indexpath.row] as! String)
        
        self.poplblunfollow.text = "Are you sure you want to unfollow @\(name) ?"
        self.useridfolloingT1 = another_userid1
        print(useridfolloingT1)
        
        if sender.titleLabel?.text == "Unfollow"{
            bool = false
             self.circularview.removeFromSuperview()
             animate1()
            //unfollow(unfollow_id: another_userid1)
        }else{
            bool = true
             Followstart(guest_id: another_userid1)
        }
        
        
        
       
        
    }

    func profileview2(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableview2)
        guard let indexpath = self.tableview2.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id[indexpath.row] as! String)
        if another_userid1 != "" {
            
            if another_userid1 == standard.value(forKey: "user_id") as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Anotheruserprofile(userid2: another_userid1)
            }
            
        }
        
        
    }
    func profileview1(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableview1)
        guard let indexpath = self.tableview1.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let another_userid1 = (self.user_id[indexpath.row] as! String)
        if another_userid1 != "" {
            if another_userid1 == standard.value(forKey: "user_id") as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Anotheruserprofile(userid2: another_userid1)
            }
        }
    }

    var profile_image = NSArray()
    var display_name = NSArray()
    var user_id = NSArray()
    var follow_status = NSArray()
    var follower_list = NSArray()
    var totalFollwer = String()
    // MARK: - Api
    @IBAction func serach(_ sender: UITextField) {
        saerchPeople()
    }
    
    func saerchPeople(){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
       // [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"search_my_userlist","userid":userid , "search" : "\(searchTF.text!)" ,"follow_following_status" : "\(follower)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: (json["result"]["reason"] .stringValue))
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
//                [MBProgressHUD .hide(for: self.view, animated: true)]
                return
            }
            
            let  profilename1 = ((json["result"]["user_details"].arrayValue).map({$0["display_name"].stringValue}))
            let   profile_image = ((json["result"]["user_details"].arrayValue).map({$0["profile_image"].stringValue}))
            
            let  search_id = ((json["result"]["user_details"].arrayValue).map({$0["user_id"].stringValue}))
            
            self.profile_name = profilename1 as NSArray
            self.profile_image1 = profile_image as NSArray
            self.serachuserid1 = search_id as NSArray
//            animationView.pause()
//            animationView.removeFromSuperview()
//            [MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            DispatchQueue.main.async {
                self.searchtable.isHidden = false
                
                self.searchtable.reloadData()
                
            }
            
            
            
        }
    }
    
    
    var profile_image1 = NSArray()
    var profile_name = NSArray()
    var serachuserid1 = NSArray()
    
    func Anotheruserprofile(userid2: String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
//        [MBProgressHUD .showAdded(to: self.view, animated: true)]
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
//                [MBProgressHUD .hide(for: self.view, animated: true)]
                
            
                return
            }
            
            let user_id = ((json["result"]["details"]["user_id"].stringValue))
            let scorepoint = ((json["result"]["details"]["scorepoint"].stringValue))
            let link = ((json["result"]["details"]["link"].stringValue))
            let privacy_status = ((json["result"]["details"]["privacy_status"].stringValue))
            let profile_image = ((json["result"]["details"]["profile_image"].stringValue))
            let bio_data = ((json["result"]["details"]["bio_data"].stringValue))
            let cover_image = ((json["result"]["details"]["cover_image"].stringValue))
            let follower_status = ((json["result"]["details"]["follower_status"].stringValue))
            let full_name = ((json["result"]["details"]["full_name"].stringValue))
            let display_name = ((json["result"]["details"]["display_name"].stringValue))
            
            let post_id = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["post_id"].stringValue})))
            let photo = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["photo"].stringValue})))
             let type = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["type"].stringValue})))
            //self.delegate1?.data(user_id: user_id, scorepoint: scorepoint, link: link, privacy_status: privacy_status, profile_image: profile_image, bio_data: bio_data, cover_image: cover_image, follower_status: follower_status, post_id: post_id as NSArray, photo: photo as NSArray ,fullname:full_name , Displayname: display_name )
//            animationView.pause()
//            animationView.removeFromSuperview()
//            [MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
            vc.cover_image = cover_image
            vc.profile_image = profile_image
            vc.fullname = full_name
            vc.displayname1 = display_name
            vc.scorepoint = scorepoint
            vc.link  = link
            vc.bio_data = bio_data
            vc.privacy_status = privacy_status
            vc.guest_id = user_id
            vc.followStatus = follower_status
            vc.type1 = type as NSArray
            vc.postId = post_id as NSArray
            vc.postimageArr = photo as NSArray
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    var profile_image2 = NSArray()
    var display_name2 = NSArray()
    var user_id2 = NSArray()
    var follow_status2 = NSArray()
    var follower_list2 = NSArray()
    var totalFollwer2 = String()
    // MARK: - Api
    func FollowerlistApi(guest_id:String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
//        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"user_follower_list","userid": "\(standard.value(forKey: "user_id")!)" , "userid2" : "\(guest_id)" ,  "follow":"1" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.emptyfollowerview.isHidden =  false
//                animationView.pause()
//                animationView.removeFromSuperview()
//                [MBProgressHUD .hide(for: self.view, animated: true)]

                self.emptyscreenFollower = false
                return
            }
            self.emptyfollowerview.isHidden =  true
            var   profile_image1 = ((json["result"]["follower_list"].arrayValue).map({$0["profile_image"].stringValue}))
            var   display_name1 = ((json["result"]["follower_list"].arrayValue).map({$0["display_name"].stringValue}))
            var   user_id1 = ((json["result"]["follower_list"].arrayValue).map({$0["user_id"].stringValue}))
            var   follow_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["follow_status"].stringValue}))
            var   follower_list1 = ((json["result"]["follower_list"].arrayValue))
            var   total_followers = ((json["result"]["total_followers"].stringValue))
            var   total_followings = (((json["result"]["total_followings"].stringValue)))
            let totalFollowingsString = "Following (\(total_followings))"
            
            let str = "Followers (\(total_followers))"
            self.profile_image = profile_image1 as NSArray
            self.display_name = display_name1 as NSArray
            self.user_id = user_id1 as NSArray
            self.follow_status = follow_status1 as NSArray
            self.follower_list = follower_list1 as NSArray
            //self.totalFollwer = total_followers as String
            //print(self.totalFollwer)
//            animationView.pause()
//            animationView.removeFromSuperview()
//            [MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            self.emptyscreenFollower = true

            self.emptyfollowerview.isHidden =  true
               profile_image1 = ((json["result"]["follower_list"].arrayValue).map({$0["profile_image"].stringValue}))
               display_name1 = ((json["result"]["follower_list"].arrayValue).map({$0["display_name"].stringValue}))
               user_id1 = ((json["result"]["follower_list"].arrayValue).map({$0["user_id"].stringValue}))
               follow_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["follow_status"].stringValue}))
               follower_list1 = ((json["result"]["follower_list"].arrayValue))
               total_followings = (((json["result"]["total_followings"].stringValue)))
               total_followers = ((json["result"]["total_followers"].stringValue))
            self.profile_image2 = profile_image1 as NSArray
            self.display_name2 = display_name1 as NSArray
            self.user_id2 = user_id1 as NSArray
            self.follow_status2 = follow_status1 as NSArray
            self.follower_list2 = follower_list1 as NSArray
        
//            animationView.pause()
//            animationView.removeFromSuperview()
//            [MBProgressHUD .hide(for: self.view, animated: true)]

            self.emptyscreenFollwing = true
            
            
            
            
            
            
            
            
            DispatchQueue.main.async {
                self.followersbtn.setTitle(str, for: .normal)
                self.followingBtn.setTitle(totalFollowingsString, for: .normal)
                self.tableview1.reloadData()
                self.tableview2.reloadData()
            }
        }
    }
    
    
    
 /*   func FollowinglistApi(guest_id:String){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"user_follower_list","userid":"\(standard.value(forKey: "user_id")!)", "userid2":"\(guest_id)" , "follow":"0" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                // self.showalertview(messagestring: "No following you have done yet")
                //print("failure")
                self.emptyfollowerview.isHidden =  false
                self.followerlbl.text = "No Following. "
                animationView.pause()
                animationView.removeFromSuperview()
                self.emptyscreenFollwing = false
                return
            }
            self.emptyfollowerview.isHidden =  true
            let   profile_image1 = ((json["result"]["follower_list"].arrayValue).map({$0["profile_image"].stringValue}))
            let   display_name1 = ((json["result"]["follower_list"].arrayValue).map({$0["display_name"].stringValue}))
            let   user_id1 = ((json["result"]["follower_list"].arrayValue).map({$0["user_id"].stringValue}))
            let   follow_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["follow_status"].stringValue}))
            let   follower_list1 = ((json["result"]["follower_list"].arrayValue))
            let   total_followings = (((json["result"]["total_followings"].stringValue)))
            let   total_followers = ((json["result"]["total_followers"].stringValue))
            self.profile_image2 = profile_image1 as NSArray
            self.display_name2 = display_name1 as NSArray
            self.user_id2 = user_id1 as NSArray
            self.follow_status2 = follow_status1 as NSArray
            self.follower_list2 = follower_list1 as NSArray
            let totalFollowersString = "Followers (\(total_followers))"
            let str = "Following(\(total_followings))"
            animationView.pause()
            animationView.removeFromSuperview()
             self.emptyscreenFollwing = true
            DispatchQueue.main.async {
                self.followingBtn.setTitle(str, for: .normal)
                self.followersbtn.setTitle(totalFollowersString, for: .normal)
                self.tableview2.reloadData()
            }
        }
    }*/
    
    
    func Followstart(guest_id :String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
//        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"follow_request","request_send_by": "\(standard.value(forKey: "user_id")!)" ,"request_send_to": "\(guest_id)"]
        
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
//                [MBProgressHUD .hide(for: self.view, animated: true)]

                
                return
            }
            
            
//            animationView.pause()
//            animationView.removeFromSuperview()
//            [MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            DispatchQueue.main.async {
//                self.FollowinglistApi(guest_id: self.userid)
                self.FollowerlistApi(guest_id: self.userid)
                
            }
        }
    }
    func unfollow(unfollow_id:String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
//        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"unfollow_user","userid": "\(standard.value(forKey: "user_id")!)" ,"following_userid": unfollow_id]
        
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
//                [MBProgressHUD .hide(for: self.view, animated: true)]

                return
            }
            
            
//            animationView.pause()
//            animationView.removeFromSuperview()
//            [MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            DispatchQueue.main.async {
                
//                self.FollowinglistApi(guest_id: self.userid)
                self.FollowerlistApi(guest_id: self.userid)
            }
        }
    }
    
    
}
extension FollowingViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollview{
            if scrollView.contentOffset.x == 0 {
                self.follower = "0"
                self.followersbtn.setTitleColor(UIColor.white, for: .normal)
                self.followersbtn.backgroundColor = apppurple
                self.followingBtn.setTitleColor(apppurple, for: .normal)
                self.followingBtn.backgroundColor = UIColor.white
                addshodow(view: self.followingBtn)
                if privateuser1 == "1" {
//                    FollowerlistApi(guest_id: userid)
                }
                if emptyscreenFollower == false {
                    self.emptyfollowerview.isHidden = false
                    self.followerlbl.text = " No Followers."
                }else{
                    self.emptyfollowerview.isHidden = true
                }
            }else if scrollView.contentOffset.x == self.scrollview.bounds.width{
                self.follower = "1"
                self.followersbtn.setTitleColor(apppurple, for: .normal)
                self.followersbtn.backgroundColor = UIColor.white
                self.followingBtn.setTitleColor(UIColor.white, for: .normal)
                self.followingBtn.backgroundColor = apppurple
                addshodow(view: self.followersbtn)
                if privateuser1 == "1" {
//                    FollowinglistApi(guest_id: userid)
                }
                if emptyscreenFollwing == false {
                    self.emptyfollowerview.isHidden = false
                    self.followerlbl.text = " No Following."
                }else{
                    self.emptyfollowerview.isHidden = true
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
}
