//
//  NotificationsViewController.swift
//  Viegram
//
//  Created by Relinns on 02/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//user id pending

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import DZNEmptyDataSet
import MBProgressHUD
class NotificationsViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var navbar: UINavigationBar!
    var userid =  String()
    var status =  String()
    
    var circularview:CircularMenu?
    //@IBOutlet weak var emptyview: UIView!
    @IBAction func back(_ sender: UIBarButtonItem) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    
    var noticell = true
    
    @IBOutlet weak var requestbtn: UIButton!
    @IBOutlet weak var othernotibtn: UIButton!
    
    
    
    var typeNoti = 2
    @IBAction func requestBtnn(_ sender: UIButton)
    
    {
        if tag == 0
        {
            tag = 4
            noticell = true
            typeNoti = 2
            currentpage = 1
            DispatchQueue.main.async
                {
                    self.othernotibtn.setTitleColor(apppurple, for: .normal)
                    self.othernotibtn.backgroundColor = UIColor.white
                    self.requestbtn.setTitleColor(UIColor.white, for: .normal)
                    self.requestbtn.backgroundColor = apppurple
                    self.addshodow(view: self.othernotibtn)
                    
                    //self.display_name1.removeAllObjects()
                    //self.tableview.reloadData()
                    
            }
            self.notificationfetchApi(page: self.currentpage , type: self.typeNoti)
           }
        else
        {
            noticell = true
            typeNoti = 2
            currentpage = 1
            DispatchQueue.main.async
                {
                    self.othernotibtn.setTitleColor(apppurple, for: .normal)
                    self.othernotibtn.backgroundColor = UIColor.white
                    self.requestbtn.setTitleColor(UIColor.white, for: .normal)
                    self.requestbtn.backgroundColor = apppurple
                    self.addshodow(view: self.othernotibtn)
                    
                    //self.display_name1.removeAllObjects()
                    //self.tableview.reloadData()
                    
            }
            self.notificationfetchApi1(page: self.currentpage , type: self.typeNoti)
        }
    }
    
    
    @IBAction func Other(_ sender: UIButton)
    {
        
        if tag == 0
        {
            tag = 3;

            noticell = false
            typeNoti = 1
            currentpage = 1
            DispatchQueue.main.async {
                self.requestbtn.setTitleColor(apppurple, for: .normal)
                self.requestbtn.backgroundColor = UIColor.white
                self.othernotibtn.setTitleColor(UIColor.white, for: .normal)
                self.othernotibtn.backgroundColor = apppurple
                self.addshodow(view: self.requestbtn)
                //self.display_name1.removeAllObjects()
                //self.tableview.reloadData()
                
            }
            //self.emptyArr()
            self.notificationfetchApi(page: self.currentpage , type: self.typeNoti)
        }
        
        else
        {
            
            
            noticell = false
            typeNoti = 1
            currentpage = 1
            DispatchQueue.main.async {
                self.requestbtn.setTitleColor(apppurple, for: .normal)
                self.requestbtn.backgroundColor = UIColor.white
                self.othernotibtn.setTitleColor(UIColor.white, for: .normal)
                self.othernotibtn.backgroundColor = apppurple
                self.addshodow(view: self.requestbtn)
                //self.display_name1.removeAllObjects()
                //self.tableview.reloadData()
                
            }
            //self.emptyArr()
            self.notificationfetchApi1(page: self.currentpage , type: self.typeNoti)
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        currentpage = 1
        tag = 0
        notificationfetchApi(page: 1 , type: typeNoti)
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        self.navbar.layer.masksToBounds = false
        self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navbar.layer.shadowOpacity = 0.3
        self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navbar.layer.shadowRadius = 2.5
        
        self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
        
        self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        self.othernotibtn.setTitleColor(apppurple, for: .normal)
        self.othernotibtn.backgroundColor = UIColor.white
        self.requestbtn.setTitleColor(UIColor.white, for: .normal)
        self.requestbtn.backgroundColor = apppurple
        
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview!)
        // Do any additional setup after loading the view.
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.addshodow(view: self.othernotibtn)
        self.addshodow(view: self.view1)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(display_name1.count)
        return display_name1.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell3 = UITableViewCell()
        if noticell == true {
            if Requesttype[indexPath.row] as!  String == "request" {
                let cell1 = tableview.dequeueReusableCell(withIdentifier: "cell2") as! notiTableViewCell
                cell1.img1.sd_setImage(with: URL(string: (profile_image1[indexPath.row] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
                cell1.titile.text = display_name2[indexPath.row] as? String
                cell1.event.text = purpose1[indexPath.row] as? String
                cell1.time.text = time_ago1[indexPath.row] as? String
                cell1.accept.tag = indexPath.row
                cell1.decline.tag = indexPath.row
                cell1.accept.addTarget(self, action: #selector(self.response(sender:)), for: .touchUpInside)
                cell1.decline.addTarget(self, action: #selector(self.response(sender:)), for: .touchUpInside)
                self.status = "9"
                
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(NotificationsViewController.tapPerson(sender:)))
                cell1.titile.tag = indexPath.row
                cell1.titile.isUserInteractionEnabled = true
                cell1.titile.addGestureRecognizer(tap1)
                let tap = UITapGestureRecognizer(target: self, action: #selector(NotificationsViewController.tapPerson(sender:)))
                cell1.img1.tag = indexPath.row
                cell1.img1.isUserInteractionEnabled = true
                cell1.img1.addGestureRecognizer(tap)
                
                
                return cell1
                
            }
        }
        else{
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! notiTableViewCell
            cell.img1.sd_setImage(with: URL(string: (profile_image1[indexPath.row] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            cell.titile.text = display_name2[indexPath.row] as? String
            cell.event.text = purpose1[indexPath.row] as? String
            cell.time.text = time_ago1[indexPath.row] as? String
            if type[indexPath.row] as!  String != "6" || type[indexPath.row] as!  String != "7" || type[indexPath.row] as!  String != "5"{
                let pic = Photo[indexPath.row] as! String
                cell.img2.sd_setImage(with: URL(string: (pic)), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
                cell.img2.isHidden = false
                
            }else{
                cell.img2.isHidden = true
            }
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(NotificationsViewController.tapPerson(sender:)))
            cell.titile.tag = indexPath.row
            cell.titile.isUserInteractionEnabled = true
            cell.titile.addGestureRecognizer(tap1)
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(NotificationsViewController.tapPerson(sender:)))
            cell.img1.tag = indexPath.row
            cell.img1.isUserInteractionEnabled = true
            cell.img1.addGestureRecognizer(tap)
            
            
            return cell
        }
        return cell3
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        status = type[indexPath.row] as!  String
        if self.status as String == "1" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
            vc.postid = post_id[indexPath.row] as! String
            vc.userid =  standard.value(forKey: "user_id")! as! String
            
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
            
            
        }else if self.status as String == "2" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
            
            vc.repostid =  post_id[indexPath.row] as! String
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            navcon.pushViewController(vc, animated: true)
            
            
            
        }
            
        else if self.status as String == "3" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
            vc.repostid =  post_id[indexPath.row] as! String
            
            
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
            
        }
            
        else if self.status as String == "4" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            vc.postidNoti = user_id1[indexPath.row] as! String
            vc.bool = true
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
            
            
        }
            
        else if self.status as String == "5"{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
            
            vc.userid = user_id1[indexPath.row] as! String
            vc.status = status
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
            
            
            
        }
        else if self.status as String == "6"{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
            
            vc.guest_id = user_id1[indexPath.row] as! String
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
            
            
        }
        else  if self.status as String == "7"{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
            
            vc.guest_id = user_id1[indexPath.row] as! String
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
            
        } else  if self.status as String == "8"{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
            
            vc.repostid =  post_id[indexPath.row] as! String
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            navcon.pushViewController(vc, animated: true)
        }
        else
        {
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
            vc.postid = post_id[indexPath.row] as! String
            vc.userid =  standard.value(forKey: "user_id")! as! String
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func tapPerson(sender:UITapGestureRecognizer) {
        print("tap working",sender.view!.tag)
        let userid = user_id1[sender.view!.tag] as! String
        
        if userid != "" {
            
            if userid == standard.value(forKey: "user_id") as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Anotheruserprofile(userid2: userid)
            }
            
        }

    }
    
    
    func response(sender:UIButton){
        var response = "1"
        let userid = user_id1[sender.tag] as! String
        if sender.imageView?.image == #imageLiteral(resourceName: "notiAccept") {
            response = "1"
            self.Accept(guestid: userid, response: response)
        }else {
            response = "0"
            self.Accept(guestid: userid, response: response)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if noticell == false {
            if indexPath.row == self.display_name2.count - 1  && self.display_name2.count < totalOffset{
                notificationfetchApi(page: currentpage ,type: typeNoti)
            }
        }
        
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    var purpose1 = NSMutableArray()
    var display_name1 = NSMutableArray()
    var user_id1 = NSMutableArray()
    var display_name2 = NSMutableArray()
    var profile_image1 = NSMutableArray()
    var time_ago1 = NSMutableArray()
    var post_id = NSMutableArray()
    var type = NSMutableArray()
    var Requesttype = NSMutableArray()
    var Photo = NSMutableArray()
    //Pagination
    var totalOffset = Int()
    var currentpage = Int()
    
    var tag = Int()
    
    
    
    func emptyArr() {
        purpose1.removeAllObjects()
        display_name1.removeAllObjects()
        user_id1.removeAllObjects()
        display_name2.removeAllObjects()
        profile_image1.removeAllObjects()
        time_ago1.removeAllObjects()
        post_id.removeAllObjects()
        type.removeAllObjects()
        Requesttype.removeAllObjects()
        Photo.removeAllObjects()
        
    }
    
    // MARK: - Api
    func notificationfetchApi(page: Int , type: Int)
    {
        
//          tag = 0
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"fetch_notification","userid": "\(standard.value(forKey: "user_id")!)" , "page":page  , "type":type]
        
        print(parameter)
        
        Alamofire.request(mainurl + "timeline_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                //animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                
                self.emptyArr()
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                //animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]

                return
            }
            
            self.emptyArr()
            let   purpose = ((json["result"]["notification"].arrayValue).map({$0["purpose"].stringValue}))
            let   time_ago = ((json["result"]["notification"].arrayValue).map({$0["time_ago"].stringValue}))
            let   post_id1 = ((json["result"]["notification"].arrayValue).map({$0["post_id"].stringValue}))
            let   user_id = ((json["result"]["notification"].arrayValue).map({$0["user_id"].stringValue}))
            let   display_name = ((json["result"]["notification"].arrayValue).map({$0["display_name"].stringValue}))
            let   profile_image = ((json["result"]["notification"].arrayValue).map({$0["profile_image"].stringValue}))
            let   type1 = ((json["result"]["notification"].arrayValue).map({$0["status"].stringValue}))
            let   type = ((json["result"]["notification"].arrayValue).map({$0["type"].stringValue}))
            let   photo1 = ((json["result"]["notification"].arrayValue).map({$0["photo"].stringValue}))
            
            
            
            self.post_id.addObjects(from: post_id1)
            self.purpose1.addObjects(from: purpose)
            self.display_name1.addObjects(from: post_id1)
            self.user_id1.addObjects(from: user_id)
            self.display_name2.addObjects(from: display_name)
            self.profile_image1.addObjects(from: profile_image)
            self.time_ago1.addObjects(from: time_ago)
            self.Requesttype.addObjects(from: type)
            self.type.addObjects(from: type1)
            self.Photo.addObjects(from: photo1)
            self.totalOffset = self.display_name1.count
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            
            self.currentpage += 1
            DispatchQueue.main.async {
                
                self.tableview.reloadData()
            }
        }
    }
    ///////////////////////////////
    

    func notificationfetchApi1(page: Int , type: Int)
    {
        
        
        //        self.view.addSubview(animationView)
        //        animationView.play()
        //        animationView.loopAnimation = true
       // [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"fetch_notification","userid": "\(standard.value(forKey: "user_id")!)" , "page":page  , "type":type]
        
        print(parameter)
        
        Alamofire.request(mainurl + "timeline_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                //animationView.removeFromSuperview()
                //[MBProgressHUD .hide(for: self.view, animated:true)]
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                
                self.emptyArr()
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                //animationView.removeFromSuperview()
                //[MBProgressHUD .hide(for: self.view, animated:true)]
                
                return
            }
            
            self.emptyArr()
            let   purpose = ((json["result"]["notification"].arrayValue).map({$0["purpose"].stringValue}))
            let   time_ago = ((json["result"]["notification"].arrayValue).map({$0["time_ago"].stringValue}))
            let   post_id1 = ((json["result"]["notification"].arrayValue).map({$0["post_id"].stringValue}))
            let   user_id = ((json["result"]["notification"].arrayValue).map({$0["user_id"].stringValue}))
            let   display_name = ((json["result"]["notification"].arrayValue).map({$0["display_name"].stringValue}))
            let   profile_image = ((json["result"]["notification"].arrayValue).map({$0["profile_image"].stringValue}))
            let   type1 = ((json["result"]["notification"].arrayValue).map({$0["status"].stringValue}))
            let   type = ((json["result"]["notification"].arrayValue).map({$0["type"].stringValue}))
            let   photo1 = ((json["result"]["notification"].arrayValue).map({$0["photo"].stringValue}))
            
            
            
            self.post_id.addObjects(from: post_id1)
            self.purpose1.addObjects(from: purpose)
            self.display_name1.addObjects(from: post_id1)
            self.user_id1.addObjects(from: user_id)
            self.display_name2.addObjects(from: display_name)
            self.profile_image1.addObjects(from: profile_image)
            self.time_ago1.addObjects(from: time_ago)
            self.Requesttype.addObjects(from: type)
            self.type.addObjects(from: type1)
            self.Photo.addObjects(from: photo1)
            self.totalOffset = self.display_name1.count
            //            animationView.pause()
            //            animationView.removeFromSuperview()
            //[MBProgressHUD .hide(for: self.view, animated:true)]
            
            print("success")
            
            self.currentpage += 1
            DispatchQueue.main.async {
                
                self.tableview.reloadData()
            }
        }
    }
    
    
    ////////////////////////////////////
    

    func Anotheruserprofile(userid2: String){
        // self.view.addSubview(animationView)
        //animationView.play()
        //animationView.loopAnimation = true
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
                //animationView.pause()
                //animationView.removeFromSuperview()
                
                
                
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
           // animationView.pause()
           // animationView.removeFromSuperview()
        }
        
    }
    
    
    func Accept(guestid:String , response : String){
        self.view.addSubview(animationView)
        //animationView.play()
        //animationView.loopAnimation = true
        //{"following_userid": "28", "response": "0", "action": "respond_request", "userid": "25"}
        let parameter: Parameters = ["action":"respond_request","userid": "\(standard.value(forKey: "user_id")!)" ,"following_userid":guestid, "response":response ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                //animationView.pause()
                //animationView.removeFromSuperview()
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                
                //animationView.removeFromSuperview()
                DispatchQueue.main.async {
                    self.notificationfetchApi(page: self.currentpage , type: self.typeNoti)
                }
                return
            }
            //animationView.pause()
            //animationView.removeFromSuperview()
            DispatchQueue.main.async {
                self.notificationfetchApi(page: self.currentpage , type: self.typeNoti)
            }
        }
    }
    
    
}
extension NotificationsViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "emptymotification")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var str = "No notifications"
        if noticell == true{
            str = "No requests."
        }
        let parastyle = NSMutableParagraphStyle()
        parastyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        parastyle.alignment = NSTextAlignment.center
        //let font = UIFont.init(name: "Roboto-Light_1", size: 16.0)
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 14.0)!,NSForegroundColorAttributeName:UIColor.darkGray,NSParagraphStyleAttributeName:parastyle]
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
