//
//  OptionsViewController.swift
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

class OptionsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var tableViewBg: UIView!
    @IBOutlet weak var tableview1: UITableView!
    var OptionArr = NSArray()
     var imgArr = NSArray()
    
//     var OptionArr:NSArray = ["Home screens/Timeline","Your Profile","Stats(breakdown of points you've scored","Followers and those you're following","Notifications","Options","Search people","Ranking(Viegram leaders,your ranking your followers ranking","Upload photo","Like(click to like a photo or comment","Comment(add a comment)","Repost"]
    
//    var imgArr:NSArray = ["home","Profile","stas","followers","noti","optiond","search","ranking","upload","like","comment","repost"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconGuide()
        self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
        self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        
        self.navbar.layer.masksToBounds = false
        self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navbar.layer.shadowOpacity = 0.3
        self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navbar.layer.shadowRadius = 2.5

        // Do any additional setup after loading the view.
        self.addShadow(view: self.tableViewBg)
    }

    
    func addShadow(view:UIView){
        view.layer.shadowRadius = 0.5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OptionArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OptionsTableViewCell
        cell1.lbl.text = self.OptionArr[indexPath.row] as? String
       // cell1.amountlbl.text = self.amount1[indexPath.row] as? String
        cell1.img.sd_setImage(with: URL(string: (imgArr[indexPath.row] as? String)!), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
        return cell1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7{
            return 60
        }else{
            return 40
        }
    }
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowingViewController") as! FollowingViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 4 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 5 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Options2ViewController") as! Options2ViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 6 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 7 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RankingViewController") as! RankingViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 8 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 9  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    }*/
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        _=self.navigationController?.popViewController(animated: true)
    }
    func iconGuide(){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"icon_guide"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "hints_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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
            
            let imgArr1 = (((json["result"]["icon_details"]).arrayValue).map({$0["icons"].stringValue}))
            let option = (((json["result"]["icon_details"]).arrayValue).map({$0["detail"].stringValue}))
            
            self.imgArr = imgArr1 as NSArray
            self.OptionArr = option as NSArray
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            DispatchQueue.main.async {
                self.tableview1.reloadData()
                
            }
            
        }
    }

}
