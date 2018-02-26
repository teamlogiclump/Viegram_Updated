//
//  MyearnedpointViewController.swift
//  Viegram
//
//  Created by Relinns on 29/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import MBProgressHUD

class MyearnedpointViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    @IBOutlet weak var navbar: UINavigationBar!

//    var earned_point1:NSArray = ["Sign up","Photos posted","Likes received on photos","Commnents received on photos","LIke Recived on comments made","REposted posts","Tag in photos","Mentioned in captions and comments","Followers received fromown country","Followers received from own country","Followers received from another country","Account view","Entering viegram first daily","Viegram invites sent"]
//    var amount1:NSArray = ["0","5,000","3,000","100","30","50","5","2","50","100","10","100","100","100"]
     var earned_point1 = NSArray()
    var lablename = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
        self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        self.navbar.layer.masksToBounds = false
        self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navbar.layer.shadowOpacity = 0.3
        self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navbar.layer.shadowRadius = 2.5

        // Do any additional setup after loading the view.
        if lablename == 0 {
            titlelbl.text = "Points Earned Today"
            self.breakdown = "today"
        }else if lablename == 1 {
         titlelbl.text = "Points Earned This Week"
         self.breakdown = "weekly"
        }
        
        else if lablename == 2 {
           titlelbl.text = "Points Earned This Month"
             self.breakdown = "monthly"
        }
        
        else if lablename == 3 {
            titlelbl.text = "Points Earned This Year"
             self.breakdown = "yearly"
        }
        
        else if lablename == 4 {
            titlelbl.text = "Points Earned Overall"
             self.breakdown = "overall"
 
        }
        
        let view = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(view)
        
        fetchscore()
        
        self.tableview1.rowHeight = UITableViewAutomaticDimension
        self.tableview1.estimatedRowHeight = 60
        
    }
    
    @IBOutlet weak var tableview1: UITableView!
    
    func setGradientBackground(view:UIView) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
        //gradientLayer.locations = [ 0.0,0.25,0.50, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    @IBOutlet weak var titlelbl: UILabel!
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
     self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PointArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyearnedpointTableViewCell
            cell1.namelbl.text = self.earned_point1[indexPath.row] as? String
            cell1.amountlbl.text = self.PointArr[indexPath.row] as? String
            
            return cell1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    var breakdown = ""
    var PointArr = NSArray()
    func fetchscore()
    {
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
       
        
        let parameter: Parameters = ["action":"breakdown_stats","userid":"\(standard.value(forKey: "user_id")!)","breakdown" : "\(breakdown)"]
        
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
                [MBProgressHUD .hide(for: self.view, animated: true)]

               
                
                return
            }
            DispatchQueue.main.async {
                let arrayNames = (((json["result"]["points"]) .arrayValue).map({$0["points"].stringValue}) )
                 let earning_hints = (((json["result"]["points"]) .arrayValue).map({$0["earning_hints"].stringValue}) )
                self.PointArr = arrayNames as NSArray
                self.earned_point1 = earning_hints as NSArray
                
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated: true)]


                
                self.tableview1.reloadData()
                
            }
                       print("success")
           
    }
    
}
}
