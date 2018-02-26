//
//  AUserFollowerViewController.swift
//  Viegram
//
//  Created by Relinns on 31/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import DZNEmptyDataSet
import MBProgressHUD


// auser is user follower and vice versa

class AUserFollowerViewController: UIViewController,UITableViewDataSource , UITableViewDelegate ,UITextFieldDelegate{
    var circularview:CircularMenu?
    @IBOutlet weak var _popupunfollow: UILabel!
    @IBOutlet weak var _popblock: UILabel!
    @IBOutlet weak var followerlbl: UILabel!
    @IBAction func backbtn(_ sender: UIButton) {
        _=self.navigationController?.popViewController(animated: true)
        
    }
    
    var _name = String()
    var _profileimg = String()
    var _coverimg = String()
    
    
    @IBOutlet weak var emptyfollowersview: UIView!
    
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var Imgcover: UIImageView!
    
    @IBOutlet weak var followersbtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var tableview1: UITableView!
    @IBOutlet weak var tableview2: UITableView!
    
    
    var follower = "0"
    
    
    
    @IBAction func folloersBtn(_ sender: UIButton) {
        
        self.scrollview.scrollRectToVisible(CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.tableview1.frame.size.height), animated: true)

    }
    
    
    
    @IBAction func followingBtn(_ sender: UIButton) {
        self.scrollview.scrollRectToVisible(CGRect(x:self.view.frame.width,y:0,width:self.view.frame.size.width,height:self.tableview1.frame.size.height), animated: true)
    }
    
    func getFollowData(){
        
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        self.tableview1.emptyDataSetDelegate = self
        self.tableview1.emptyDataSetSource = self
        self.tableview2.emptyDataSetDelegate = self
        self.tableview2.emptyDataSetSource = self
        
        let parameter : Parameters = ["action":"merge_list", "userid":(standard.value(forKey: "user_id") as! String)]
        print(parameter)
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted, headers: nil).responseJSON { (response) in
            guard let value  = response.result.value  else{
                self.showalertview(messagestring: response.error!.localizedDescription)
                DispatchQueue.main.async
                    {
                   // animationView.removeFromSuperview()
                        [MBProgressHUD .hide(for: self.view, animated:true)]
                }
                return
            }
            
            var json = JSON(value)
            print(json)
            guard (json["result"]["msg"] .intValue) == 201 else {
                DispatchQueue.main.async {
                    //animationView.removeFromSuperview()
                    [MBProgressHUD .hide(for: self.view, animated:true)]

                }
                return
            }
            //buttons title data extract
            let total_followings = (json["result"]["total_following"].stringValue)
            let total_followers = (json["result"]["total_follower"].stringValue)
            let totalFollowersString = "Followers (\(total_followers))"
            let totalFollowingString = "Following(\(total_followings))"
            
            
            
            //follower data extract
            var   profile_image1 = ((json["result"]["follower_list"].arrayValue).map({$0["profile_image"].stringValue}))
            var   display_name1 = ((json["result"]["follower_list"].arrayValue).map({$0["display_name"].stringValue}))
            var   user_id1 = ((json["result"]["follower_list"].arrayValue).map({$0["user_id"].stringValue}))
            var   follow_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["follow_status"].stringValue}))
            let   restrict_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["restrict_status"].stringValue}))
            self.profile_image = profile_image1
            self.display_name = display_name1
            self.user_id = user_id1
            self.follow_status = follow_status1
            self.restrict_status = restrict_status1
            
            //following data extract
            profile_image1 = ((json["result"]["following_list"].arrayValue).map({$0["profile_image"].stringValue}))
            display_name1 = ((json["result"]["following_list"].arrayValue).map({$0["display_name"].stringValue}))
            user_id1 = ((json["result"]["following_list"].arrayValue).map({$0["user_id"].stringValue}))
            follow_status1 = ((json["result"]["following_list"].arrayValue).map({$0["follow_status"].stringValue}))
            self.profile_image2 = profile_image1
            self.display_name2 = display_name1
            self.user_id2 = user_id1
            self.follow_status2 = follow_status1
            
            
            //Main thread data
            DispatchQueue.main.async
                {
                    
//                animationView.pause()
              //  animationView.removeFromSuperview()
                    
                    [MBProgressHUD .hide(for: self.view, animated:true)]
                    
                    
                self.followersbtn.setTitle(totalFollowersString, for: .normal)
                self.followingBtn.setTitle(totalFollowingString, for: .normal)
                self.tableview2.reloadData()
                self.tableview1.reloadData()
            }
            
        }
        
        
    }
    
    func getFollowDataa(){
        
        //        self.view.addSubview(animationView)
        //        animationView.play()
        //        animationView.loopAnimation = true
        //[MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        self.tableview1.emptyDataSetDelegate = self
        self.tableview1.emptyDataSetSource = self
        self.tableview2.emptyDataSetDelegate = self
        self.tableview2.emptyDataSetSource = self
        
        let parameter : Parameters = ["action":"merge_list", "userid":(standard.value(forKey: "user_id") as! String)]
        print(parameter)
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted, headers: nil).responseJSON { (response) in
            guard let value  = response.result.value  else{
                self.showalertview(messagestring: response.error!.localizedDescription)
                DispatchQueue.main.async
                    {
                        // animationView.removeFromSuperview()
                        //[MBProgressHUD .hide(for: self.view, animated:true)]
                }
                return
            }
            
            var json = JSON(value)
            print(json)
            guard (json["result"]["msg"] .intValue) == 201 else {
                DispatchQueue.main.async {
                    //animationView.removeFromSuperview()
                   // [MBProgressHUD .hide(for: self.view, animated:true)]
                    
                }
                return
            }
            //buttons title data extract
            let total_followings = (json["result"]["total_following"].stringValue)
            let total_followers = (json["result"]["total_follower"].stringValue)
            let totalFollowersString = "Followers (\(total_followers))"
            let totalFollowingString = "Following(\(total_followings))"
            
            
            
            //follower data extract
            var   profile_image1 = ((json["result"]["follower_list"].arrayValue).map({$0["profile_image"].stringValue}))
            var   display_name1 = ((json["result"]["follower_list"].arrayValue).map({$0["display_name"].stringValue}))
            var   user_id1 = ((json["result"]["follower_list"].arrayValue).map({$0["user_id"].stringValue}))
            var   follow_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["follow_status"].stringValue}))
            let   restrict_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["restrict_status"].stringValue}))
            self.profile_image = profile_image1
            self.display_name = display_name1
            self.user_id = user_id1
            self.follow_status = follow_status1
            self.restrict_status = restrict_status1
            
            //following data extract
            profile_image1 = ((json["result"]["following_list"].arrayValue).map({$0["profile_image"].stringValue}))
            display_name1 = ((json["result"]["following_list"].arrayValue).map({$0["display_name"].stringValue}))
            user_id1 = ((json["result"]["following_list"].arrayValue).map({$0["user_id"].stringValue}))
            follow_status1 = ((json["result"]["following_list"].arrayValue).map({$0["follow_status"].stringValue}))
            self.profile_image2 = profile_image1
            self.display_name2 = display_name1
            self.user_id2 = user_id1
            self.follow_status2 = follow_status1
            
            
            //Main thread data
            DispatchQueue.main.async
                {
                    
                    //                animationView.pause()
                    //  animationView.removeFromSuperview()
                    
                    //[MBProgressHUD .hide(for: self.view, animated:true)]
                    
                    
                    self.followersbtn.setTitle(totalFollowersString, for: .normal)
                    self.followingBtn.setTitle(totalFollowingString, for: .normal)
                    self.tableview2.reloadData()
                    self.tableview1.reloadData()
            }
            
        }
        
        
    }
    

    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emptyfollowersview.isHidden =  true
        self.scrollview.delegate = self

