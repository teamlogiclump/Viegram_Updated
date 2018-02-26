//
//  AuserProfileViewController.swift
//  Viegram
//
//  Created by Relinns on 31/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

//update id

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import Lottie
import SKPhotoBrowser
import DZNEmptyDataSet
import MBProgressHUD

class AuserProfileViewController: UIViewController  {
    fileprivate let sectionInsets = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    var blockView: flagPost?
    @IBOutlet weak var followingbtn: UIButton!
    @IBOutlet weak var lbl_info: UILabel!
    @IBOutlet weak var imgInfo: UIImageView!
    @IBOutlet weak var lbl_photos: UILabel!
    @IBOutlet weak var imgPhotos: UIImageView!
    var beizer = UIBezierPath()
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var propicBackBg: UIView!
    
    @IBOutlet weak var imgPropic: UIImageView!
    @IBOutlet weak var profileBg: UIView!
    @IBOutlet weak var photosBg: UIView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var displayname: UILabel!
    @IBOutlet weak var scoretypelbl: UILabel!
    @IBOutlet weak var scores: UILabel!
    @IBOutlet weak var linklbl: UILabel!
    @IBOutlet weak var aboutmelbl: UILabel!
    
    @IBOutlet weak var statsbtn: UIButton!
    @IBOutlet weak var folloebtn: UIButton!
    var isblock = false
    var followStatus = ""
    var score = 0 {
        didSet {
            if score >= 1000000{
                self.scoretypelbl.text = "Icon"
                self.scoretypelbl.textColor = UIColor.init(netHex: 0x40866C)
                self.scores.textColor = UIColor.init(netHex: 0x40866C)
            }else if score >= 100000 {
                self.scoretypelbl.text = "Socialite"
                self.scoretypelbl.textColor = UIColor.init(netHex: 0x325B61)
                self.scores.textColor = UIColor.init(netHex: 0x325B61)
            }else if score >= 25000 {
                self.scoretypelbl.text = "Bonafide"
                self.scoretypelbl.textColor = apppurple
                self.scores.textColor = apppurple
            }else{
                self.scoretypelbl.text = "Neophyte"
                self.scoretypelbl.textColor = orange
                self.scores.textColor = orange
            }
        }
    }
    var followStatusUpdate = "" {
        didSet{
            if followStatusUpdate == "0"{
                self.followingbtn.setTitle("Follow", for: .normal)
                if self.privacy_status == "1" {
                    self.statsbtn.isHidden = true
                    self.folloebtn.isHidden = true
                    self.privateviewphoto.isHidden = false
                    self.collectionView.isHidden = true
                }else{
                    self.statsbtn.isHidden = false
                    self.folloebtn.isHidden = false
                    self.privateviewphoto.isHidden = true
                    self.collectionView.isHidden = false
                }
                self.followingbtn.layer.borderColor = UIColor.lightGray.cgColor
                self.followingbtn.layer.borderWidth = 0.5
                self.followingbtn.setTitleColor(apppurple, for: .normal)
                self.followingbtn.backgroundColor = UIColor.white
            }else if followStatusUpdate == "1"{
                self.followingbtn.setTitle("Following", for: .normal)
                self.statsbtn.isHidden = false
                self.folloebtn.isHidden = false
                self.privateviewphoto.isHidden = true
                self.collectionView.isHidden = false
                self.followingbtn.setTitleColor(UIColor.white, for: .normal)
                self.followingbtn.backgroundColor = apppurple
                self.followingbtn.layer.borderWidth = 0.0
            }else{
               self.followingbtn.setTitle("Requested", for: .normal)
                self.statsbtn.isHidden = true
                self.folloebtn.isHidden = true
                self.privateview.isHidden = false
                self.collectionView.isHidden = true
                self.followingbtn.setTitleColor(UIColor.white, for: .normal)
                self.followingbtn.backgroundColor = apppurple
                self.followingbtn.layer.borderWidth = 0.0
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Pagination
    var totalOffset = Int()
    var currentpage = Int()

    var scorepoint = String()
    var link = String()
    var privacy_status = "1"
    var profile_image = String()
    var bio_data = String()
    var cover_image = String()
    //var follower_status = String()
    var fullname = String()
    var displayname1 = String()
    var postimageArr = NSArray()
    var postId = NSArray()
    var guest_id = String()
    var type1 = NSArray()
    

    override func viewDidLoad() {
        print(guest_id)
        super.viewDidLoad()
        
        currentpage = 1
        Anotheruserprofile(userid2: guest_id, page: 1)
        collectionView.reloadData()
        // aanotheruserdata.delegate1 = self
        self.imgInfo.image = #imageLiteral(resourceName: "imgProfileInfo").withRenderingMode(.alwaysTemplate)
        self.imgInfo.tintColor = UIColor.white
        self.addshodow(view: self.profileBg, radius: 3, opacity: 0.3)
        self.addshodow(view: self.photosBg, radius: 3, opacity: 0.3)
        
        self.addshodow(view: self.propicBackBg, radius: 3, opacity: 0.3)
        self.profileBg.layer.shadowOpacity = 0.0
        let view = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(view)
        if profile_image != ""{
            self.imgPropic.sd_setImage(with: URL(string: profile_image), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
        }
        if cover_image != "" {
            self.imgCover.sd_setImage(with: URL(string: cover_image), placeholderImage: #imageLiteral(resourceName: "imgProfileback"), options: SDWebImageOptions.refreshCached)
            
        }
        
        self.namelbl.text = fullname
        self.aboutmelbl.text = bio_data
        self.scores.text = scorepoint
        if link.contains("https://") {
            self.linklbl.text = link
        }else{
            if link != "" {
                self.linklbl.text = "https://" + link
            }
        }

        self.displayname.text = displayname1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AuserProfileViewController.tapFunction))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(AuserProfileViewController.tapFunction1))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(AuserProfileViewController.tapFunction2))
        
        imgPropic.isUserInteractionEnabled = true
        imgPropic.tag = 1
        imgCover.tag = 1
        self.linklbl.isUserInteractionEnabled = true
        imgCover.isUserInteractionEnabled = true
        imgPropic.addGestureRecognizer(tap)
        imgCover.addGestureRecognizer(tap1)
        linklbl.addGestureRecognizer(tap2)
        self.followStatusUpdate = self.followStatus
    }
    
    
    
    //gesture
    
    func tapFunction(sender:UITapGestureRecognizer) {
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(profile_image)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
        
    }
    

    func tapFunction1(sender:UITapGestureRecognizer) {
        
        let point = sender.location(in: sender.view)
        guard self.beizer.contains(point) == true else {
            return
        }
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(cover_image)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
        
    }
    
    //linkopen
    func tapFunction2(sender:UITapGestureRecognizer) {
        let url = self.linklbl.text
        let url1 = URL(string: url!)!
        if  url != "" {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url1, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url1)
            }
        }
    }

    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            
            //self.imageArr.addObjects(from: self.postimageArr as! [Any])
            
           
        }
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

    func toogleState(){
        if self.profileBg.backgroundColor == UIColor.white{
            self.profileBg.backgroundColor = apppurple
            self.lbl_info.textColor = UIColor.white
            self.imgInfo.image = #imageLiteral(resourceName: "imgProfileInfo").withRenderingMode(.alwaysTemplate)
            self.imgInfo.tintColor = UIColor.white
            self.profileBg.layer.shadowOpacity = 0.0
            
            self.photosBg.backgroundColor = UIColor.white
            self.lbl_photos.textColor = apppurple
            self.imgPhotos.image = #imageLiteral(resourceName: "imgPhotos").withRenderingMode(.alwaysTemplate)
            self.imgPhotos.tintColor = apppurple
            self.photosBg.layer.shadowOpacity = 0.3
            
        }else{
            self.profileBg.backgroundColor = UIColor.white
            self.lbl_info.textColor = apppurple
            self.imgInfo.image = #imageLiteral(resourceName: "imgProfileInfo").withRenderingMode(.alwaysTemplate)
            self.imgInfo.tintColor = apppurple
            self.profileBg.layer.shadowOpacity = 0.3
            
            
            self.photosBg.backgroundColor = apppurple
            self.lbl_photos.textColor = UIColor.white
            self.imgPhotos.image = #imageLiteral(resourceName: "imgPhotos").withRenderingMode(.alwaysTemplate)
            self.imgPhotos.tintColor = UIColor.white
            self.photosBg.layer.shadowOpacity = 0.0
        }
    }

    @IBAction func infoAction(_ sender: Any) {
        if self.profileBg.backgroundColor == UIColor.white{
            self.toogleState()
        }
        
        DispatchQueue.main.async {
           
            
            if self.postimageArr.count == 0 {
                self.privateview.isHidden = false
                
                self.collectionView.isHidden = false
                
            }
        }
        
        self.scrollView.scrollRectToVisible(CGRect(x:0,y:0,width:self.collectionView.frame.size.width,height:self.collectionView.frame.size.height), animated: true)
        
    }

    @IBOutlet weak var privateviewphoto: UIView!

    @IBAction func photosAction(_ sender: Any) {
        if self.profileBg.backgroundColor != UIColor.white{
            self.toogleState()
        }
        DispatchQueue.main.async {

            
            if self.postimageArr.count == 0 {
                self.privateview.isHidden = false
                
                self.collectionView.isHidden = false
                
            }
            self.scrollView.scrollRectToVisible(CGRect(x:self.view.frame.width,y:0,width:self.collectionView.frame.size.width,height:self.collectionView.frame.size.height), animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        beizer.move(to: CGPoint(x:0,y: 0))
        beizer.addLine(to: CGPoint(x:0,y: self.imgCover.frame.maxY))
        beizer.addLine(to: CGPoint(x:self.imgCover.frame.maxX,y: self.imgCover.frame.size.height*0.8))
        beizer.addLine(to: CGPoint(x:self.imgCover.frame.maxX,y: 0))
        beizer.addLine(to: CGPoint(x:0,y: 0))
        beizer.close()
    
        let maskForYourPath = CAShapeLayer()
        maskForYourPath.path = beizer.cgPath
        self.imgCover.layer.mask = maskForYourPath
        self.imgCover.layer.rasterizationScale = UIScreen.main.scale;
        self.imgCover.layer.shouldRasterize = true;
        self.imgCover.layer.masksToBounds = true
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Changesettings") as! UpdateProfileViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func blockUser(_ sender: Any) {
        if self.isblock == true{
          self.blockView = flagPost.init(frame: self.view.bounds, postId: guest_id, index: IndexPath.init(row: 0, section: 0), messageTitle: "Do you want to unblock this user?", successTitle: "UNBLOCK", image: "imgBlock1")
        }
        else{
            self.blockView = flagPost.init(frame: self.view.bounds, postId: guest_id, index: IndexPath.init(row: 0, section: 0), messageTitle: "Do you want to block this user?", successTitle: "BLOCK", image: "imgBlock1")
        }
      
        self.blockView?.delegate = self
        self.view.addSubview(self.blockView!)
    }
    
    @IBAction func stats(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuserStatspointearnedVC") as! AuserStatspointearnedVC
        vc.userid = guest_id
        vc.privateuser1 = self.privacy_status
        vc.followerstatus = self.followStatusUpdate
        vc.username = self.displayname1
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func followers(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FollowingViewController") as! FollowingViewController
        vc._name = displayname1
        vc._profileimg = profile_image
        vc._coverimg = cover_image
        vc.userid = guest_id
        vc.privateuser1 = privacy_status
        vc.followerstatus = self.followStatusUpdate
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBOutlet weak var privateview: UIView!
    
    func addshodow(view:UIView,radius:CGFloat,opacity:Float){
        //code to add shadow to views
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = radius
    }
    
    
    // MARK: - Api

    func enterinviegramApi(){
        //self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"account_viewed","viewed_userid": "\(standard.value(forKey: "user_id")!)" , "guest_userid": "\(guest_id)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "hints_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                
                return
            }
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            print("success")
            
        }
    }

    @IBAction func foloowbtn(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Following" {
            self.unfollow(unfollow_id: guest_id)
        }else{
            self.sentrequest()
        }
    }
    func blockUserApi(userId: String){
        let params :Parameters = ["action": "block_user", "block_user": userId,"block_by":(standard.value(forKey: "user_id") as? String) ?? ""]
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        Api.requestPOST(mainurl + "content_object.php", params: params, headers: [:], success: { (json, statuscode) in
            guard json["response"]["msg"].stringValue == "201" else{
                DispatchQueue.main.async {
//                    animationView.pause()
                    //animationView.removeFromSuperview()
                    [MBProgressHUD .hide(for: self.view, animated: true)]
                }
                print(json)
                self.showalertview(messagestring: json["response"]["reason"].stringValue)
                
                
                
                return
            }
            self.isblock = !self.isblock
              self.showalertview(messagestring: json["response"]["reason"].stringValue)
            DispatchQueue.main.async {
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated: true)]

            }
//            self.removeIndexArr(index: index.row)
        }) { (error) in
            self.showalertview(messagestring: error.localizedDescription)
        }
    }
    func sentrequest(){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
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
                self.showalertview(messagestring: (json["result"]["reason"] .stringValue))
                // print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                
                return
            }
            
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            print("success")
            DispatchQueue.main.async {
                
                if self.followStatusUpdate == "0" {
                    
                    self.followStatusUpdate = self.privacy_status == "1" ? "2" : "1"
                    
                }else{
                    self.followStatusUpdate = "0"
                }

            }
        }
    }

    var postidArr = NSMutableArray()
    var imageArr = NSMutableArray()
    var filetype = NSMutableArray()
    
    var imagebool = true
    func Anotheruserprofile(userid2: String , page :Int){
        // imageArr = []
        
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"fetch_user_profile", "userid":"\(standard.value(forKey: "user_id")!)" , "page" : "\(page)", "userid2":"\(userid2)"]
        
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
               // animationView.removeFromSuperview()
                
                
                
                return
            }
            
            let user_id = ((json["result"]["details"]["user_id"].stringValue))
            let scorepoint = ((json["result"]["details"]["scorepoint"].stringValue))
            self.score = (json["result"]["details"]["scorepoint"].intValue)
            let link = ((json["result"]["details"]["link"].stringValue))
            let privacy_status = ((json["result"]["details"]["privacy_status"].stringValue))
            let profile_image1 = ((json["result"]["details"]["profile_image"].stringValue))
            let bio_data = ((json["result"]["details"]["bio_data"].stringValue))
            let cover_image1 = ((json["result"]["details"]["cover_image"].stringValue))
            let follower_status = ((json["result"]["details"]["follower_status"].stringValue))
            let full_name = ((json["result"]["details"]["full_name"].stringValue))
            let display_name = ((json["result"]["details"]["display_name"].stringValue))
            self.totalOffset = ((json["result"]["details"]["total_posts"].intValue))
            let post_id = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["post_id"].stringValue})))
            let photo = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["photo"].stringValue})))
             let type = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["type"].stringValue})))
            
            let status = ((json["result"]["details"]["posts"]).array)! as NSArray
            if status == [] {
                self.imagebool = false
                
            }else{
                self.imagebool = true
                self.currentpage = self.currentpage + 1
                self.postidArr.addObjects(from: post_id)
                self.imageArr.addObjects(from: photo)
                self.filetype.addObjects(from: type)
            }
            
            
            print("success")
            
            DispatchQueue.main.async {
                
                
                
                if profile_image1 != ""{
                    self.imgPropic.sd_setImage(with: URL(string: profile_image1), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
                }
                if cover_image1 != "" {
                    self.imgCover.sd_setImage(with: URL(string: cover_image1), placeholderImage: #imageLiteral(resourceName: "imgProfileback"), options: SDWebImageOptions.refreshCached)
                    
                }
                
                self.namelbl.text = full_name
                self.aboutmelbl.text = bio_data
                self.scores.text = scorepoint
                if link.contains("https://") {
                    self.linklbl.text = link
                }else{
                    if link != "" {
                        self.linklbl.text = ("https://" + link)
                    }
                }

                self.displayname.text = display_name
                self.lbl_photos.text = "Photos(\(self.totalOffset))"
                if follower_status == "0" {
                    self.followingbtn.setTitle("Follow", for: .normal)
                    if self.privacy_status == "1" {
                        self.statsbtn.isHidden = true
                        self.folloebtn.isHidden = true
                    }else{
                        self.statsbtn.isHidden = false
                        self.folloebtn.isHidden = false
                    }
                    
                }else if follower_status == "1"{
                    self.followingbtn.setTitle("Following", for: .normal)
                    self.statsbtn.isHidden = false
                    self.folloebtn.isHidden = false
                }else{
                    self.followingbtn.setTitle("Requested", for: .normal)
                    self.statsbtn.isHidden = true
                    self.folloebtn.isHidden = true
                }
                
                
                self.collectionView.reloadData()
                
               // animationView.pause()
                //animationView.removeFromSuperview()
            }
        }
        
    }

    func unfollow(unfollow_id:String){
        //self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"unfollow_user","userid": "\(standard.value(forKey: "user_id")!)" ,"following_userid": unfollow_id]
        
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
                
                return
            }
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            print("success")
            DispatchQueue.main.async {
                self.followStatusUpdate = "0"
            }
        }
    }
}
extension AuserProfileViewController :UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentpage == 1 {
            return postId.count
        }else{
            return imageArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AUserphotoCollectionViewCell
        
        _=cell.postimage.subviews.map({ $0.removeFromSuperview() })
        
        
        if currentpage == 1 {
            if type1[indexPath.item] as? String == "image" {
                 cell.postimage.sd_setImage(with: URL(string: (postimageArr[indexPath.item] as? String)!), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
            }else{
                let imageview = UIImageView()
                imageview.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                imageview.image = UIImage(named: "play2.png")
                cell.postimage.addSubview(imageview)
            }
           
        }else{
             if filetype[indexPath.item] as? String == "image" {
            cell.postimage.sd_setImage(with: URL(string: (imageArr[indexPath.item] as? String)!), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
             }else{
                let imageview = UIImageView()
                imageview.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                imageview.image = UIImage(named: "play2.png")
                cell.postimage.addSubview(imageview)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: collectionView.frame.size.width/4 - 1, height: collectionView.frame.size.width/4 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post_id = (self.postId[indexPath.row] as! String)
        
        print(post_id)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
        vc.userid = guest_id
        vc.postid = post_id
        vc.deletephoto = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentpage != 1 {
            if  imagebool == true {
                if totalOffset != self.postId.count && indexPath.item  == self.postId.count - 1{
                    if guest_id != "" {
                        
                        if guest_id == standard.value(forKey: "user_id") as? String{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                           self.Anotheruserprofile(userid2: guest_id, page: currentpage)
                            
                        }
                        
                    }
                    
                    
                }
            }
        }
        
    }
    
}
extension AuserProfileViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "emptyprofile")
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let str = "No photos added to account."
        
        let parastyle = NSMutableParagraphStyle()
        parastyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        parastyle.alignment = NSTextAlignment.center
        
        let attributes = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 14.0),NSForegroundColorAttributeName:UIColor.darkGray,NSParagraphStyleAttributeName:parastyle]
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
extension AuserProfileViewController: flagPostDelegate{
    func flagSuccessAction(view: flagPost, postId: String, index: IndexPath) {
        view.removeFromSuperview()
        print(postId,index)
       self.blockUserApi(userId: postId)
    }
}

