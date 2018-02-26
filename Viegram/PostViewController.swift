//
//  PostViewController.swift
//  Viegram
//
//  Created by Apple on 6/1/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import Lottie
import CoreImage
import AVKit
import  AVFoundation

var photoposted = true


class PostViewController: UIViewController,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate ,UINavigationControllerDelegate, UITextViewDelegate,locationfetch  , tagpeople {
    
    var circularview:CircularMenu?
    @IBOutlet weak var tagpeoplelbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!

    var indicatorView : UIView?
    weak var indicatorlbl: UILabel?
    let picker = UIImagePickerController()
    
    var  photopicker = Bool()
    
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imgpost: UIImageView!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    var restrict  = Bool()
    var location = ""
    
    
    func location(loc: String) {
        self.locationlbl.text = loc
        location = loc
        
    }
    var nameArr = [String]()
    var userid = [String]()
    var lblframedata = [[String:String]]()
    
    func tag(name: [String], user_id: [String]) {
        self.nameArr = name
        self.userid = user_id
        if name  != [] {
            let people = name.count
            
            self.tagpeoplelbl.text = "\(people)" + " People tagged"
        }else{
            self.tagpeoplelbl.text = "Tag people"
        }
        
    }
    var arrayY = [String]()
    var arrayx = [String]()
    
    
    func cgrectframe(framArr: [[String : String]]) {
        self.lblframedata = framArr
        //relativex
        
        arrayx.removeAll()
        arrayY.removeAll()
        for i in 0..<self.lblframedata.count{
            arrayY.append((lblframedata[i] as NSDictionary).value(forKey: "relativey")! as! String)
            arrayx.append((lblframedata[i] as NSDictionary).value(forKey: "relativex")! as! String)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tagpeople.isEnabled = false
        self.imgpost.isUserInteractionEnabled = true
        //
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "imgMenuBar"), for: .default)
        // Do any additional setup after loading the view.
        self.locationlbl.text = "Add Location"
        //without adding the view
        
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationBar.layer.shadowOpacity = 0.3
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationBar.layer.shadowRadius = 2.5
        
