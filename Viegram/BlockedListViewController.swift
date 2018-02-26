//
//  BlockedListViewController.swift
//  Viegram
//
//  Created by Apple on 11/18/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Alamofire
import SwiftyJSON
import SDWebImage
class BlockedListViewController: UIViewController {
    var errString = "Loading"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationBar!
    var circularview:CircularMenu?
     var listBlockUser = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        setUpUI()
        blockedUserApi()
        // Do any additional setup after loading the view.
    }
    func setUpUI() {
        self.nav.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
        self.nav.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        self.view.addSubview(circularview!)
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func blockedUserApi(){
        let params :Parameters = ["action": "block_list","block_by":(standard.value(forKey: "user_id") as? String) ?? ""]
        animationView.play()
        animationView.loopAnimation = true
        Api.requestPOST(mainurl + "content_object.php", params: params, headers: [:], success: { (json, statuscode) in
            guard json["response"]["msg"].stringValue == "201" else{
                DispatchQueue.main.async {
                    self.errString = json["response"]["reason"].stringValue
                    animationView.pause()
                    animationView.removeFromSuperview()
                    self.tableView.reloadData()
                }
                
               
                
                return
            }
            
            
            print(json)
            self.listBlockUser.removeAll()
            self.listBlockUser = json["response"]["block_list"].arrayValue
            DispatchQueue.main.async {
                animationView.pause()
                animationView.removeFromSuperview()
                self.tableView.reloadData()
            }
            //            self.removeIndexArr(index: index.row)
        }) { (error) in
            self.showalertview(messagestring: error.localizedDescription)
        }
    }
}
extension BlockedListViewController:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBlockUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FolllowpeopleTableViewCell
        cell.name1.text = self.listBlockUser[indexPath.row]["display_name"].stringValue
        cell.imgBlockUser.sd_setImage(with: URL(string: self.listBlockUser[indexPath.row]["profile_image"].stringValue), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
        cell.btnBlock.tag =  indexPath.row
        cell.btnBlock.addTarget(self, action: #selector(self.unBlockUser(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func unBlockUser(sender:UIButton){
        
      let userId =   self.listBlockUser[sender.tag]["user_id"].stringValue
        
        let params :Parameters = ["action": "block_user", "block_user": userId,"block_by":(standard.value(forKey: "user_id") as? String) ?? ""]
        animationView.play()
        animationView.loopAnimation = true
        Api.requestPOST(mainurl + "content_object.php", params: params, headers: [:], success: { (json, statuscode) in
            guard json["response"]["msg"].stringValue == "201" else{
                DispatchQueue.main.async {
                    animationView.pause()
                    animationView.removeFromSuperview()
                }
                
                self.showalertview(messagestring: json["response"]["reason"].stringValue)
                
                
                
                return
            }
            DispatchQueue.main.async {
                  self.showalertview(messagestring: json["response"]["reason"].stringValue)
                self.listBlockUser.remove(at: sender.tag)
                self.tableView.reloadData()
                animationView.pause()
                animationView.removeFromSuperview()
                self.blockedUserApi()
                
            }
            //            self.removeIndexArr(index: index.row)
        }) { (error) in
            animationView.pause()
            animationView.removeFromSuperview()
            self.showalertview(messagestring: error.localizedDescription)
        }
        
    }
   
    
    
    
}
extension BlockedListViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "emptyhome")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = self.errString=="Loading" ? "" : "It's empty here!"
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 16.0)!,NSForegroundColorAttributeName:apppurple]
        return NSAttributedString.init(string: str, attributes: attributes )
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let parastyle = NSMutableParagraphStyle()
        parastyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        parastyle.alignment = NSTextAlignment.center
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 14.0)!,NSForegroundColorAttributeName:UIColor.darkGray,NSParagraphStyleAttributeName:parastyle]
        return NSAttributedString.init(string: self.errString, attributes: attributes )
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let str = self.errString=="Loading" ? "" : "Retry"
        let parastyle = NSMutableParagraphStyle()
        parastyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        parastyle.alignment = NSTextAlignment.center
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 18.0)!,NSForegroundColorAttributeName:UIColor.darkGray,NSParagraphStyleAttributeName:parastyle]
        return NSAttributedString.init(string: str, attributes: attributes )
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.blockedUserApi()
        self.errString="Loading"
        self.tableView.reloadData()
    }
}
