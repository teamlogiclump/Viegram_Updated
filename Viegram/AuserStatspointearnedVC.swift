//
//  AuserStatspointearnedVC.swift
//  Viegram
//
//  Created by Relinns on 31/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import MBProgressHUD

class AuserStatspointearnedVC: UIViewController {
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var privateuser: UIView!
    var userid = String()
    var privateuser1 = String()
    var followerstatus = String()
    var username = ""
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        
        if self.username.isEmpty == false{
            self.navbar.topItem?.title = self.username + "'s Stats"
        }
        super.viewDidLoad()
        self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
        self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        self.navbar.layer.masksToBounds = false
        self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navbar.layer.shadowOpacity = 0.3
        self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        
        self.navbar.layer.shadowRadius = 2.5
        
        
        
        if followerstatus == "0"{
            if privateuser1 == "0" {
                self.privateuser.isHidden = true
                fetchscore(guest_id: userid)
            }else{
                self.privateuser.isHidden = false
            }
            
            
        }else {
            self.privateuser.isHidden = true
            fetchscore(guest_id: userid)
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    @IBAction func viewstats(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnotherUserStatsVC") as! AnotherUserStatsVC
        vc.userid1 = userid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    var viewvalue:Int = 0
    
    @IBAction func view(_ sender: UIButton) {
        viewvalue = 0
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnotherUserStatsVC") as! AnotherUserStatsVC
        vc.lablename = viewvalue
        vc.userid1 = userid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    @IBAction func weekview(_ sender: UIButton) {
        viewvalue = 1
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnotherUserStatsVC") as! AnotherUserStatsVC
        vc.lablename = viewvalue
        vc.userid1 = userid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    @IBAction func yearview(_ sender: UIButton) {
        viewvalue = 3
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnotherUserStatsVC") as! AnotherUserStatsVC
        vc.lablename = viewvalue
        vc.userid1 = userid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    @IBAction func monthview(_ sender: UIButton) {
        viewvalue = 2
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnotherUserStatsVC") as! AnotherUserStatsVC
        vc.lablename = viewvalue
        vc.userid1 = userid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    @IBAction func overall(_ sender: UIButton) {
        viewvalue = 4
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnotherUserStatsVC") as! AnotherUserStatsVC
        vc.lablename = viewvalue
        vc.userid1 = userid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: - Navigation
    
    func fetchscore(guest_id:String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"get_stats","userid": guest_id ]
        
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
                
                [MBProgressHUD .hide(for: self.view, animated: true)]
                
                
                
                return
            }
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated: true)]
            print("success")
            let abc = (json["result"]["total_overall_points"] .stringValue)
            let overall = Int(abc)
            print(overall!)
            DispatchQueue.main.async {
                
                self._todaylbl.text = (json["result"]["total_today_points"] .stringValue)
                self._thisweek.text = (json["result"]["total_week_points"] .stringValue)
                self.thismnth.text = (json["result"]["total_month_points"] .stringValue)
                self._thisyear.text = (json["result"]["total_year_points"] .stringValue)
                self._overall.text = String(describing: overall!)
            }
        }
    }
    
    
    
    
    
    
    @IBOutlet weak var _todaylbl: UILabel!
    @IBOutlet weak var _thisweek: UILabel!
    @IBOutlet weak var thismnth: UILabel!
    @IBOutlet weak var _thisyear: UILabel!
    @IBOutlet weak var _overall: UILabel!
    
}
