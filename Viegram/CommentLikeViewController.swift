//
//  CommentLikeViewController.swift
//  Viegram
//
//  Created by Avatar Singh on 2017-07-20.
//  Copyright © 2017 Relinns. All rights reserved.
//
//
import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
class CommentLikeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationBar!
    
    var commentID = String()
    
    var ids = NSArray()
    var arrImages = NSArray()
    var displayName = NSArray()
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        addshodow(view: self.nav)
        self.nav.layer.masksToBounds = false
        self.nav.layer.shadowColor = UIColor.lightGray.cgColor
        self.nav.layer.shadowOpacity = 0.3
        self.nav.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.nav.layer.shadowRadius = 2.5
        
        
        DispatchQueue.main.async {
            self.nav.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            
            self.nav.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
            
           }
                self.apiCall()
        // Do any additional setup after loading the view.
   
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return  self.ids.count
        }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        let img =  cell2.viewWithTag(1) as! UIImageView
        let lbl = cell2.viewWithTag(2)  as! UILabel
        
        img.sd_setImage(with: URL(string: (arrImages[indexPath.row] as? String)!), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
        lbl.text = displayName[indexPath.row] as? String
     return cell2
    }

    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    func apiCall(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"comment_like_users","commentid": self.commentID ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            print(response.result.value!)
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
    
                
                animationView.removeFromSuperview()
                
                return
            }
            
            animationView.pause()
            animationView.removeFromSuperview()
           
            self.ids = (((json["result"]["like_comment"]).arrayValue).map({$0["id"].stringValue})) as NSArray
            
            self.arrImages =  (((json["result"]["like_comment"]).arrayValue).map({$0["profile_image"].stringValue})) as NSArray
            
            self.displayName =  (((json["result"]["like_comment"]).arrayValue).map({$0["display_name"].stringValue}))  as NSArray
            
            
            DispatchQueue.main.async {
                
             self.tableView.reloadData()
                
                
                
            }
        }
    }

    
    
    }
