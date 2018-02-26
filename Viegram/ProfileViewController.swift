//
//  ProfileViewController.swift
//  Viegram
//
//  Created by Apple on 5/25/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import Lottie
import SKPhotoBrowser
import MBProgressHUD

class ProfileViewController: UIViewController {
    fileprivate let sectionInsets = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    @IBOutlet weak var lbl_info: UILabel!
    @IBOutlet weak var imgInfo: UIImageView!
    @IBOutlet weak var lbl_photos: UILabel!
    @IBOutlet weak var imgPhotos: UIImageView!
    @IBOutlet weak var scorelbl: UILabel!
    var beizer = UIBezierPath()
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var propicBackBg: UIView!
    var a = Int()
    @IBOutlet weak var imgPropic: UIImageView!
    @IBOutlet weak var profileBg: UIView!
    @IBOutlet weak var photosBg: UIView!
    @IBOutlet weak var lblusername: UILabel!
    var posts: [ProfilePostsModel] = []
    @IBOutlet weak var collectionView: UICollectionView!
    var apiInProgress = false
    var showlastItem = true
    @IBOutlet weak var lblStatusText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var circularview:CircularMenu?

    
    var score = 0
    {
        didSet {
            if score >= 1000000{
                self.lblStatusText.text = "Icon"
                self.lblStatusText.textColor = UIColor.init(netHex: 0x40866C)
                self.scorelbl.textColor = UIColor.init(netHex: 0x40866C)
            }else if score >= 100000 {
                self.lblStatusText.text = "Socialite"
                self.lblStatusText.textColor = UIColor.init(netHex: 0x325B61)
                self.scorelbl.textColor = UIColor.init(netHex: 0x325B61)
            }else if score >= 25000 {
                self.lblStatusText.text = "Bonafide"
                self.lblStatusText.textColor = apppurple
                self.scorelbl.textColor = apppurple
            }else{
                self.lblStatusText.text = "Neophyte"
                self.lblStatusText.textColor = orange
                self.scorelbl.textColor = orange
            }
        }
    }
    
    //Pagination
    var totalOffset = Int()
    var currentpage = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.apiInProgress == false
        {
            
            fetchDataapi(page: currentpage)
        }
        currentpage = 1
        
       // circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
       // self.view.addSubview(circularview!)
        self.emptyprofile.isHidden = true
        self.imgInfo.image = #imageLiteral(resourceName: "imgProfileInfo").withRenderingMode(.alwaysTemplate)
        self.imgInfo.tintColor = UIColor.white
        self.addshodow(view: self.profileBg, radius: 3, opacity: 0.3)
        self.addshodow(view: self.photosBg, radius: 3, opacity: 0.3)
        
        self.addshodow(view: self.propicBackBg, radius: 3, opacity: 0.3)
        self.profileBg.layer.shadowOpacity = 0.0
        
        // Do any additional setup after loading the view.
        
       // animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapFunction))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapFunction1))
        
        imgPropic.isUserInteractionEnabled = true
        imgPropic.tag = 1
        imgCover.tag = 1
        
