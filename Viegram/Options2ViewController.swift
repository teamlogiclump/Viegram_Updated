//
//  Options2ViewController.swift
//  Viegram
//
//  Created by Relinns on 30/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import MessageUI
import MBProgressHUD

class Options2ViewController: UIViewController , MFMailComposeViewControllerDelegate {

    var reference_link = String()
    var shareString = "Hey there, follow me on Viegram and join the exciting photo gaming world."
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        _=self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetUsersettings()

        
        self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
        self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        self.navbar.layer.masksToBounds = false
        self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navbar.layer.shadowOpacity = 0.3
        self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navbar.layer.shadowRadius = 2.5
        
        let view = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(view)
         animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
    }
    override func viewWillAppear(_ animated: Bool) {
        //GetUsersettings()
    }
    
    
    override func viewDidLayoutSubviews() {
        addshodow(view: self.aboutView)
        addshodow(view: self.accountview)
        addshodow(view: self.noti)
        addshodow(view: self.follow)
        addshodow(view: self.supportview)
        addshodow(view: self.followpeople)
        addshodow(view: self.inviteview)
        addshodow(view: self.logouview)
        addshodow(view: self.blockView)
    }
    func setGradientBackground(view:UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
   
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var accountview: UIView!
    @IBOutlet weak var noti: UIView!
    @IBOutlet weak var follow: UIView!
    @IBOutlet weak var supportview: UIView!
    @IBOutlet weak var inviteview: UIView!
    @IBOutlet weak var logouview: UIView!
    @IBOutlet weak var followpeople: UIView!

    @IBAction func howworks(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HowWorksViewController") as!  HowWorksViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func blockListAction(_ sender: Any) {
        //BlockedListViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlockedListViewController") as!  BlockedListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    @IBAction func terms(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsconditionsViewController") as! TermsconditionsViewController
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhototourViewController") as! PhototourViewController
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editprofile(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Changesettings") as! UpdateProfileViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
 
    }
    @IBAction func privacy(_ sender: UISwitch) {
        
        
        self.privacy = self.privateswitch.isOn == true ? "1" : "0"

    }
    
    @IBAction func likesbtn(_ sender: UIButton) {
        
        sender.setImage(sender.imageView!.image == #imageLiteral(resourceName: "imgcheck1") ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
        
        self.likes = self.likes == "0" ? "1" : "0"
        
    }
    @IBAction func commentbtn(_ sender: UIButton) {
        sender.setImage(sender.imageView!.image == #imageLiteral(resourceName: "imgcheck1") ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
        
        self.comments = self.comments == "0" ? "1" : "0"

    }
    
    @IBAction func tags(_ sender: UIButton) {
        
        sender.setImage(sender.imageView!.image == #imageLiteral(resourceName: "imgcheck1") ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
        
        self.tags = self.tags == "0" ? "1" : "0"

    }
    @IBAction func repost(_ sender: UIButton) {
        
        
        sender.setImage(sender.imageView!.image == #imageLiteral(resourceName: "imgcheck1") ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
        
        self.repost = self.repost == "0" ? "1" : "0"
        
       
    }
    @IBAction func follow(_ sender: UIButton) {
        sender.setImage(sender.imageView!.image == #imageLiteral(resourceName: "imgcheck1") ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
        
        self.follow_request = self.follow_request == "0" ? "1" : "0"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func logout(_ sender: UIButton) {
        logout()
       
    }

    @IBAction func invitepeople(_ sender: UIButton) {
        let text = self.shareString
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    @IBAction func legenficon(_ sender: UIButton) {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    @IBAction func followpeople(_ sender: UIButton) {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowpeopleViewController") as! FollowpeopleViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func supportbtn(_ sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["teamviegram@gmail.com"])
            mail.setSubject("Support App")
            mail.setMessageBody("<p>Send us your issue!</p>", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            self.showalertview(messagestring: "Your device could not send e-mail. Please check e-mail configuration and try again.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func chnagepass(_ sender: UIButton) {
        DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Update_passViewController") as! Update_passViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func logout(){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"logout","userid":"\(standard.value(forKey: "user_id")!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "password_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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
                [MBProgressHUD .hide(for: self.view, animated:true)]
                
                
                
                return
            }
//            animationView.pause()
//            animationView.removeFromSuperview()
            
            [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            DispatchQueue.main.async {
                standard.set("", forKey: "user_id")
                standard.set("", forKey: "profile_image")
                appDelegate.window?.rootViewController?.removeFromParentViewController()
                appDelegate.SignInView()
            }
            
            
            print( standard.value(forKey: "user_id")!)
        }
    }
    
    func GetUsersettings(){
        
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        //[MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"get_settings","userid" : "\(standard.value(forKey: "user_id")!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "ranking_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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
                //[MBProgressHUD .hide(for: self.view, animated:true)]
                
                return
            }
            let comments = ((json["result"]["setting_details"]["comments"].stringValue))
            let repost =  ((json["result"]["setting_details"]["repost"].stringValue))
            let privacy =  ((json["result"]["setting_details"]["privacy"].stringValue))
            let follow_request =  ((json["result"]["setting_details"]["follow_request"].stringValue))
            let likes =  ((json["result"]["setting_details"]["likes"].stringValue))
            let tags =  ((json["result"]["setting_details"]["tags"].stringValue))
            self.shareString =  "Hey there, follow me on Viegram and join the exciting photo gaming world. " + json["result"]["reference_link"].stringValue
            self.reference_link = ((json["result"]["reference_link"].stringValue))
            print(self.reference_link)
//            animationView.pause()
            //animationView.removeFromSuperview()
           // [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            DispatchQueue.main.async {
                
                self._commentsbtn.setImage(comments == "0" ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
                self._reposts.setImage(repost == "0" ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
                self._follow_requests.setImage(follow_request == "0" ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
                self._likesbtn.setImage(likes == "0" ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
                self._tagbtn.setImage(tags == "0" ? #imageLiteral(resourceName: "imguncheck1") : #imageLiteral(resourceName: "imgcheck1"), for: .normal)
                self.privateswitch.isOn = privacy == "0" ? false : true
                
            }
            
            self.privacy = privacy
            self.likes = likes
            self.comments = comments
            self.tags = tags
            self.repost = repost
            self.follow_request = follow_request
        }
    }
    
    @IBOutlet weak var privateswitch: UISwitch!
    var privacy = String()
    var likes = String()
    var comments = String()
    var tags = String()
    var repost = String()
    var follow_request = String()
    
    @IBOutlet weak var _likesbtn: UIButton!
    @IBOutlet weak var _commentsbtn: UIButton!
    @IBOutlet weak var _tagbtn: UIButton!
    @IBOutlet weak var _reposts: UIButton!
    @IBOutlet weak var _follow_requests: UIButton!

    override func viewWillDisappear(_ animated: Bool) {
        
        AddUsersettings(privacy: privacy, likes: likes, comments: comments, tags: tags, repost: repost, following_request: follow_request)
    }
    func AddUsersettings(privacy :String , likes :String ,comments :String ,tags :String ,repost:String , following_request : String){
       // self.view.addSubview(animationView)

        let parameter: Parameters = ["action":"add_settings","userid" : "\(standard.value(forKey: "user_id")!)","privacy": privacy, "likes":likes, "comments": comments, "tags":tags, "repost": repost, "follow_request": following_request]
        
        print(parameter)
        
        Alamofire.request(mainurl + "ranking_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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
                [MBProgressHUD .hide(for: self.view, animated:true)]

                
                return
            }
 
        }
    }

}
