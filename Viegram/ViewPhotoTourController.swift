//
//  ViewPhotoTourController.swift
//  Viegram
//
//  Created by Apple on 12/7/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import SKPhotoBrowser

class ViewPhotoTourController: UIViewController {
    var postDetails : [String:String?] = [:]
    var imageIds : String = ""
    var url : [String] = []
    var imageViews : [UIButton] = []
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_secondaryUsername: UILabel!
    @IBOutlet weak var lbl_pointonPost: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    let loading: LOTAnimationView? = LOTAnimationView.init(name: "material_wave_loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImageUrls(imageString: self.imageIds)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.setUpUI(dict: postDetails)
    }
    
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    func setUpUI(dict:[String:String?]){
        self.imgProfilePic.sd_setImage(with: URL.init(string: (dict["profileImage"] ?? "") ?? ""), placeholderImage: UIImage.init(named: "profileplaceholder"))
        self.lbl_username.text = (dict["username"] ?? "")
        self.lbl_secondaryUsername.text = (dict["username"] ?? "")
        self.lbl_pointonPost.text = (dict["points"] ?? "")
        self.lbl_time.text = (dict["time"] ?? "")
        
        loading?.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        loading?.center = self.view.center
        self.view.addSubview(loading!)
        loading?.play()
        loading?.loopAnimation = true
        setUpScrollView(imageIds: self.imageIds)
    }
    
    func setUpScrollView(imageIds: String) {
        let images = imageIds.components(separatedBy: ",")
        self.scrollView.isPagingEnabled = true
        for i in 0..<images.count{
            let width = self.scrollView.frame.size.width
            let height = self.scrollView.frame.size.height
            let Button = UIButton.init(frame: CGRect.init(x: CGFloat(i)*width, y: 0, width: width, height: height))
            Button.setImage(#imageLiteral(resourceName: "placeholder"), for: .normal)
            Button.tag = i
            Button.contentMode = .scaleAspectFill
            Button.imageView?.contentMode = .scaleAspectFill
            Button.clipsToBounds = true
            Button.addTarget(self, action: #selector(self.openPhotos(sender:)), for: .touchUpInside)
            self.scrollView.addSubview(Button)
            self.imageViews.append(Button)
        }
        scrollView.contentSize = CGSize.init(width: self.scrollView.frame.size.width*CGFloat(images.count), height: self.scrollView.frame.size.height)
    }
    
    func loadImages(url:[String]){
        DispatchQueue.main.async {
            for index in 0..<self.imageViews.count {
                
                self.imageViews[index].sd_setImage(with: URL.init(string: url[index]), for: .normal, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: SDWebImageOptions.progressiveDownload, completed: { (image, error, cache, url) in
                    if error == nil {
                        self.imageViews[index].setImage(image, for: .normal)
                    }
                    if self.loading != nil {
                        self.loading?.pause()
                        self.loading?.removeFromSuperview()
                    }
                })
                
                
            }
        }
    }
    
    func openPhotos(sender: UIButton) {
        print(sender.tag)
        // 1. create URL Array
        var images = [SKPhoto]()
        for url in self.url {
            let photo = SKPhoto.photoWithImageURL(url)
            photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
            images.append(photo)
        }
        
        
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(sender.tag)
        self.present(browser, animated: true, completion: {})
    
    
    
    }
    
    func getImageUrls(imageString: String) {
        let parameters : Parameters = [
            "action": "fetch_images",
            "image": imageString
        ]
        Api.requestPOST(mainurl + "phototour_object.php", params: parameters, headers: [:], success: { (resultJson, StatusHeader) in
            guard resultJson["result"]["msg"].stringValue == "201" else {
                print(resultJson["result"]["reason"].stringValue)
                return
            }
            print(resultJson["result"]["images"].arrayValue)
            self.url = resultJson["result"]["images"].arrayValue.map({$0["image_url"].stringValue})
            self.loadImages(url:self.url)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