        imgCover.isUserInteractionEnabled = true
        imgPropic.addGestureRecognizer(tap)
        imgCover.addGestureRecognizer(tap1)
        setUpUserDetails()
//        if self.apiInProgress == false {
//            //fetchDataapi(page: currentpage)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
//        super.viewWillAppear(true)
//      if self.apiInProgress == false {
//
//        fetchDataapi(page: currentpage)
//        }
    }

    func setUpUserDetails() {
        DispatchQueue.main.async {
            
            if standard.value(forKey: "profile_image") != nil {
                self.imgPropic.sd_setImage(with: URL(string: standard.value(forKey: "profile_image") as! String) as URL!, placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            }
            if standard.value(forKey: "cover_image") != nil {
                let urlStr =  standard.value(forKey: "cover_image") as! String
                self.imgCover.sd_setImage(with: URL(string: urlStr ) as URL!, placeholderImage: #imageLiteral(resourceName: "imgProfileback"), options: SDWebImageOptions.refreshCached)
            }
            self.lblusername.text = standard.value(forKey: "full_name") as? String
            self.namelbl.text = standard.value(forKey: "display_name") as? String
        }
    }
    /////Protocall calling
    
    func backCalling()
    {
        
    
    }
    
    func backupdate()
    {
        if self.apiInProgress == false
        {
            
            fetchDataapi(page: currentpage)
        }
    
    }
    
    //gesture
    
    func tapFunction(sender:UITapGestureRecognizer)
    {
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(standard.value(forKey: "profile_image") as! String)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
        
    }
    
                func tapFunction1(sender:UITapGestureRecognizer) {
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(standard.value(forKey: "cover_image") as! String)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
        
    }
    
    func setGradientBackground(aview:UIView,frame:CGRect) {
        DispatchQueue.main.async {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
            gradientLayer.frame = frame
            aview.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    
    @IBOutlet weak var emptyprofile: UIView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var linklbl: UILabel!
    @IBOutlet weak var aboutlbl: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {

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
        self.scrollView.scrollRectToVisible(CGRect(x:0,y:0,width:self.collectionView.frame.size.width,height:self.collectionView.frame.size.height), animated: true)
    }
    
    @IBAction func photosAction(_ sender: Any) {
        if self.profileBg.backgroundColor != UIColor.white{
            
            self.toogleState()
        }
        self.scrollView.scrollRectToVisible(CGRect(x:self.view.frame.width,y:0,width:self.collectionView.frame.size.width,height:self.collectionView.frame.size.height), animated: true)
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
    }
    
    @IBAction func backAction(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Changesettings") as! UpdateProfileViewController
        vc.profile1 = imgPropic.image!
        vc.cover1 = imgCover.image!
        vc.delegatee = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addshodow(view:UIView,radius:CGFloat,opacity:Float){
        //code to add shadow to views
        view.layer.shadowColor = apppurple.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = radius
    }
    
    var user_id = String()
    var link1 = ""
    
    
    
    
    @IBAction func openlink(_ sender: UIButton) {
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

    func fetchDataapi(page:Int)
    {
        self.apiInProgress = true
       //self.view.addSubview(animationView)
       // animationView.play()
       // animationView.loopAnimation = true
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
       // hud.label.text = "Loading..."

        let parameter: Parameters = ["action":"fetch_profile", "user_id":"\(standard.value(forKey: "user_id")!)","page": page]
        
        print(parameter)
        
        Alamofire.request(mainurl + "upload_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            self.apiInProgress = false
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: "Error")
                print("failure")
                
               // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                [MBProgressHUD .hide(for: self.view, animated: true)]

               // animationView.pause()
                //animationView.removeFromSuperview()
                return
            }
            self.currentpage = self.currentpage + 1
            if ((json["result"]["details"]["posts"]).arrayValue).isEmpty {
                self.showlastItem = false
            }
            for post in ((json["result"]["details"]["posts"]).arrayValue){
                let post = ProfilePostsModel.init(json: post)
                self.posts.append(post)
            }
            
    
            let user_id1 = ((json["result"]["details"]["user_id"].stringValue))
            let link = ((json["result"]["details"]["link"].stringValue))
            let scorepoint = ((json["result"]["details"]["scorepoint"].stringValue))
            let bio_data = ((json["result"]["details"]["bio_data"].stringValue))
            
            standard.set(json["result"]["details"]["user_id"].stringValue, forKey: "user_id")
            standard.set(json["result"]["details"]["profile_image"].stringValue, forKey: "profile_image")
            standard.set(json["result"]["details"]["cover_image"].stringValue, forKey: "cover_image")
            standard.set(json["result"]["details"]["full_name"].stringValue, forKey: "full_name")
            standard.set(json["result"]["details"]["display_name"].stringValue, forKey: "display_name")
            standard.set(json["result"]["details"]["email"].stringValue, forKey: "email")
            
            if standard.value(forKey: "profile_image") as? String != (json["result"]["details"]["profile_image"].stringValue){
                standard.set((json["result"]["details"]["profile_image"].stringValue), forKey: "profile_image")
            }
            
            if standard.value(forKey: "cover_image") as? String != (json["result"]["details"]["cover_image"].stringValue){
                standard.set((json["result"]["details"]["cover_image"].stringValue), forKey: "cover_image")
            }
            
            self.totalOffset = ((json["result"]["details"]["total_posts"].intValue))

            self.user_id = user_id1 as String
            self.link1 = link as String
            
           // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            [MBProgressHUD .hide(for: self.view, animated: true)]



           // animationView.pause()
            //animationView.removeFromSuperview()
            self.score = (json["result"]["details"]["scorepoint"].intValue)
            self.setUpUserDetails()
            DispatchQueue.main.async {
      
                self.lbl_photos.text = "Photos(\(self.totalOffset))"
                if link.contains("https://") {
                    self.linklbl.text = link
                }else{
                    if link != "" {
                        self.linklbl.text = ("https://" + link)
                    }
                }
                self.aboutlbl.text = bio_data
                self.scorelbl.text  = scorepoint
                
                standard.setValue(link, forKey: "link")
                standard.setValue(bio_data,forKey: "bio_data")
                self.collectionView.reloadData()
            }
        }
    }
    
}
extension ProfileViewController :UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let value = self.posts.count == 0 ? false : true
        self.emptyprofile.isHidden = value
        let indicatorCount = self.showlastItem ? 1 : 0
        return self.posts.count + indicatorCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row != self.posts.count else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicatorCell", for: indexPath)
            let indicator = cell.viewWithTag(40) as! UIActivityIndicatorView
            indicator.startAnimating()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotosCollectionViewCell
        _=cell.postimage.subviews.map({ $0.removeFromSuperview() })
        cell.postimage.sd_setImage(with: URL(string: self.posts[indexPath.item].photo ?? ""), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
        if self.posts[indexPath.item].type  == "video" {
            let imageview = UIImageView()
            imageview.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            imageview.image = UIImage(named: "play2.png")
            cell.postimage.addSubview(imageview)
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
        
        let post_id = (self.posts[indexPath.item].postId ?? "")
        let user_id11 = (self.user_id )
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
        vc.userid = user_id11
        vc.postid = post_id
        vc.deletephoto = false
        vc.indexofPost = indexPath.item
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item  == self.posts.count  && self.apiInProgress == false && self.showlastItem {
            fetchDataapi(page: currentpage)
            [MBProgressHUD .hide(for: self.view, animated: true)]
        }
    }
    
}
extension ProfileViewController: OpenPhotoViewControllerDelegate,UpdateProfileViewControllerDelegate{
    func postDeleted(from position: Int) {
        self.posts.remove(at: position)
        self.collectionView.reloadData()
    }
}
