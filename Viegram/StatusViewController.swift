//
//  StatusViewController.swift
//  Viegram
//
//  Created by Relinns on 26/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import MBProgressHUD

class StatusViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var mystatusbtn: UIButton!
    @IBOutlet weak var statuscore: UIButton!
    @IBOutlet weak var earningScore: UIButton!
    
    @IBOutlet weak var _todaylbl: UILabel!
    @IBOutlet weak var _thisweek: UILabel!
    @IBOutlet weak var thismnth: UILabel!
    @IBOutlet weak var _thisyear: UILabel!
    @IBOutlet weak var _overall: UILabel!
    
    
    @IBOutlet weak var navbar: UINavigationBar!
    var earned_point = NSArray()
    var amount = NSArray()

    
    @IBAction func myststus(_ sender: UIButton) {
    
         self.scrollview.scrollRectToVisible(CGRect(x:0,y:0,width:self.view1.frame.size.width,height:self.view1.frame.size.height), animated: true)
        DispatchQueue.main.async {
            self.navbar.topItem?.title = "My Stats"
            self.mystatusbtn.setTitleColor(.white, for: .normal)
            self.mystatusbtn.backgroundColor = apppurple
            
            self.statuscore.setTitleColor(apppurple, for: .normal)
            self.statuscore.backgroundColor = UIColor.white
            self.earningScore.setTitleColor(apppurple, for: .normal)
            self.earningScore.backgroundColor = UIColor.white
            //self.addshodow(view: self.mystatusbtn)
            self.addshodow(view: self.statuscore)
            self.addshodow(view: self.earningScore)
        }
        
    }
    @IBAction func statuscore(_ sender: UIButton) {
        self.scrollview.scrollRectToVisible(CGRect(x:self.view.frame.size.width,y:0,width:self.view1.frame.size.width,height:self.view1.frame.size.height), animated: true)
          DispatchQueue.main.async {
            self.navbar.topItem?.title = "Status Scores"
         self.mystatusbtn.setTitleColor(apppurple, for: .normal)
         self.mystatusbtn.backgroundColor = UIColor.white
        self.statuscore.setTitleColor(.white, for: .normal)
        self.statuscore.backgroundColor = apppurple
        self.earningScore.setTitleColor(apppurple, for: .normal)
        self.earningScore.backgroundColor = UIColor.white
            self.addshodow(view: self.mystatusbtn)
            self.addshodow(view: self.statuscore)
            self.addshodow(view: self.earningScore)
        }
    }
   
    @IBAction func earningpoint(_ sender: UIButton) {
        self.scrollview.scrollRectToVisible(CGRect(x:view.frame.size.width * 2,y:0,width:self.view1.frame.size.width,height:self.view1.frame.size.height), animated: true)
          DispatchQueue.main.async {
              self.navbar.topItem?.title = "Earning Points"
         self.mystatusbtn.setTitleColor(apppurple, for: .normal)
         self.mystatusbtn.backgroundColor = UIColor.white
        self.statuscore.setTitleColor(apppurple, for: .normal)
        self.statuscore.backgroundColor = UIColor.white
        self.earningScore.setTitleColor(.white, for: .normal)
        self.earningScore.backgroundColor = apppurple
            self.addshodow(view: self.mystatusbtn)
            self.addshodow(view: self.statuscore)
            //self.addshodow(view: self.earningScore)
        }}
    
    @IBAction func Backbtn(_ sender: UIBarButtonItem) {
          _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var view1: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchscore()  

            self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            
            self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
            
            self.navbar.layer.masksToBounds = false
            self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
            self.navbar.layer.shadowOpacity = 0.3
            self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            self.navbar.layer.shadowRadius = 2.5

            // Do any additional setup after loading the view.
            self.statuscore.setTitleColor(apppurple, for: .normal)
            self.statuscore.backgroundColor = UIColor.white
            self.earningScore.setTitleColor(apppurple, for: .normal)
            self.earningScore.backgroundColor = UIColor.white
            self.addshodow1(view: self.mystatusbtn)
            self.addshodow1(view: self.statuscore)
            self.addshodow1(view: self.earningScore)

            animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)

            self.tableview.setNeedsLayout()
            self.tableview.layoutIfNeeded()
        
        self.tableview.rowHeight = UITableViewAutomaticDimension
        self.tableview.estimatedRowHeight = 40
        let view = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(view)
        
    }
    
    
    func setGradientBackground(view:UIView) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
        //gradientLayer.locations = [ 0.0,0.25,0.50, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earned_point.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! StatusviewTableViewCell
            cell1.earned_point.text = self.earned_point[indexPath.row] as? String
            cell1.amount.text = self.amount[indexPath.row] as? String
        cell1.lastlbl.text =  ""
        if indexPath.row == 10  {
            cell1.earned_point.text = "Your account being viewed by a user"
            cell1.lastlbl.text = "You will not be able to see who's viewed your account"
        }
        if  indexPath.row == 11 {
             cell1.earned_point.text = "Inviting a contact to join Viegram"
             cell1.lastlbl.text = "Use \"invite\" under \"options\""
        }
            return cell1
        
    }
    
    var viewvalue:Int = 0
    @IBAction func view(_ sender: UIButton) {
        viewvalue = 0
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyearnedpointViewController") as! MyearnedpointViewController
        
            vc.lablename = viewvalue
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func weekview(_ sender: UIButton) {
        viewvalue = 1
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyearnedpointViewController") as! MyearnedpointViewController
        
        vc.lablename = viewvalue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func monthview(_ sender: Any) {
        viewvalue = 2
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyearnedpointViewController") as! MyearnedpointViewController
        vc.lablename = viewvalue
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func yearview(_ sender: UIButton) {
        viewvalue = 3
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyearnedpointViewController") as! MyearnedpointViewController
        vc.lablename = viewvalue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func overall(_ sender: UIButton) {
        viewvalue = 4
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyearnedpointViewController") as! MyearnedpointViewController
        vc.lablename = viewvalue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var overallview: UIButton!
    func addshodow1(view:UIView){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.3
        //view.layer.shadowPath = shadowPath.cgPath   
    }
    func fetchscore()
    {
    
//       self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"get_stats","userid":"\(standard.value(forKey: "user_id")!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "ranking_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
//                animationView.pause()
//                animationView.removeFromSuperview()
                
             [MBProgressHUD .hide(for: self.view, animated:true)]
                self.fetchscore()
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

                self.earningpoint()
                
                return
            }
//          animationView.pause()
//           animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]


            print("success")
            DispatchQueue.main.async {
                
                self._todaylbl.text = (json["result"]["total_today_points"] .stringValue)
                 self._thisweek.text = (json["result"]["total_week_points"] .stringValue)
                 self.thismnth.text = (json["result"]["total_month_points"] .stringValue)
                 self._thisyear.text = (json["result"]["total_year_points"] .stringValue)
                let abc = (json["result"]["total_overall_points"] .stringValue)
                let points1 = Int(abc)
                    self._overall.text = String(describing: points1!)
                self.earningpoint()
            }
        }
    }
    func earningpoint()
    {
       self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
        [MBProgressHUD .showAdded(to: self.view, animated: true)]

        
        let parameter: Parameters = ["action":"earning_hints"]
        
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
//               animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]


                
                
                return
            }
            
//            animationView.pause()
//            animationView.removeFromSuperview()
           [MBProgressHUD .hide(for: self.view, animated:true)]

           
            print("success")
            DispatchQueue.main.async {
                let earning_hints1 = (((json["result"]["hints"]).arrayValue).map({$0["earning_hints"].stringValue}))
             let amount1 = (((json["result"]["hints"]).arrayValue).map({$0["amount"].stringValue}))
                self.earned_point = earning_hints1 as NSArray
                self.amount = amount1 as NSArray
                self.tableview.reloadData()
                
            }
        }
    }

    @IBOutlet weak var tableview: UITableView!

}
