//
//  RepostViewController.swift
//  Viegram
//
//  Created by Apple on 9/1/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import MMPlayerView
import AVFoundation
import MBProgressHUD


protocol RepostviewcontrollerDelegate: class {
    
    func refreshtimeline()
}

class RepostViewController: UIViewController {
    var circularview:CircularMenu?
    
    weak var delegates: RepostviewcontrollerDelegate?
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 10)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravityResizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
    var data = [String:Any]()
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var txtViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgPostHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imgPost: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "imgMenuBar"), for: .default)
        self.addShadow(view: self.navigationBar, opacity: 0.3, radius: 2.5)
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    @IBAction func submit(_ sender: UIButton) {
        self.repostApi(postid: self.data["post_id"] as! String, postuserID: self.data["postUserId"] as! String)
        
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI(){
        
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        
        self.view.addSubview(circularview!)
        
        let width = self.data["imgWidth"]  as? Int
        let height = self.data["imgHeight"] as? Int
        if (width != nil) && height != nil && (width! != 0) && (height != 0) {
            let ratio : CGFloat  = (CGFloat(width!) / CGFloat(height!))
            
            let screenWidth = UIScreen.main.bounds.width
            
            let imageheight = ((screenWidth) / (ratio))
            
            if imageheight > UIScreen.main.bounds.height / 1.8{
                self.imgPostHeight.constant = UIScreen.main.bounds.height / 1.8
            }else{
                self.imgPostHeight.constant = imageheight
            }
            
        }
        if self.data["filetype"] as! String == "image"{
            self.imgPost.sd_setImage(with: URL.init(string: self.data["postimage"] as! String), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: SDWebImageOptions.retryFailed, completed: { (image, error, type, url) in
                if error == nil {
                    self.imgPost.image = image
                    self.imgPost.contentMode = .scaleAspectFit
                }
            })
        }else{
            let url = URL.init(string: self.data["video"] as! String)
            mmPlayerLayer.playView = self.imgPost
             self.mmPlayerLayer.thumbImageView.sd_setImage(with: URL.init(string: self.data["postimage"] as! String), placeholderImage: placeholder)
            self.mmPlayerLayer.thumbImageView.contentMode = .scaleAspectFit
            mmPlayerLayer.set(url: url, state: { (status) in
            })
            mmPlayerLayer.startLoading()
            mmPlayerLayer.autoPlay = false
        }
    }
    
    func addShadow(view:UIView,opacity:Float,radius:CGFloat){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = radius
    }
    
    
    //MARK: Apicalls
    
    func repostApi(postid: String ,postuserID : String  ){
        self.view.addSubview(animationView)
        let repostText = self.textView.textColor != UIColor.black ? "" : self.textView.text!
        
//
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"repost_post", "repost_userid":"\(standard.value(forKey: "user_id")!)", "postid":"\(postid)" , "post_userid" : "\(postuserID)","repost_text" : repostText]
        
        print(parameter)
        
        Alamofire.request(mainurl + "post_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                DispatchQueue.main.async {
//                    animationView.pause()
//                    animationView.removeFromSuperview()
                    
                    [MBProgressHUD .hide(for: self.view, animated:true)]
                }
                return
            }
            
            DispatchQueue.main.async
                {
                    self.delegates?.refreshtimeline()
                    self.navigationController?.popViewController(animated: true)
//                self.showalertview(messagestring: "Reposted on your Timeline")
//                self.showalertview(messagestring: "Reposted on your Timeline", Buttonmessage: "OK", handler: {
//                    self.delegates?.refreshtimeline()
//
//                    self.navigationController?.popViewController(animated: true)
               // })
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]
            }
            
            print("success")
        }
    }
}
extension RepostViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != UIColor.black{
            self.textView.text = ""
            self.textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true{
            self.textView.text = "Caption"
            self.textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let contentSize = self.textView.sizeThatFits(self.textView.bounds.size).height
        self.txtViewHeight.constant = contentSize
        self.view.layoutIfNeeded()
    }
}
