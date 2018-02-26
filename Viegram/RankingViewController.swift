//
//  RankingViewController.swift
//  Viegram
//
//  Created by Relinns on 29/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import DZNEmptyDataSet
import MBProgressHUD


class RankingViewController: UIViewController,UITableViewDataSource , UITableViewDelegate {
    @IBOutlet weak var followerRankingLbl: UILabel!
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var leaders: UIButton!
    @IBOutlet weak var myranking: UIButton!
    @IBOutlet weak var followersranking: UIButton!
    var leaderTag :Int = 0
    var myRanlTag : Int = 0
    var followTag : Int = 0
    
    var leaderarr = NSArray()
    var circularview:CircularMenu?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        leaderTag = 1
        myRanlTag = 1
        followTag = 1
        
        OverallRankingApi()
        
        self.navbar.layer.masksToBounds = false
        self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navbar.layer.shadowOpacity = 0.3
        self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navbar.layer.shadowRadius = 2.5
        
        
        DispatchQueue.main.async {
            self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            
            self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
            
            // Do any additional setup after loading the view.
            
            //           self.myranking.layer.borderColor = apppurple.cgColor
            //            self.myranking.layer.borderWidth = 0.3
            //            self.followersranking.layer.borderColor = apppurple.cgColor
            //            self.followersranking.layer.borderWidth = 0.3
            self.addshodow(view: self.leaders)
            self.addshodow(view: self.myranking)
            self.addshodow(view: self.followersranking)
        }
        
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview!)
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leaders1(_ sender: UIButton)
    {
        
            DispatchQueue.main.async {
                self.scroll_view.scrollRectToVisible(CGRect(x:0,y:0,width:self.view1.frame.size.width,height:self.view1.frame.size.height), animated: true)
                self.leaders.setTitleColor(.white, for: .normal)
                self.leaders.backgroundColor = apppurple
                
                self.myranking.setTitleColor(apppurple, for: .normal)
                self.myranking.backgroundColor = UIColor.white
                self.followersranking.setTitleColor(apppurple, for: .normal)
                self.followersranking.backgroundColor = UIColor.white
            }
            
            self.addshodow(view: self.leaders)
            self.addshodow(view: self.myranking)
            self.addshodow(view: self.followersranking)

    }
    @IBAction func my_ranking(_ sender: UIButton)
    {
        if self.myRanlTag == 1 {
           
            self.scroll_view.scrollRectToVisible(CGRect(x:self.view.frame.size.width ,y:0,width:self.view1.frame.size.width,height:self.view1.frame.size.height), animated: true)
            DispatchQueue.main.async {
                
                self.leaders.setTitleColor(apppurple, for: .normal)
                self.leaders.backgroundColor = UIColor.white
                self.myranking.setTitleColor(.white, for: .normal)
                self.myranking.backgroundColor = apppurple
                self.followersranking.setTitleColor(apppurple, for: .normal)
                self.followersranking.backgroundColor = UIColor.white
                self.addshodow(view: self.leaders)
                self.addshodow(view: self.myranking)
                self.addshodow(view: self.followersranking)
                self.MyRankingApi()
                self.myRanlTag = 2
            }
        }
        else
        {
            self.scroll_view.scrollRectToVisible(CGRect(x:self.view.frame.size.width ,y:0,width:self.view1.frame.size.width,height:self.view1.frame.size.height), animated: true)
            DispatchQueue.main.async {
                
                self.leaders.setTitleColor(apppurple, for: .normal)
                self.leaders.backgroundColor = UIColor.white
                self.myranking.setTitleColor(.white, for: .normal)
                self.myranking.backgroundColor = apppurple
                self.followersranking.setTitleColor(apppurple, for: .normal)
                self.followersranking.backgroundColor = UIColor.white
                self.addshodow(view: self.leaders)
                self.addshodow(view: self.myranking)
                self.addshodow(view: self.followersranking)
               // self.MyRankingApi()
                //self.myRanlTag = 2
            }
            
            
        }
        
        
    }
    
    @IBAction func foloerranking1(_ sender: UIButton)
    {
        if self.followTag == 1
        {
            
            self.scroll_view.scrollRectToVisible(CGRect(x:view.frame.size.width * 2,y:0,width:self.view1.frame.size.width,height:self.view1.frame.size.height), animated: true)
            DispatchQueue.main.async {
                
                self.leaders.setTitleColor(apppurple, for: .normal)
                self.leaders.backgroundColor = UIColor.white
                self.myranking.setTitleColor(apppurple, for: .normal)
                self.myranking.backgroundColor = UIColor.white
                self.followersranking.setTitleColor(.white, for: .normal)
                self.followersranking.backgroundColor = apppurple
                
            }
            self.addshodow(view: self.leaders)
            self.addshodow(view: self.myranking)
            self.addshodow(view: self.followersranking)
            User_followers_Api()
            self.followTag = 2
        }
        
        else
        {
            self.scroll_view.scrollRectToVisible(CGRect(x:view.frame.size.width * 2,y:0,width:self.view1.frame.size.width,height:self.view1.frame.size.height), animated: true)
            DispatchQueue.main.async {
                
                self.leaders.setTitleColor(apppurple, for: .normal)
                self.leaders.backgroundColor = UIColor.white
                self.myranking.setTitleColor(apppurple, for: .normal)
                self.myranking.backgroundColor = UIColor.white
                self.followersranking.setTitleColor(.white, for: .normal)
                self.followersranking.backgroundColor = apppurple
                
            }
            self.addshodow(view: self.leaders)
            self.addshodow(view: self.myranking)
            self.addshodow(view: self.followersranking)
           // User_followers_Api()
            //self.followTag = 2
            
        }
        
        
      
    }
    
    
    
    
    @IBOutlet weak var view1: UIView!
    
    
   
    
    
    
    
    @IBOutlet weak var scroll_view: UIScrollView!
    
    @IBOutlet weak var tableview1: UITableView!
    @IBOutlet weak var tableview2: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
   
    
    
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        _=self.navigationController?.popViewController(animated: true)
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableview1 {
            return user_id1.count
        }else{
            
            self.followerRankingLbl.text = f_name.count == 0 ? "" : "Viegram Position"
            return f_name.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if tableView == self.tableview1{
            //            if user_id1[indexPath.row] as! String != ""{
            let cell1 = tableview1.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! RAnkingTableViewCell
            cell1.title1lbl.text = leaderarr[indexPath.row] as? String
            
            if self.photo1[indexPath.row] as! String != "" {
               cell1.image1.sd_setImage(with: URL(string : (photo1[indexPath.row] as! String)), placeholderImage: placeholder1)
            }else{
              cell1.image1.sd_setImage(with: URL(string : (photo1[indexPath.row] as! String)))
            }
            
            cell1.lbl1.text = name1[indexPath.row] as? String
            cell1.profileview.addTarget(self, action: #selector(profileview(sender:)), for: .touchUpInside)
            cell1.linelbl1.isHidden = indexPath.row == 3 ? true : false
            
            return cell1
        }
        if tableView == self.tableview2{
            let  cell2 = tableview2.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! Ranking2TableViewCell
            // cell2.headertitle.text = "Viegram Position"
            cell2.imgT2.sd_setImage(with: URL(string : (f_photo[indexPath.row] as! String)))
            cell2.nameT2.text = f_name[indexPath.row] as? String
            cell2.positionT2.text = f_rank[indexPath.row] as? String
            cell2.imgbtn.addTarget(self, action: #selector(profileview2(sender:)), for: .touchUpInside)
            cell2.namebtn.addTarget(self, action: #selector(profileview2(sender:)), for: .touchUpInside)
            return cell2
            
        }
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    

    func profileview(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableview1)
        guard let indexpath = self.tableview1.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id1[indexpath.row] as! String)
        print(another_userid1)
        
        if another_userid1 != "" {
            
            if another_userid1 == standard.value(forKey: "user_id") as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Anotheruserprofile(userid2: another_userid1)
                
            }
            
        }
        
        
    }
    
    
    
    
    func profileview2(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableview2)
        guard let indexpath = self.tableview2.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.f_user_id[indexpath.row] as! String)
        print(another_userid1)
        
        if another_userid1 != "" {
            
            if another_userid1 == standard.value(forKey: "user_id") as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Anotheruserprofile(userid2: another_userid1)
                
            }
            
        }
        
   
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    func addshodow1(view:UIView){
        let shadowSize : CGFloat = 0.1
        /* let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
         y: -shadowSize / 2,
         width: view.frame.size.width + shadowSize,
         height: view.frame.size.height + shadowSize))*/
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 0.5
        //view.layer.shadowPath = shadowPath.cgPath
    }
    
    
    
    
    var user_id1 = NSArray()
    var photo1 = NSArray()
    var name1 = NSArray()
    
    func OverallRankingApi(){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"overall_ranking","userid" : "\(standard.value(forKey: "user_id")!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "ranking_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                // self.showalertview(messagestring: "Error")
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)];

                
                
                return
            }
            
            let user_id = (((json["result"]["ranking_details"].arrayValue).map({$0["user_id"].stringValue})))
            let photo = (((json["result"]["ranking_details"].arrayValue).map({$0["profile_image"].stringValue})))
            let name = (((json["result"]["ranking_details"].arrayValue).map({$0["display_name"].stringValue})))
            let msg = (((json["result"]["ranking_details"].arrayValue).map({$0["msg"].stringValue})))
            self.photo1 = photo as NSArray
            self.name1 = name as NSArray
            self.user_id1 = user_id as NSArray
            self.leaderarr = msg as NSArray
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]
            
            print("success")
            DispatchQueue.main.async {
                
                self.tableview1.reloadData()
                
            }
            
            
        }
    }
    
    
    @IBOutlet weak var countrylbl: UILabel!
    @IBOutlet weak var viePositionlbl: UILabel!
    @IBOutlet weak var followerpostion: UILabel!
    @IBOutlet weak var followingposition: UILabel!
    
    
    
    
    
    func MyRankingApi(){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)];
        let parameter: Parameters = ["action":"user_ranking","userid" : "\(standard.value(forKey: "user_id")!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "ranking_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                // self.showalertview(messagestring: "Error")
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)];
                return
            }
            let followerrank1 = (json["result"]["follower_rank"].stringValue)
            let following_rank1 = (json["result"]["following_rank"].stringValue)
            let country_rank1 = (json["result"]["country_rank"].stringValue)
            let viegram_rank1 = (json["result"]["viegram_rank"].stringValue)
            
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)];

            print("success")
            DispatchQueue.main.async {
                self.countrylbl.text = country_rank1
                self.viePositionlbl.text = viegram_rank1
                self.followerpostion.text = followerrank1
                self.followingposition.text = following_rank1
                
            }
            
        }
    }
    
    var f_user_id = NSArray()
    var f_photo = NSArray()
    var f_name = NSArray()
    var f_rank = NSArray()
    
    
    
    
    
    func User_followers_Api(){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)];
        let parameter: Parameters = ["action":"follower_ranking","userid" : "\(standard.value(forKey: "user_id")!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "ranking_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                //self.showalertview(messagestring: "Error")
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)];

                
                return
            }
            let user_id = (((json["result"]["follower_details"].arrayValue).map({$0["user_id"].stringValue})))
            let photo = (((json["result"]["follower_details"].arrayValue).map({$0["profile_image"].stringValue})))
            let name = (((json["result"]["follower_details"].arrayValue).map({$0["display_name"].stringValue})))
            let rank = (((json["result"]["follower_details"].arrayValue).map({$0["rank"].stringValue})))
            self.f_photo = photo as NSArray
            self.f_name = name as NSArray
            self.f_user_id = user_id as NSArray
            self.f_rank = rank as NSArray
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)];

            print("success")
            DispatchQueue.main.async {
                //                self.countrylbl.text = country_rank1
                //                self.viePositionlbl.text = viegram_rank1
                //                self.followerpostion.text = followerrank1
                //                self.followingposition.text = following_rank1
                
                self.tableview2.reloadData()
                
            }
            
        }
    }
    
    
    
    
    func Anotheruserprofile(userid2: String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)];
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
                //self.showalertview(messagestring: "Error")
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)];

                
                
                
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
            [MBProgressHUD .hide(for: self.view, animated:true)];

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
            vc.postId = post_id as NSArray
            vc.postimageArr = photo as NSArray
            vc.type1 = type as NSArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
extension RankingViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "emptyfollowers")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "It's empty here!"
        let attributes:[String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 16.0)!,NSForegroundColorAttributeName:apppurple]
        
        
        return NSAttributedString.init(string: str, attributes: attributes )
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let str = "Seems like you have no Followers."
        
        let parastyle = NSMutableParagraphStyle()
        parastyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        parastyle.alignment = NSTextAlignment.center
        
        
        //let font = UIFont.init(name: "Roboto-Light_1", size: 16.0)
        let attributes:[String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 14.0)!,NSForegroundColorAttributeName:UIColor.darkGray,NSParagraphStyleAttributeName:parastyle]
        return NSAttributedString.init(string: str, attributes: attributes )
        
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