//        FollowerlistApi()
//        FolloweinglistApi()
        getFollowData()
        self.searchtableview.isHidden = true
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        
        // Do any additional setup after loading the view.
        self.followersbtn.setTitleColor(UIColor.white, for: .normal)
        self.followersbtn.backgroundColor = apppurple
        self.followingBtn.setTitleColor(apppurple, for: .normal)
        self.followingBtn.backgroundColor = UIColor.white
        addshodow1(view: followersbtn)
        addshodow1(view: followingBtn)
        self.setPaddingView(strImgname: "Search", txtField: self.searchTF)
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview!)
        self.opacityview.layer.opacity = 0.8
        self.emptyfollowersview.isHidden = true
        
        self.opacityview.isHidden = true
        self.restrictedimg.isHidden = true
        self.restrictedview.isHidden = true
        self.opacityview.isHidden = true
        self.unfollowview.isHidden = true
        self.imgunfollow.isHidden = true
        
        

        self.profileTitle.text = standard.value(forKey: "display_name") as? String

        if (standard.value(forKey: "cover_image") != nil){
            
            self.Imgcover.sd_setImage(with: URL(string: standard.value(forKey: "cover_image") as! String) as URL!, placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
            
        }
        if (standard.value(forKey: "profile_image") != nil){
            
            //SDImageCache.shared().removeImage(forKey: standard.value(forKey: "profile_image") as? String)
            self.profileImg.sd_setImage(with: URL(string: standard.value(forKey: "profile_image") as! String) as URL!, placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
        }
        
        
        
        
        
        
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var beizer = UIBezierPath()
    
    
    
    
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
    
    // MARK: - tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableview1{
            return user_id.count
        }else if tableView == self.searchtableview{
            return profile_name.count
        }
        return profile_image2.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.tableview1{
            let  cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1" ) as! AUserfollowerTableViewCell
            addshodow(view: cell1.followBtn)
            addshodow(view: cell1.restrictBtn)
            if indexPath.row == 2 {
                print("2")
            }
            if restrict_status[indexPath.row]  == "0"{
                cell1.restrictBtn.setTitle("Restrict", for: .normal)
                cell1.restrictBtn.setTitleColor(allowColor, for: .normal)
                cell1.restrictBtn.backgroundColor = UIColor.white
            }else{
                cell1.restrictBtn.setTitle("Restricted", for: .normal)
                cell1.restrictBtn.setTitleColor(UIColor.white, for: .normal)
                cell1.restrictBtn.backgroundColor = allowColor
            }
            if follow_status[indexPath.row]  == "0" {
                cell1.followBtn.setTitle("Follow", for: .normal)
                cell1.followBtn.setTitleColor(apppurple, for: .normal)
                cell1.followBtn.backgroundColor = UIColor.white
            }else if follow_status[indexPath.row]  == "2" {
                cell1.followBtn.setTitle("Requested", for: .normal)
                cell1.followBtn.setTitleColor(UIColor.white, for: .normal)
                cell1.followBtn.backgroundColor = apppurple
                
            }else
            {
                cell1.followBtn.setTitle("Unfollow", for: .normal)
                cell1.followBtn.setTitleColor(UIColor.white, for: .normal)
                cell1.followBtn.backgroundColor = apppurple
                
            }
            cell1.restrictBtn.addTarget(self, action: #selector(restrictbtn(sender:)), for: .touchUpInside)
            cell1.followBtn.addTarget(self, action: #selector(followbtn1(sender:)), for: .touchUpInside)
            cell1.folloerImg.sd_setImage(with: URL(string: (profile_image[indexPath.row] )), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            cell1.folloersName.text = display_name[indexPath.row]
            
            
            cell1.prfileviewbtn.addTarget(self, action: #selector(profileview(sender:)), for: .touchUpInside)
            
            return cell1
            
            
        }
        //["action": "unfollow_user", "restrict_user": "61", "userid": "25"]
        if tableView == self.tableview2{
            
            let  cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3" ) as! AUserfollowerTableViewCell
            cell3.folloerImg.sd_setImage(with: URL(string: (profile_image2[indexPath.row] )), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            cell3.folloersName.text = display_name2[indexPath.row]
            cell3.prfileviewbtncell3.addTarget(self, action: #selector(profileview1(sender:)), for: .touchUpInside)
            
            cell3.unfollowT2.setTitle("Unfollow", for: .normal)
            cell3.unfollowT2.setTitleColor(UIColor.white, for: .normal)
            cell3.unfollowT2.backgroundColor = apppurple
            if follow_status2[indexPath.row] == "0"  {
                cell3.followyou.isHidden = true
            }else {
                cell3.followyou.isHidden = false
            }
            addshodow1(view: cell3.unfollowT2)
            cell3.unfollowT2.addTarget(self, action: #selector(unfollowbtn(sender:)), for: .touchUpInside)
            return cell3
            
        }
        if tableView == self.searchtableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchTableViewCell
            cell.namelbl.text = profile_name[indexPath.row] as? String
            cell.img.sd_setImage(with: URL(string: (profile_image1[indexPath.item] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            
            return cell
            
        }
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchtableview {
            
            let point = searchtableview.convert(CGPoint.zero, to: self.searchtableview)
            guard let indexpath = self.searchtableview.indexPathForRow(at: point) else{
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
    
    
    
    
    func followbtn1(sender:UIButton){
        self.circularview?.removeFromSuperview()
        let point = sender.convert(CGPoint.zero, to: self.tableview1)
        guard let indexpath = self.tableview1.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id[indexpath.row] )
        self.useridfolloing = another_userid1
        let name = (display_name[indexpath.row] )
        self._popupunfollow.text = "Are you sure you want to unfollow @\(name) ?"
        if sender.titleLabel?.text == "Follow" {
            Followstart(guest_id: another_userid1)
        }else if sender.titleLabel?.text == "Requested"{
            self.Followstart(guest_id :another_userid1)
        
        }else {
            unfollow()
        }
    }
    
    
    
    var useridfolloing = String()
    
    
    
    func unfollowbtn(sender:UIButton){
        
        //self.circularview?.removeFromSuperview()
        let point = sender.convert(CGPoint.zero, to: self.tableview2)
        guard let indexpath = self.tableview2.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id2[indexpath.row] )
        let name = (self.display_name2[indexpath.row])
        self._popupunfollow.text = "Are you sure you want to unfollow @\(name) ?"
        self.useridfolloing = another_userid1
        print(useridfolloing)
        
        
        unfollow()
        
    }
    
    
    
    @IBAction func cancelunfollow(_ sender: UIButton)
    {
        
        
        
        self.opacityview.isHidden = true
        self.unfollowview.isHidden = true
        self.imgunfollow.isHidden = true
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview!)
    }
    
    @IBAction func unfollow(_ sender: UIButton) {
       // self.circularview?.removeFromSuperview()
        if sender.titleLabel?.text == "Follow"{
            
        }else
        {
            self.opacityview.isHidden = true
            self.unfollowview.isHidden = true
            self.imgunfollow.isHidden = true
            unfollow(unfollow_id: useridfolloing)
            
        }
    }
    
    @IBOutlet weak var unfollowview: UIView!
    @IBOutlet weak var imgunfollow: UIImageView!
    @IBOutlet weak var opacityview: UIView!
    @IBOutlet weak var restrictedimg: UIImageView!
    @IBOutlet weak var restrictedview: UIView!
    @IBOutlet weak var restrictpersonlbl: UILabel!
    @IBAction func cancel(_ sender: UIButton) {
        self.opacityview.isHidden = true
        self.restrictedimg.isHidden = true
        self.restrictedview.isHidden = true
        
    }
    
    @IBAction func save(_ sender: UIButton) {
        self.opacityview.isHidden = true
        self.restrictedimg.isHidden = true
        self.restrictedview.isHidden = true
        print(another_userid)
        restrictuser(restrict_id: another_userid)
    }
    
    
    
    func profileview(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableview1)
        guard let indexpath = self.tableview1.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id[indexpath.row] )
        self.another_userid = another_userid1
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
        let point = sender.convert(CGPoint.zero, to: self.tableview2)
        guard let indexpath = self.tableview2.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id2[indexpath.row])
        self.another_userid = another_userid1
        if another_userid1 != "" {
            
            if another_userid1 == standard.value(forKey: "user_id") as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Anotheruserprofile(userid2: another_userid1)
            }
            
        }
        
    }
    
    
    
    var another_userid = ""
    
    
    
    func restrictbtn(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableview1)
        guard let indexpath = self.tableview1.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id[indexpath.row] )
        let name = (self.display_name[indexpath.row])
        self.another_userid = another_userid1
        self._popblock.text = "Viegram will not notify @\(name) that you've restricted them"
        print(another_userid)
        if sender.titleLabel?.text == "Restrict" {
            restrict()
        }else{
            restrictuser(restrict_id: another_userid)
        }
    }
    
    
    
    func unfollow(){
        
        
        animate1()
    }
    
    
    func restrict(){
        
        animate()
    }
    
    
    func animate(){
        self.opacityview.isHidden = false
        self.restrictedimg.isHidden = false
        self.restrictedview.isHidden = false
        
        self.opacityview.alpha = 0
        self.restrictedimg.alpha = 0
        self.restrictedview.alpha = 0
        
        UIView.animate(withDuration: 0.7) { () -> Void in
            self.restrictedimg.alpha = 1
            self.restrictedview.alpha = 1
            
            
            self.opacityview.alpha = 0.7
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    func animate1(){
        self.opacityview.isHidden = false
        self.unfollowview.isHidden = false
        self.imgunfollow.isHidden = false
        
        self.opacityview.alpha = 0
        self.unfollowview.alpha = 0
        self.imgunfollow.alpha = 0
        
        UIView.animate(withDuration: 0.7) { () -> Void in
            self.opacityview.alpha = 0.7
            self.unfollowview.alpha = 1
            self.imgunfollow.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    func addshodow1(view:UIView){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.3
    }
    
    
    var profile_image = [String]()
    var display_name = [String]()
    var user_id = [String]()
    var follow_status = [String]()
    var restrict_status = [String]()
    
    @IBOutlet weak var searchtableview: UITableView!
    
    // MARK: - Api
    
    var profile_image1 = NSArray()
    var profile_name = NSArray()
    var serachuserid1 = NSArray()
    
    @IBAction func textfield(_ sender: UITextField) {
        saerchPeople()
    }
    
    func saerchPeople(){
       // self.view.addSubview(animationView)
        
//        animationView.play()
//        animationView.loopAnimation = true
        
       [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"search_my_userlist","userid":"\(standard.value(forKey: "user_id")!)" , "search" : "\(searchTF.text!)" ,"follow_following_status" : "\(follower)" ]
        
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
                // print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                
                [MBProgressHUD .hide(for: self.view, animated:true)]
                
                
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
            [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            DispatchQueue.main.async {
                self.searchtableview.isHidden = false
                self.searchtableview.reloadData()
            }
        }
    }
    

    func FollowerlistApi(){
        
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"follower_list","userid": "\(standard.value(forKey: "user_id")!)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                //self.showalertview(messagestring: "No user follows you yet")
                self.emptyfollowersview.isHidden =  false
                self.followerlbl.text = " Seems like you have no Followers. \n Invite friends to follow you."
                // print("failure")
                
//                animationView.pause()
//                animationView.removeFromSuperview()
                
                [MBProgressHUD .hide(for: self.view, animated: true)]
                

                
                let str = "Follower(\(0))"
                DispatchQueue.main.async {
                    self.followersbtn.setTitle(str, for: .normal)
                    
                }
                return
            }
            self.emptyfollowersview.isHidden =  true
            let   profile_image1 = ((json["result"]["follower_list"].arrayValue).map({$0["profile_image"].stringValue}))
            let   display_name1 = ((json["result"]["follower_list"].arrayValue).map({$0["display_name"].stringValue}))
            let   user_id1 = ((json["result"]["follower_list"].arrayValue).map({$0["user_id"].stringValue}))
            let   follow_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["follow_status"].stringValue}))
            let   restrict_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["restrict_status"].stringValue}))
            let total_followings = (json["result"]["total_following"].stringValue)
            let total_followers = (json["result"]["total_follower"].stringValue)
            let totalFollowersString = "Followers (\(total_followers))"
            let totalFollowingString = "Following(\(total_followings))"
            self.profile_image = profile_image1
            self.display_name = display_name1
            self.user_id = user_id1
            self.follow_status = follow_status1
            self.restrict_status = restrict_status1

//            animationView.pause()
//            animationView.removeFromSuperview()
            
            [MBProgressHUD .hide(for: self.view, animated: true)]

            
            print("success")
            DispatchQueue.main.async {
                self.followersbtn.setTitle(totalFollowersString, for: .normal)
                self.followingBtn.setTitle(totalFollowingString, for: .normal)
                self.tableview1.reloadData()
            }
        }
    }
    func FolloweinglistApi(){
        
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"following_list","userid": "\(standard.value(forKey: "user_id")!)" ]
        print(parameter)
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                print(response.result.error!.localizedDescription)
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                // self.showalertview(messagestring: "Error")
                //  self.showalertview(messagestring: "No user follows you yet")
                // print("failure")
                self.emptyfollowersview.isHidden = false
                
                self.followerlbl.text =  "Seems like you don't follow any people yet.\n Follow people to see their posts."
                let str = "Following(\(0))"
                DispatchQueue.main.async {
                    self.followingBtn.setTitle(str, for: .normal)
                    
                }