        textView.placeholderText = "Add Caption"
        textView.textColor = UIColor.black
        textView.delegate = self
        scrolllview.isHidden = true
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        self.view.addSubview(circularview!)
        
    }

    
    
    func addloader()  {
        // Box config:
        indicatorView = UIView(frame: CGRect(x: 115, y: 110, width: 80, height: 110))
        indicatorView?.backgroundColor = UIColor.black
        
        indicatorView?.alpha = 0.9
        indicatorView?.layer.cornerRadius = 10
        
        // Spin config:
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityView.frame = CGRect(x: 20, y: 12, width: 40, height: 40)
        activityView.startAnimating()
        
        // Text config:
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 50))
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.init(name: "Roboto-Light", size: 13.0)
        textLabel.text = "Uploading...\n 0%"
        indicatorlbl = textLabel
        // Activate:
        indicatorView?.center = self.imgpost.center
        indicatorView?.addSubview(activityView)
        indicatorView?.addSubview(indicatorlbl!)
        view.addSubview(indicatorView!)
    }

    
    @IBOutlet weak var filterimage: UIImageView!
    @IBOutlet weak var scrolllview: UIScrollView!
    @IBOutlet weak var filterphoto: UIImageView!
    
    
    @IBAction func pickerbtn(_ sender: UIButton) {

        
        let alertcontroller = UIAlertController.init(title: NSLocalizedString("Choose Option", comment: "Choose Option") , message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: "Choose From Gallery"), style: .default)
        { action in
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = ["public.image", "public.movie"]
            self.picker.delegate = self
            self.picker.videoQuality = .typeMedium
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
                
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerControllerSourceType.camera;
                self.picker.allowsEditing = true
                DispatchQueue.main.async
                    {
                        self.present(self.picker, animated: true, completion: nil)
                }
            }
        }
        alertcontroller.addAction(OKAction)
        
        
        alertcontroller.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil))
        
        
        if let popoverController = alertcontroller.popoverPresentationController {
            popoverController.sourceView = sender as UIView
            popoverController.sourceRect = sender.bounds
        }
        
        
        self.present(alertcontroller, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    func filterButtonTapped(sender : UIButton){
        let button = sender as UIButton
        
        imgpost.image = button.backgroundImage(for: .normal)
        scrolllview.isHidden = true
        self.image1 = self.imgpost.image!
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.placeholderText = "Add Caption"
            //textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    var status = "0"
    
    @IBAction func submit(_ sender: UIButton) {
        
        guard let filetype = self.filetype else {
            self.showalertview(messagestring: "Please select a post before uploading!")
            return
        }
        if restrict == false {
            status = "0"
        }else {
            status = "1"
        }
        
        UpdateMulipartApi(filetype: filetype)
        
        
    }
    
    
    func filter() {
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        
        var itemCount = 0
        
        for i in 0..<8 {
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord , y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(filterButtonTapped(sender:)), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            // Create filters for each button
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: imgpost.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!)
            // Assign filtered image to the button
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            // Add Buttons in the Scroll View
            xCoord +=  buttonWidth + gapBetweenButtons
            scrolllview.addSubview(filterButton)
        } // END FOR LOOP
        
        
        // Resize Scroll View
        scrolllview.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount+2), height: yCoord)
        
        
    }
    
    
    
    
    
    @IBOutlet weak var tagpeople: UIButton!
    
    @IBAction func tagpeople(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TagViewController") as! TagViewController
        vc.delegate = self
        
        vc.image2 = image1
        vc.data = lblframedata
        vc.tagname = nameArr
        vc.userid = self.userid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.nameArr = []
        self.lblframedata = []
        
    }
    
    @IBAction func addlocation(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchlocationViewController") as! SearchlocationViewController
        vc.delegate = self
        vc.locationString = self.location
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func restrictAction(_ sender: UIButton) {
        
        if sender.imageView!.image == #imageLiteral(resourceName: "imgcheck1"){
            sender.setImage(#imageLiteral(resourceName: "imguncheck1"), for: .normal)
            restrict = false
        }else{
            sender.setImage(#imageLiteral(resourceName: "imgcheck1"), for: .normal)
            restrict = true
        }
    }
    
    @IBAction func btnCreatePhotoTourTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhototourViewController") as! PhototourViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        let height = self.textView.sizeThatFits(CGSize(width: self.textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        if height > 55 {
            self.textViewHeight.constant = height
        }
    }
    

    
    //Video url
    var videoURL: URL?
    var filetype : String?
    var videoPath = NSURL()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            
            imgpost.contentMode = .scaleAspectFit
            self.imgpost.image = image
            self.image1 = image
            self.tagpeople.isEnabled = true
            //self.selectpicbtn.isHidden = true
            // scrolllview.isHidden = false
            //  filter()
            filetype = "image"
            
        } else{
            print("Get Video")
            
            if let fileURL =  info[UIImagePickerControllerMediaURL] as? URL {
                videoURL = fileURL
                self.compress(inputURL: fileURL)
            }
            
            self.imgpost.image = generateThumnail(url: videoURL! as URL, fromTime: 1.0)
            let button = UIButton(frame: CGRect(x: self.imgpost.frame.origin.x, y: self.imgpost.frame.origin.y, width: self.imgpost.frame.size.width, height: self.imgpost.frame.size.height))
            button.alpha = 0.8
            button.addTarget(self, action: #selector(self.playbtn(sender:)), for: .touchUpInside)
            // button.setBackgroundImage(#imageLiteral(resourceName: "imgPlay1.png"), for: .normal)
            self.imgpost.addSubview(button)
            filetype = "video"
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    func playbtn(sender:UIButton){
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "imgPlay1.png") {
            avPlayer.play()
            playVideo()
        }else{
            sender.setBackgroundImage(#imageLiteral(resourceName: "imgpause1.png"), for: .normal)
            avPlayer.pause()
        }
    }
    
    
    
    
    var avPlayer  = AVPlayer()
    func playVideo() {
        let videoURL = self.videoURL
        avPlayer = AVPlayer(url: videoURL! as URL)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = CGRect(x: self.imgpost.frame.origin.x, y:  self.imgpost.frame.origin.x, width:  self.imgpost.frame.size.width, height: self.imgpost.frame.size.height)
        self.imgpost.layer.addSublayer(playerLayer)
        avPlayer.play()
    }
    
    
    
    var image1 = UIImage()
    
    fileprivate func generateThumnail(url : URL, fromTime:Float64) -> UIImage? {
        let asset :AVAsset = AVAsset(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter = kCMTimeZero;
        assetImgGenerate.requestedTimeToleranceBefore = kCMTimeZero;
        let time        : CMTime = CMTimeMakeWithSeconds(fromTime, 600)
        var img: CGImage?
        do {
            img = try assetImgGenerate.copyCGImage(at:time, actualTime: nil)
        } catch {
        }
        if img != nil {
            let frameImg    : UIImage = UIImage(cgImage: img!)
            return frameImg
        } else {
            return nil
        }
    }
    
    
    
    
    
    //MARK: Upload APi
    @IBOutlet weak var selectpicbtn: UIButton!
    
    
    func compressImage(image:UIImage) -> Data? {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.7
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else{
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = UIImageJPEGRepresentation(img, compressionQuality)else{
            return nil
        }
        return imageData
    }
    
    func UpdateMulipartApi(filetype : String){
        //let names = self.nameArr.joined(separator: ", ")
        
        DispatchQueue.main.async {
            self.addloader()
            self.view.isUserInteractionEnabled = false
        }
        let userid = self.userid.joined(separator: ",")
        let x = self.arrayx.joined(separator: ",")
        let y = self.arrayY.joined(separator: ",")
        
        
        
        let parameter: Parameters = ["action":"upload_photo", "userid":"\(standard.value(forKey: "user_id")!)" ,"caption":"\(textView.text!)","tag_people": "\(userid)","x_cordinates": "\(x)" , "y_cordinates":"\(y)", "location":"\(location)","restricted_status":"\(status)" , "file_type" : "\(filetype)"]
        
        print(parameter)
        
        Alamofire.upload(multipartFormData: {
            (multipartFormData) in
            if filetype == "image"{
                var data = self.compressImage(image: self.imgpost.image!)
                if data == nil {
                   data = UIImageJPEGRepresentation(self.imgpost.image!, 0.7)!
                }
                multipartFormData.append(data!, withName: "filename", fileName: "filename.jpeg", mimeType: "image/jpg")
            } else {
                multipartFormData.append((self.videoURL?.absoluteURL)!, withName: "filename", fileName: "filename.MP4", mimeType: "video/.MP4")
                multipartFormData.append(UIImageJPEGRepresentation(self.imgpost.image!, 0.5)!, withName: "thumbnail", fileName: "thumbnail.jpeg", mimeType: "image/jpg")
            }
            //thumbnail
            for (key, value ) in parameter {
                multipartFormData.append(((value) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to: mainurl + "upload_object.php"){  (result) in
            switch result {
            case .success(let upload, _,_ ):
                upload.uploadProgress(closure: { (progress) in
                    DispatchQueue.main.async {
                        self.indicatorlbl?.text = "Uploading...\n \(String(format:"%.1f", progress.fractionCompleted * 100))%"
                    }
                })
                upload.responseJSON { response in
                    guard ((response.result.value) != nil) else{
                        self.view.isUserInteractionEnabled = false
                        print(response.result.error!.localizedDescription)
                        self.showalertview(messagestring: response.result.error!.localizedDescription)
                         self.indicatorView?.removeFromSuperview()
                        return
                    }
                    var json = JSON(response.result.value!)
                    print(json)
                    guard (json["result"]["msg"] .intValue) == 201  else {
                        DispatchQueue.main.async {
                            self.view.isUserInteractionEnabled = false
                            self.indicatorlbl?.text = json["msg"].stringValue
                            self.indicatorView?.removeFromSuperview()
                        }
                        return
                    }
                   
                    var str = "Your photo has been posted.You've earned 100 points."
                    if  filetype == "video" {
                        str = "Your Video has been posted.You've earned 100 points."
                    }
                    DispatchQueue.main.async {
                        self.view.isUserInteractionEnabled = false
                        self.indicatorView?.removeFromSuperview()
                    }
                    self.showalertViewcontroller(message: str , handler: {
                        photoposted = false
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
            case .failure(let encodingError):
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = false
                }
                print (encodingError.localizedDescription)
                self.indicatorView?.removeFromSuperview()
            }
        }
    }
    
    //compression
    func compress(inputURL: URL){
        let data = NSData(contentsOf: inputURL)
        print("File size before compression: \(Double(data!.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: inputURL , outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }

    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality) else {
            handler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}
