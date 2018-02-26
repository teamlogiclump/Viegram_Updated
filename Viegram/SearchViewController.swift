//
//  SearchViewController.swift
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
import DZNEmptyDataSet
import MBProgressHUD

class SearchViewController: UIViewController,UITextFieldDelegate ,UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var searchTf: UITextField!
    var circularview:CircularMenu?
    
    //Pagination
    var totalOffset = Int()
    var currentpage = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.isHidden = true
        self.tableview.tableFooterView = UIView()
        currentpage = 1
        fetchRandomApi(page: 1)
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(circularview!)
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        DispatchQueue.main.async {
            self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
            self.searchTf.layer.borderWidth = 0.5
            self.searchTf.layer.borderColor = apppurple.cgColor
            self.navbar.layer.masksToBounds = false
            self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
            self.navbar.layer.shadowOpacity = 0.3
            self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            self.navbar.layer.shadowRadius = 2.5
            self.setPaddingView(strImgname: "Search", txtField: self.searchTf)
        }
    }
    
    func setPaddingView(strImgname: String,txtField: UITextField){
        let imageView = UIImageView(image: UIImage(named: strImgname))
        imageView.frame = CGRect(x: -5, y: 0, width: 20 , height: 20)
        let paddingView: UIView = UIView.init(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        paddingView.addSubview(imageView)
        txtField.rightViewMode = .always
        txtField.rightView = paddingView
        searchTf.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func backbtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            self.collectionview.isHidden = false
            self.tableview.isHidden = true
        }else{
            self.saerchPeople()
        }
        
    }
    
    // MARK: - Api
    var profile_image1 = NSArray()
    var profile_name = NSArray()
    var serachuserid1 = NSArray()
    
    @IBOutlet weak var tableview: UITableView!
    
    func saerchPeople(){
        DispatchQueue.main.async {
            self.tableview.isHidden = false
        }
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"search_user","userid":"\(standard.value(forKey: "user_id")!)" , "search" : "\(searchTf.text!)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                print("failure")
                DispatchQueue.main.async {
//                    animationView.pause()
//                    animationView.removeFromSuperview()
                    
                    [MBProgressHUD .hide(for: self.view, animated:true)]
                    self.collectionview.isHidden = true
                }
                
                return
            }
            
            let  profilename1 = ((json["result"]["user_details"].arrayValue).map({$0["display_name"].stringValue}))
            let   profile_image = ((json["result"]["user_details"].arrayValue).map({$0["profile_image"].stringValue}))
            
            let  search_id = ((json["result"]["user_details"].arrayValue).map({$0["user_id"].stringValue}))
            
            self.profile_name = profilename1 as NSArray
            self.profile_image1 = profile_image as NSArray
            self.serachuserid1 = search_id as NSArray
//            animationView.pause()
//            animationView.removeFromSuperview()
            
            [MBProgressHUD .hide(for: self.view, animated:true)]
            print("success")
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.collectionview.isHidden = true
            }
        }
    }
    
    
    
    
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profile_image1.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchTableViewCell
        cell.namelbl.text = profile_name[indexPath.row] as? String
        cell.img.sd_setImage(with: URL(string: (profile_image1[indexPath.item] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let another_userid1 = (self.serachuserid1[indexPath.row] as! String)
        
        if another_userid1 != "" {
            
            if another_userid1 == standard.value(forKey: "user_id") as? String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                Anotheruserprofile(userid2: another_userid1)
                
            }
            
        }

    }
    
    

    func Anotheruserprofile(userid2: String){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
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
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]
                
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
            [MBProgressHUD .hide(for: self.view, animated:true)]
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
            vc.postId = post_id as NSArray
            vc.postimageArr = photo as NSArray
            vc.guest_id = user_id
            vc.type1 = type as NSArray
            vc.followStatus = follower_status
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    var type = NSMutableArray()
    var _imgArr1 = NSMutableArray()
    var postidphoto = NSMutableArray()
    var useridphoto = NSMutableArray()
    
    func fetchRandomApi(page:Int){
        self.view.addSubview(animationView)
//        animationView.pause()
//        animationView.loopAnimation = true
        [MBProgressHUD .hide(for: self.view, animated:true)]
        let parameter: Parameters = ["action":"random_posts","page":page,"userid":"\(standard.value(forKey: "user_id")!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]
                
                return
                
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
//                animationView.pause()
//                animationView.removeFromSuperview()
                
                [MBProgressHUD .hide(for: self.view, animated:true)]
                return
            }
            
            let photo = (((json["result"]["timeline_posts"]).arrayValue).map({$0["photo"].stringValue}))
            
            let post_id = (((json["result"]["timeline_posts"]).arrayValue).map({$0["post_id"].stringValue}))
            let user_id = (((json["result"]["timeline_posts"]).arrayValue).map({$0["userid"].stringValue}))
            let type1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["type"].stringValue}))
            self.totalOffset = (json["result"]["total_records"] .intValue)
            self._imgArr1.addObjects(from: photo)
            self.postidphoto.addObjects(from: post_id)
            self.useridphoto.addObjects(from: user_id)
            self.type.addObjects(from: type1)
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]
            print("success")
            DispatchQueue.main.async {
                self.collectionview.reloadData()
            }
        }
    }
}
extension SearchViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._imgArr1.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! SearchCollectionViewCell
        
        _=cell._img.subviews.map({ $0.removeFromSuperview() })
        
        cell._img.sd_setImage(with: URL(string: (_imgArr1[indexPath.row] as? String)!), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
        
        if type[indexPath.item] as? String == "image" {
            
        }else
        {
            let imageview = UIImageView()
            imageview.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            imageview.image = UIImage(named: "play2.png")
            cell._img.addSubview(imageview)
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/4, height: collectionView.frame.size.width/4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post_id = (self.postidphoto[indexPath.row] as! String)
        let user_id11 = (self.useridphoto[indexPath.row] as! String)
        print(post_id)
        print(user_id11)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
        vc.userid = user_id11
        vc.postid = post_id
        vc.deletephoto = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if totalOffset != self.postidphoto.count && indexPath.item  == self.postidphoto.count - 1
        {
            
            currentpage = currentpage + 1
            fetchRandomApi(page: currentpage)
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]
        }
    }
}
extension SearchViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "emptysearch")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No results found!"
        
        let attributes = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 16.0),NSForegroundColorAttributeName:apppurple]
        
        
        return NSAttributedString.init(string: str, attributes: attributes ?? [:])
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