//                animationView.pause()
//                animationView.removeFromSuperview()
                
                [MBProgressHUD .hide(for: self.view, animated: true)]
                
                return
            }
            self.emptyfollowersview.isHidden =  true
            let   profile_image1 = ((json["result"]["following_list"].arrayValue).map({$0["profile_image"].stringValue}))
            let   display_name1 = ((json["result"]["following_list"].arrayValue).map({$0["display_name"].stringValue}))
            let   user_id1 = ((json["result"]["following_list"].arrayValue).map({$0["user_id"].stringValue}))
            let   follow_status1 = ((json["result"]["following_list"].arrayValue).map({$0["follow_status"].stringValue}))
            // let   restrict_status1 = ((json["result"]["follower_list"].arrayValue).map({$0["restrict_status"].stringValue}))
            let total_followings = (json["result"]["total_following"].stringValue)
            let total_followers = (json["result"]["total_follower"].stringValue)
            let totalFollowersString = "Followers (\(total_followers))"
            self.profile_image2 = profile_image1
            self.display_name2 = display_name1
            self.user_id2 = user_id1
            self.follow_status2 = follow_status1
            let str = "Following (\(total_followings))"
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            
            [MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            DispatchQueue.main.async {
                self.followingBtn.setTitle(str, for: .normal)
                self.followersbtn.setTitle(totalFollowersString, for: .normal)
                self.tableview2.reloadData()
            }
        }
    }

    
    func restrictuser(restrict_id:String)
    {
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"restrict_user","userid": "\(standard.value(forKey: "user_id")!)" ,"restrict_user": restrict_id]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: "No user follows you yet")
                print("failure")
                
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]
                return
            }
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            DispatchQueue.main.async {
                self.tableview1.reloadData()
                self.getFollowData()
            }
        }
    }
    var profile_image2 = [String]()
    var display_name2 = [String]()
    var user_id2 = [String]()
    var follow_status2 = [String]()
    var restrict_status2 = [String]()
    
    
    func Followstart(guest_id :String){
        self.view.addSubview(animationView)
        
//        animationView.play()
//        animationView.loopAnimation = true
        
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"follow_request","request_send_by": "\(standard.value(forKey: "user_id")!)" ,"request_send_to": "\(guest_id)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard json["result"]["reason"].stringValue != "request deleted successfully" else {
//                animationView.pause()
//                animationView.removeFromSuperview()
                
                [MBProgressHUD .hide(for: self.view, animated: true)]
                print("success")
                DispatchQueue.main.async {
                    self.getFollowData()
                    
                }
                return
            }
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: (json["result"]["reason"] .stringValue))
                print("failure")
                //animationView.pause()
               // animationView.removeFromSuperview()
                
                return
            }
            
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            DispatchQueue.main.async {
                self.getFollowData()
                
            }
        }
    }
    
    
    
    func unfollow(unfollow_id:String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
       // [MBProgressHUD .showAdded(to: self.view, animated: true)]
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
                
                //[MBProgressHUD .hide(for: self.view, animated: true)]
                
                return
            }
            
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            
//[MBProgressHUD .hide(for: self.view, animated: true)]

            print("success")
            DispatchQueue.main.async {
                
                self.tableview2.reloadData()
                self.getFollowDataa()
            }
        }
    }
    
    
    
    
    func Anotheruserprofile(userid2: String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
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
                [MBProgressHUD .hide(for: self.view, animated: true)]
                
                
                
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
            animationView.pause()
            animationView.removeFromSuperview()
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
            vc.postId = post_id as NSArray
            vc.postimageArr = photo as NSArray
            vc.guest_id = user_id
            vc.followStatus = follower_status
            vc.type1 = type as NSArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension AUserFollowerViewController :UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollview{
            if scrollView.contentOffset.x == 0 {
                follower = "0"
                self.followersbtn.setTitleColor(UIColor.white, for: .normal)
                self.followersbtn.backgroundColor = apppurple
                self.followingBtn.setTitleColor(apppurple, for: .normal)
                self.followingBtn.backgroundColor = UIColor.white
                addshodow1(view: followersbtn)
                addshodow1(view: followingBtn)
            }else if scrollView.contentOffset.x == self.scrollview.bounds.width{
                follower = "1"
                self.followersbtn.setTitleColor(apppurple, for: .normal)
                self.followersbtn.backgroundColor = UIColor.white
                self.followingBtn.setTitleColor(UIColor.white, for: .normal)
                self.followingBtn.backgroundColor = apppurple
                addshodow1(view: followersbtn)
                addshodow1(view: followingBtn)
            }
        }
    }

}
extension AUserFollowerViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "emptyfollowers")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No results found!"
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 16.0)!,NSForegroundColorAttributeName:apppurple]
        return NSAttributedString.init(string: str, attributes: attributes )
    }
}

