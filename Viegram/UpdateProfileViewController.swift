    //
    //  UpdateProfileViewController.swift
    //  Viegram
    //
    //  Created by Relinns on 26/05/17.
    //  Copyright © 2017 Relinns. All rights reserved.
    //
    
    import UIKit
    import Alamofire
    import SwiftyJSON
    import Lottie
    import SDWebImage
    import MBProgressHUD
    
    
protocol UpdateProfileViewControllerDelegate : class
    {
        
        func backupdate()
        
    }
    class UpdateProfileViewController: UIViewController , UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate ,UINavigationControllerDelegate{
        
        weak var delegatee : UpdateProfileViewControllerDelegate?
        @IBOutlet weak var imginfo: UIImageView!
        @IBOutlet weak var Imgbackground: UIImageView!
        @IBOutlet weak var imgprofile: UIImageView!
        @IBOutlet weak var namelbl: UILabel!
        @IBOutlet weak var textfiledname: UITextField!
        @IBOutlet weak var Profilename: UITextField!
        @IBOutlet weak var profilestatus1: UILabel!
        @IBOutlet weak var profilestatus2: UILabel!
        @IBOutlet weak var linktf: UITextField!
        @IBOutlet weak var aboutme: UITextView!
        
        @IBOutlet weak var view1: UIView!
        @IBOutlet weak var view2: UIView!
        @IBOutlet weak var view3: UIView!
        @IBOutlet weak var view4: UIView!
        
        
        var profile1 = UIImage()
        var cover1 = UIImage()
        let picker = UIImagePickerController()
        var  photopicker = Bool()

        @IBAction func coverbtn(_ sender: UIButton)
        {
            photopicker = true
            imagepicker(sender: sender)
        }
    
        @IBAction func coverphoto(_ sender: UIButton) {
            photopicker = false
            imagepicker(sender: sender)
        }
        
        
        var circularview:CircularMenu?
        //MARK: ViewDidLoad
        override func viewDidLoad()
        {
            super.viewDidLoad()
            circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
            self.view.addSubview(circularview!)
            
            fetchDataapi()
            self.imginfo.image = #imageLiteral(resourceName: "imgProfileInfo").withRenderingMode(.alwaysTemplate)
            self.imginfo.tintColor = UIColor.white
            // Do any additional setup after loading the view.
            
            DispatchQueue.main.async {
                if (standard.value(forKey: "full_name") != nil){
                    self.namelbl.text = standard.value(forKey: "full_name") as? String
                    self.textfiledname.text = standard.value(forKey: "full_name") as? String
                }
                if (standard.value(forKey: "link") != nil){
                    self.linktf.text = standard.value(forKey: "link") as? String
                }
                if (standard.value(forKey: "bio_data") != nil){
                    self.aboutme.text = standard.value(forKey: "bio_data") as? String
                }
                if (standard.value(forKey: "display_name") != nil){
                    self.Profilename.text = standard.value(forKey: "display_name") as? String
                }
                
                if standard.value(forKey: "profile_image") != nil {
                    self.imgprofile.sd_setImage(with: URL(string: standard.value(forKey: "profile_image") as! String) as URL!, placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
                }
                if standard.value(forKey: "cover_image") != nil {
                    let urlStr =  standard.value(forKey: "cover_image") as! String
                    self.Imgbackground.sd_setImage(with: URL(string: urlStr ) as URL!, placeholderImage: #imageLiteral(resourceName: "imgProfileback"), options: SDWebImageOptions.refreshCached)
                }
                
                animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
                
            }
        }
        
        
        
        
        
        func setGradientBackground(aview:UIView,frame:CGRect) {
            DispatchQueue.main.async {
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
                gradientLayer.frame = frame
                aview.layer.insertSublayer(gradientLayer, at: 0)
            }
        }
        
        
        
        override func viewDidAppear(_ animated: Bool) {
            addshodow(view: self.view1)
            addshodow(view: self.view2)
            addshodow(view: self.view3)
            addshodow(view: self.aboutme)
        }
        
        
        
        //MARK: imagepicker
        func imagepicker(sender:UIButton){
            let alertcontroller = UIAlertController.init(title: NSLocalizedString("Choose Option", comment: "Choose Option") , message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: "Choose From Gallery"), style: .default)
            { action in
                self.picker.allowsEditing = true
                self.picker.sourceType = .photoLibrary
                
                self.picker.delegate = self
                DispatchQueue.main.async
                    {
                        self.present(self.picker, animated: true, completion: nil)
                        
                }
                
            }
            alertcontroller.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: NSLocalizedString("Take Picture From Camera", comment: "Take Picture From Camera") , style: .default)
            {
                action in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                    
                    //let imagePicker = UIImagePickerController()
                    self.picker.delegate = self
                    self.picker.sourceType = UIImagePickerControllerSourceType.camera;
                    self.picker.allowsEditing = true
                    DispatchQueue.main.async
                        {
                            self.present(self.picker, animated: true, completion: nil)
                            //self.navigationController?.pushViewController(self.picker, animated: true)
                    }
                }
            }
            alertcontroller.addAction(OKAction)
            let removeAction = UIAlertAction(title: NSLocalizedString("Remove image!", comment: "Remove image!") , style: .default) { action in
                
                DispatchQueue.main.async{
                    if self.photopicker == true {
                        self.Imgbackground.image = #imageLiteral(resourceName: "imgProfileback")
                    }else{
                        self.imgprofile.image = #imageLiteral(resourceName: "profileplaceholder")
                    }
                }
                
            }
            alertcontroller.addAction(removeAction)
            
            alertcontroller.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil))
            
            
            if let popoverController = alertcontroller.popoverPresentationController {
                popoverController.sourceView = sender as UIView
                popoverController.sourceRect = sender.bounds
            }
            
            
            self.present(alertcontroller, animated: true, completion: nil)
            
            
            
            
        }
        
        
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                if photopicker == true {
                    
                    self.Imgbackground.image = image
                    
                }else{
                    self.imgprofile.image = image
                    
                }
            } else{
                print("Something went wrong")
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
        var beizer = UIBezierPath()
        override func viewDidLayoutSubviews() {
            beizer.move(to: CGPoint(x:0,y: 0))
            beizer.addLine(to: CGPoint(x:0,y: self.Imgbackground.frame.maxY))
            beizer.addLine(to: CGPoint(x:self.Imgbackground.frame.maxX,y: self.Imgbackground.frame.size.height*0.8))
            beizer.addLine(to: CGPoint(x:self.Imgbackground.frame.maxX,y: 0))
            beizer.addLine(to: CGPoint(x:0,y: 0))
            beizer.close()
            let maskForYourPath = CAShapeLayer()
            maskForYourPath.path = beizer.cgPath
            self.Imgbackground.layer.mask = maskForYourPath
            self.Imgbackground.layer.rasterizationScale = UIScreen.main.scale;
            self.Imgbackground.layer.shouldRasterize = true;
        }
        
        
        
        
        @IBAction func backbtn(_ sender: UIButton)
        
        {
            //_=self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)

           // self.delegatee?.backupdate()
            
        }
        

        @IBAction func save1(_ sender: UIButton) {
            UpdateMulipartApi()
            
        }
        
        // MARK: - Api call
        
        
        func fetchDataapi(){
//            self.view.addSubview(animationView)
//            animationView.play()
//            animationView.loopAnimation = true
            
           // [MBProgressHUD .showAdded(to: self.view, animated: true)]
            
            
            let userId = standard.value(forKey: "user_id") as? String ?? ""
            let parameter: Parameters = ["action":"fetch_profile", "user_id":userId]
            
            print(parameter)
            
            Alamofire.request(mainurl + "upload_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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
                    //animationView.removeFromSuperview()
                    [MBProgressHUD .hide(for: self.view, animated: true)]
                    
                    return
                }
               // animationView.pause()
                //animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated: true)]

                print("success")
                
                //standard.set(json["result"]["details"]["user_id"].stringValue, forKey: "user_id")
                standard.set(json["result"]["details"]["country"].stringValue, forKey: "country")
                standard.set(json["result"]["details"]["bio_data"].stringValue, forKey: "bio_data")
                standard.set(json["result"]["details"]["full_name"].stringValue, forKey: "full_name")
                standard.set(json["result"]["details"]["display_name"].stringValue, forKey: "display_name")
                
                standard.set(json["result"]["details"]["profile_image"].stringValue, forKey: "profile_image")
                standard.set(json["result"]["details"]["cover_image"].stringValue, forKey: "cover_image")
                standard.set(json["result"]["details"]["bio_data"].stringValue, forKey: "bio_data")
                standard.set(json["result"]["details"]["link"].stringValue, forKey: "link")
                
                print(standard.value(forKey: "user_id")!)
                
                
            }
        }
        
        func UpdateMulipartApi(){
            let parameter: Parameters = ["action":"edit_profile", "userid":"\(standard.value(forKey: "user_id")!)" ,"full_name":"\(textfiledname.text!)","bio_data":"\(aboutme.text!)","link":"\(linktf.text!)","display_name":"\(Profilename.text!)"]
//            self.view.addSubview(animationView)
//            animationView.play()
//            animationView.loopAnimation = true
            
            [MBProgressHUD .showAdded(to: self.view, animated: true)]
           print(parameter)
            
            Alamofire.upload(multipartFormData: {
                (multipartFormData) in
                
                multipartFormData.append(UIImageJPEGRepresentation(self.imgprofile.image!, 0.3)!, withName: "filename", fileName: "swift_file.jpeg", mimeType: "image/jpg")
                multipartFormData.append(UIImageJPEGRepresentation(self.Imgbackground.image!, 0.3)!, withName: "cover_image", fileName: "swift_file.jpeg", mimeType: "image/jpg")
                
                for (key, value ) in parameter {
                    multipartFormData.append(((value) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    
                }
            }, to: mainurl + "upload_object.php")
                
            {  (result) in
                switch result {
                case .success(let upload, _,_ ):
                    
                    upload.uploadProgress(closure: { (progress) in
                        UILabel().text = "\((progress.fractionCompleted * 100)) %"
                        print (progress.fractionCompleted * 100)
                    })
                    
                    
                    upload.responseJSON { response in
                        
                        guard ((response.result.value) != nil) else{
                            
                            print(response.result.error!.localizedDescription)
                            //animationView.pause()
                            //animationView.removeFromSuperview()
                            
                            [MBProgressHUD .hide(for: self.view, animated: true)]
                            return
                        }
                        var json = JSON(response.result.value!)
                        print(json)
                        guard (json["result"]["msg"] .intValue) == 201  else {
                            if json["result"]["reason"].stringValue == "display name already exist" {
                              self.showalertview(messagestring: "This Display name is already in use.")
                            }else{
                             self.showalertview(messagestring: json["result"]["reason"].stringValue)
                            }
                            print("failure")
//                            animationView.pause()
//                            animationView.removeFromSuperview()
                            [MBProgressHUD .hide(for: self.view, animated: true)]
                          return
                        }
                        print("success")
                        standard.set(json["result"]["details"]["user_id"].stringValue, forKey: "user_id")
                        DispatchQueue.main.async {
//                            animationView.pause()
//                            animationView.removeFromSuperview()
                            
                            [MBProgressHUD .hide(for: self.view, animated: true)]
//
                            self.showalertview(messagestring: "Profile Updated Successfully", Buttonmessage: "OK", handler:
                                {
                                    self.delegatee?.backupdate()

                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                case .failure(let encodingError):
                    print (encodingError.localizedDescription)
                   // animationView.pause()
                   // animationView.removeFromSuperview()
                    
                    [MBProgressHUD .hide(for: self.view, animated: true)]
                }
                
            }
            
        }
        
    }
    
    
