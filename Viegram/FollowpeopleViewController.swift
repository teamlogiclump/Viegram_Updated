
//
//  FollowpeopleViewController.swift
//  Viegram
//
//  Created by Jagdeep on 04/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import DZNEmptyDataSet
import MBProgressHUD

class FollowpeopleViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var nav: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        Followpeople()
        self.table.emptyDataSetSource = self
        self.table.emptyDataSetDelegate = self
        addshodow(view: self.nav)
        
        DispatchQueue.main.async {
            self.nav.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            self.nav.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        }
        let view = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        self.view.addSubview(view)
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        addShadow(view: self.nav, opacity: 0.3, radius: 2.5)
    }
    
    func addShadow(view:UIView,opacity:Float,radius: CGFloat){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = radius
    }
    
    
    func setGradientBackground(view:UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
        //gradientLayer.locations = [ 0.0,0.25,0.50, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBOutlet weak var back: UIBarButtonItem!
    

    @IBAction func back(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user_id1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        {
        //             if indexPath.row == 0{
        //            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1") as! FolllowpeopleTableViewCell
        //
        //            return cell1
        //            }else{
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! FolllowpeopleTableViewCell
        cell2.img2.sd_setImage(with: URL(string: (profile_image1[indexPath.row] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
        cell2.name2.text = display_name2[indexPath.row] as? String
        cell2.btn2.addTarget(self, action: #selector(self.follow(sender:)), for: .touchUpInside)
        //cell2.profilebtn.addTarget(self, action: #selector(self.profileview(sender:)), for: .touchUpInside)
        cell2.profilebtn1.addTarget(self, action: #selector(self.profileview(sender:)), for: .touchUpInside)
        self.addshodow(view: cell2.btn2)
        return cell2
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    
    
    
    var user_id1 = NSArray()
    var display_name2 = NSArray()
    var profile_image1 = NSArray()
    
    // MARK: - Api
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var index_path = IndexPath()
    func follow(sender:UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableview)
        guard let indexpath = self.tableview.indexPathForRow(at: point) else
        {
            print("error")
            return
        }
        index_path = indexpath
        let another_userid1 = (self.user_id1[indexpath.row] as! String)
        
        Followstart(guest_id: another_userid1)
        
    }
    
    func profileview(sender:UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableview)
        guard let indexpath = self.tableview.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let another_userid1 = (self.user_id1[indexpath.row] as! String)
        
        if another_userid1 != "" {
            
            if another_userid1 == standard.value(forKey: "user_id") as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Anotheruserprofile(userid2: another_userid1)
                
            }
        }
    }
    func Followstart(guest_id :String){
        
//        self.view.addSubview(animationView)
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
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                // self.showalertview(messagestring: (json["result"]["reason"] .stringValue))
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
                let cell = self.tableview.cellForRow(at: self.index_path) as! FolllowpeopleTableViewCell
                
                if (json["result"]["reason"] .stringValue) == "Following request send successfully" {
                    
                    cell.btn2.setTitle("Requested", for: .normal)
                }else if  (json["result"]["reason"] .stringValue) == "request deleted successfully" {
                    cell.btn2.setTitle("Follow", for: .normal)
                }else{
                    cell.btn2.setTitle("Following", for: .normal)
                }
                // self.Followpeople()
            }
        }
    }
    func Followpeople()
    {
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"all_user_list","userid": "\(standard.value(forKey: "user_id")!)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                // self.showalertview(messagestring: "")
                //                animationView.pause()
                
                //animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]
                
                return
            }
            
            let   profile_image = ((json["result"]["user_details"].arrayValue).map({$0["profile_image"].stringValue}))
            let   user_id = ((json["result"]["user_details"].arrayValue).map({$0["user_id"].stringValue}))
            let   display_name = ((json["result"]["user_details"].arrayValue).map({$0["display_name"].stringValue}))
            
            
            self.profile_image1 = profile_image as NSArray
            self.user_id1 = user_id as NSArray
            self.display_name2 = display_name as NSArray
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]

            
            print("success")
            DispatchQueue.main.async
                {
                self.tableview.reloadData()
            }
        }
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
            let profile_image = ((json["result"]["details"]["profile_image"].stringValue))
            let bio_data = ((json["result"]["details"]["bio_data"].stringValue))
            let cover_image = ((json["result"]["details"]["cover_image"].stringValue))
            let follower_status = ((json["result"]["details"]["follower_status"].stringValue))
            let full_name = ((json["result"]["details"]["full_name"].stringValue))
            let display_name = ((json["result"]["details"]["display_name"].stringValue))
            
            let post_id = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["post_id"].stringValue})))
            let photo = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["photo"].stringValue})))
            let type = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["type"].stringValue})))
            
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
            vc.type1 = type as NSArray
            vc.bio_data = bio_data
            vc.privacy_status = privacy_status
            vc.postId = post_id as NSArray
            vc.postimageArr = photo as NSArray
            vc.guest_id = user_id
            vc.followStatus = follower_status
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension FollowpeopleViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "emptyfollowers")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No results found!"
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 16.0)!,NSForegroundColorAttributeName:apppurple]
        return NSAttributedString.init(string: str, attributes: attributes )
    }
}

