//
//  PhototourViewController.swift
//  Viegram
//
//  Created by Relinns on 05/07/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import ImagePicker
import AADraggableView
import SnapKit
import Alamofire
import SwiftyJSON
import Photos
import NohanaImagePicker


class PhototourViewController: UIViewController , ImagePickerDelegate , AADraggableViewDelegate ,UIGestureRecognizerDelegate ,selectIconDelegates,selectColor,showfullImagesdelegates,editPhotodelegates,UITextViewDelegate, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate{
    let url = mainurl + "phototour_object.php"
    var currentIndex = Int()
    var currentIcontag = Int()
    var fullPhoto : AllImage?
    var imageArr = [[UIImage]]()
    var imageViewArr = [[SKPhoto]]()
    var imageIdArr = [[String]]()
    var currentTxtView = UITextView()
    var currentIconView = UIImageView()
    var Dragview1 = [AADraggableView]()
    var DragviewIcon1 = [AADraggableView]()
    var DragviewText1 = [AADraggableView]()
    var Dragview:AADraggableView = AADraggableView()
    var isAdd = false
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    
    //icons Array
    let iconsArr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"]
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var _bottomviewy: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "imgMenuBar"), for: .default)
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationBar.layer.shadowOpacity = 0.3
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationBar.layer.shadowRadius = 2.5
        
        addBorder(view: backgroundbtn)
        addBorder(view: iconsbtn)
        addBorder(view: text)
        addBorder(view: addimage)
        
        
        self.mainView.backgroundColor = UIColor.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhototourViewController.presentview(sender:)))
        
        Presentlbl.isUserInteractionEnabled = true
        Presentlbl.addGestureRecognizer(tap)
        
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        
    }
    
    
    //button for items
    
    @IBOutlet weak var backgroundbtn: UIButton!
    @IBOutlet weak var iconsbtn: UIButton!
    @IBOutlet weak var text: UIButton!
    @IBOutlet weak var addimage: UIButton!
    @IBOutlet weak var Presentlbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var changeColorOfView = -1
    //borderlayer function
    
    func addBorder(view:UIView){
        
        view.layer.borderWidth = 1
        view.layer.borderColor = apppurple.cgColor
        
    }
    
    
    func  addPhotos(index:Int , imageArr : [UIImage],imageArrIDs: [String],view: AllImage,view1: PhotoIcon){
        print(self.imageArr.count)
        print(self.imageIdArr.count)
        self.bool = true
        self.currentIndex = index
        self.currentIcontag = view1.tag
        
        fullPhoto = view
        isAdd = true
       
        
        
        if imageArr.count < 4{
            self.showActionSheet(count: 4 - imageArr.count, isAddMore: true)
            
        }
        else{
            
            self.showalertview(messagestring: "You cannot select more than 4 images")
            
        }
       
        
        
        
    }
    
    
    func  setUpPhotoView(index:Int , imageArr : [UIImage],imageArrIDs: [String],view: AllImage,view1: PhotoIcon , tag :  Int){
        
        print(  self.imageArr.count)
        print( self.imageIdArr.count)
        if tag == 1 {
            
            let vc = Dragview1[view1.tag]
            vc.removeFromSuperview()
            Dragview1.remove(at: view1.tag)
            view.removeFromSuperview()
            self.imageArr.remove(at: view1.tag)
            self.imageIdArr.remove(at: view1.tag)
            
            for i in 0..<Dragview1.count {
                
                for subView in Dragview1[i].subviews
                {
                    print("hello")
                    if let vc = subView as? PhotoIcon
                    {
                        print(i)
                        print(vc.tag)
                        vc.tag = i
                        print(vc.tag)
                    }
                }
            }
        }
        else{
            
            self.imageArr[view1.tag].remove(at: index)
            self.imageIdArr[view1.tag].remove(at: index)
            let vc = Dragview1[view1.tag]
            
            Dragview = AADraggableView(frame: CGRect(x:vc.frame.origin.x , y: vc.frame.origin.y, width: 50 , height: 50))
            
            Dragview.layer.cornerRadius = 5
            Dragview.layer.masksToBounds = true
            Dragview.delegate = self
            
            Dragview.respectedView = self.mainView
            
            Dragview.repositionIfNeeded() //
            Dragview.backgroundColor = UIColor.clear
            
            let photoIcon = PhotoIcon()
            photoIcon.delegates = self
            photoIcon.imageArr =   self.imageArr[view1.tag]
            photoIcon.setupframe()
            photoIcon.tag = view1.tag
            Dragview.addSubview(photoIcon)
            
            
            
            
            photoIcon.snp.makeConstraints { (make) -> Void in
                // make.width.height.equalTo(50)
                make.top.bottom.equalTo(Dragview)
                make.trailing.leading.equalTo(Dragview)
                
            }
            view1.removeFromSuperview()
            mainView.addSubview(Dragview)
            
            Dragview1[view1.tag] = Dragview
            
            view.removeFromSuperview()
            let vcFull = AllImage.init(frame: self.view.frame, imgArr:  self.imageArr[view1.tag], imgIds: self.imageIdArr[view1.tag],view1 : view1)
            vcFull.delegates = self
            self.view.addSubview(vcFull)
            
        }
        
        
    }
    
    
    
    //MARK: - Edit Photo Action
    func  editPhoto(index:Int , imageArr : [UIImage],imageArrIDs: [String],view: AllImage,view1: PhotoIcon){
        print(self.imageArr.count)
        print(self.imageIdArr.count)
        
        
        if imageArr.count == 1 {
            
            let parameter : Parameters = ["action": "delete_image",
                                          "image_id":  self.imageIdArr[index]]
            
            
            self.deleteImageApiCall(parameter: parameter, tag: 1, index: index, imageArr: imageArr, imageArrIDs: imageArrIDs, view: view, view1: view1)
            
        }
        else{
            print(self.imageIdArr[view1.tag][index])
            let parameter : Parameters = ["action": "delete_image",
                                          "image_id":  self.imageIdArr[view1.tag][index]]
            
            self.deleteImageApiCall(parameter: parameter, tag: 2, index: index, imageArr: imageArr, imageArrIDs: imageArrIDs, view: view, view1: view1)
            
        }
        
    }
    
    
    //MARK: - bottom view actions
    
    @IBAction func backgroundbtn(_ sender: UIButton) {
        changeColorOfView = 0
        let  vc = Color.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        vc.delegates = self
        self.view.addSubview(vc)
    }
    
    
    //MARK: - TextButton Action
    
    @IBAction func TextBtnAction(_ sender: UIButton) {
        self.bool = true
        let textView = UITextView()
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != textView.frame.size.height && size.height > textView.frame.size.height{
            textView.frame.size.height = size.height
            textView.setContentOffset(CGPoint.zero, animated: false)
        }
        textView.delegate = self
        //textView.frame = CGRect(x:100 , y: 150, width: 80, height: 80)
        textView.textAlignment = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tabTextView(sender:)))
        tapGesture.numberOfTapsRequired = 2
        textView.addGestureRecognizer(tapGesture)
        
        
        let tapGestureSingle = UITapGestureRecognizer(target: self, action: #selector(self.tabTextViewSingle(sender:)))
        tapGesture.numberOfTapsRequired = 1
        textView.addGestureRecognizer(tapGestureSingle)
        
        
        
        var Dragview1:AADraggableView = AADraggableView()
        
        Dragview1 = AADraggableView(frame: CGRect(x:100 , y: 110, width: 80, height: 40))
        Dragview1.layer.cornerRadius = 5
        textView.backgroundColor = UIColor.clear
        
        Dragview1.layer.masksToBounds = true
        Dragview1.delegate = self // AADraggableViewDelegate
        
        Dragview1.respectedView = self.mainView
        
        Dragview1.repositionIfNeeded() //
        Dragview1.backgroundColor = UIColor.clear
        
        Dragview1.addSubview(textView)
        textView.becomeFirstResponder()
        textView.snp.makeConstraints { (make) -> Void in
            //make.width.height.equalTo(50)
            make.top.bottom.equalTo(Dragview1)
            make.trailing.leading.equalTo(Dragview1)
            
        }
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.tabIconLongTextView(sender:)))
        Dragview1.addGestureRecognizer(longPressRecognizer)
        
        mainView.addSubview(Dragview1)
        self.DragviewText1.append(Dragview1)
        
        for index in 0..<DragviewText1.count {
            
            DragviewText1[index].tag  = index
            
        }
        
    }
    
    
    
    
    
    var arrOfPoints = [[String: Any]]()
    
    @IBAction func saveImageTapped(_ sender: Any) {
        if  let image = mainView.asImage(){
        let parameter : Parameters = ["action": "main_image",
                                          "userid":standard.value(forKey: "user_id") as? String ?? ""]
    
            self.uploadSingleImage(image: image, parameters: parameter as [String : AnyObject])
        }
    }
    
    func uploadPhotoTourData(imgID : String){
        print(imgID)
        arrOfPoints.removeAll()
        
        for i in 0..<Dragview1.count{
            
            let vc = Dragview1[i]
            
            let strX = String(describing: (vc.frame.origin.x/mainView.frame.width)*100)
            let strY = String(describing: (vc.frame.origin.y/mainView.frame.height)*100)
            
            let arrImage = imageIdArr[i]
            
            print(arrImage)
            
            let dict = ["x_cordinate" :strX,"y_cordinate":strY,"imageid": arrImage] as [String : Any]
            
            print(dict)
            arrOfPoints.append(dict)
            
        }
        let dicMain :  Parameters  = ["action":"phototour" , "userid": standard.value(forKey: "user_id") as? String ?? "",
                                      "main_image": imgID,"tourarray" : arrOfPoints]
        print(dicMain)
        
        self.apicall(parameter: dicMain)
    }
    
    
    
    //MARK:- Show All Images Delegates
    func showallfullImages(imageArr:[UIImage],view: PhotoIcon){
        print(view.tag)
        let vc = AllImage.init(frame: self.view.frame, imgArr: imageArr, imgIds: self.imageIdArr[view.tag],view1 : view)
        vc.delegates = self
        self.view.addSubview(vc)
    }
    
    
    //MARK: - AddIcon_Button Action
    
    var temp = 1
    @IBAction func iconbtnaction(_ sender: UIButton) {
        
        let vc = CollectionVc.init(frame: self.view.frame)
        vc.delegates = self
        self.view.addSubview(vc)
        
 
        UIView.animate(withDuration: 0.7, animations: {
            
            if self.temp == 1 {
                self.temp = 2
            }else{
                self.temp = 1
            }
            
            
        }, completion: nil)
        
    }
    
    
    //MARK: - AddImage_Button Action
    
    @IBAction func addimage(_ sender: UIButton) {
        
        self.showActionSheet(count: 0, isAddMore: false)
    }
    
    
    
    
    var bool = true
    func presentview(sender:UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, animations: {
            if self.bool == true {
                self.bottomView.frame.origin.y -= 65
                self.bool = false
            }else{
                self.bottomView.frame.origin.y += 65
                self.bool = true
            }
        }, completion: nil)
        
    }
    
    func openCamera()
    {
        let picker:UIImagePickerController? = UIImagePickerController()
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            picker?.delegate = self
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
   
    
    //MARK:- PICKER IMAGE DATA
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var arrImages1 = [UIImage]()
        arrImages1.append(image)
        dismiss(animated:true, completion: nil)
         self.seletedImages(images: arrImages1)
        
    }
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    
    //imagepicker done
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
        self.seletedImages(images: images)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func dismissView(){
        
        self.bool = true
    }
    
    func apicall(parameter:Parameters){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        self.view.isUserInteractionEnabled = false
        print(parameter)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default , headers: nil).responseJSON { (response) in
            animationView.pause()
            animationView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                
                return
            }
            
            self.showalertview(messagestring: "FotoTour posted successfully", Buttonmessage: "OK", handler: {
                photoposted = false
                self.navigationController?.popToRootViewController(animated: true)
            })
            print("success")
            
        }
    }
    
    func deleteImageApiCall(parameter:Parameters , tag : Int ,index:Int , imageArr : [UIImage],imageArrIDs: [String],view: AllImage,view1: PhotoIcon){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        self.view.isUserInteractionEnabled = false
        print(parameter)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default , headers: nil).responseJSON { (response) in
            animationView.pause()
            animationView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                
                print("failure")
                
                return
            }
            self.setUpPhotoView(index: index, imageArr: imageArr, imageArrIDs: imageArrIDs, view: view, view1: view1, tag: tag)
            print("success")
            
        }
    }
    
    
    
    func uploadSingleImage(image : UIImage,parameters:[String : AnyObject]?){
        
        let imgData = UIImageJPEGRepresentation(image, 0.5)!
        
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image1",fileName: "image.jpg", mimeType: "image/jpg")
            for (key, value) in parameters! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    
                    let jsonData = JSON(response.result.value)
                    let imageID = jsonData["result"]["image_id"].stringValue
                    self.uploadPhotoTourData(imgID: imageID)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
        
    }
    
    //MARK:- TEXTVIEW DELEGATES 
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        textView.isSelectable = false
    }
    
    
    
    //MARK:- UploadImagesWithArray
    func uploadImagesAndData(params:[String : AnyObject]?, imageArr : [UIImage] , photoIcon : PhotoIcon) {
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        self.view.isUserInteractionEnabled = false
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in params! {
                if let data = value.data(using: String.Encoding.utf8.rawValue) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            for i in 0..<imageArr.count{
                multipartFormData.append(UIImageJPEGRepresentation(imageArr[i], 0.5)!, withName: "image\(i+1)", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
        },
                         to: url, encodingCompletion: { encodingResult in
                            
                            
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload
                                    .validate()
                                    .responseJSON { response in
                                        animationView.pause()
                                        animationView.removeFromSuperview()
                                        self.view.isUserInteractionEnabled = true
                                        switch response.result {
                                        case .success(let value):
                                            print("responseObject: \(value)")
                                            let jsondata = JSON(value)
                                            
                                            
                                            if self.isAdd == true{
                                                
                                                
                                                for i in 0..<jsondata["result"]["image_ids"].arrayValue.count{
                                                    self.imageIdArr[self.currentIcontag].append(jsondata["result"]["image_ids"].arrayValue[i].stringValue)
                                                }
                                                
                                                print(self.imageIdArr)
                                                
                                                
                                                self.fullPhoto?.removeFromSuperview()
                                                let vcFull = AllImage.init(frame: self.view.frame, imgArr:  self.imageArr[self.currentIcontag], imgIds: self.imageIdArr[self.currentIcontag],view1 : photoIcon)
                                                vcFull.delegates = self
                                                
                                                self.view.addSubview(vcFull)
                                                
                                                
                                            }
                                                
                                            else{
                                                var arr = [String]()
                                                
                                                for i in 0..<jsondata["result"]["image_ids"].arrayValue.count{
                                                    
                                                    arr.append(jsondata["result"]["image_ids"].arrayValue[i].stringValue)
                                                    
                                                }
                                                
                                                self.imageIdArr.append(arr)
                                                print(self.imageIdArr)
                                            }
                                            
                                            
                                            
                                        case .failure(let responseError):
                                            print("responseError: \(responseError)")
                                        }
                                }
                            case .failure(let encodingError):
                                animationView.pause()
                                animationView.removeFromSuperview()
                                self.view.isUserInteractionEnabled = true
                                print("encodingError: \(encodingError)")
                            }
        })
        
    }
    
    
    func photoTourApiWithCoordinate(){
        
        
        
    }
    
    
    
    //MARK:-  Gesture Action
    
    func didRotatePhotoView(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let imageView = sender.view as! AADraggableView
        let previousTransform = imageView.transform
        imageView.transform = previousTransform.rotated(by: rotation)
        sender.rotation = 0
    }
    
    
    func didRotate(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        let previousTransform = imageView.transform
        imageView.transform = previousTransform.rotated(by: rotation)
        sender.rotation = 0
    }
    
    
    
    func tabIconView(sender: UITapGestureRecognizer){
        changeColorOfView = 2
        currentIconView = sender.view as! UIImageView
        let  vc = Color.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        vc.delegates = self
        self.view.addSubview(vc)
    }
    func tabIconLong(sender: UILongPressGestureRecognizer){
        
        let vc1 = sender.view as! AADraggableView
        
        self.showActionSheet(index: sender.view!.tag, vc: vc1, isTextView: false)
      
        
    }
    func tabIconLongTextView(sender: UILongPressGestureRecognizer){
        
        let vc1 = sender.view as! AADraggableView
        
        self.showActionSheet(index: sender.view!.tag, vc: vc1, isTextView: true)
        
        
    }
    
    func tabTextViewSingle(sender: UITapGestureRecognizer){
        
         currentTxtView = sender.view as! UITextView
       
        currentTxtView.isSelectable = true
        currentTxtView.isEditable = true
         currentTxtView.becomeFirstResponder()
    }
    
    
    func tabTextView(sender: UITapGestureRecognizer){
        currentTxtView = sender.view as! UITextView
        
        currentTxtView.resignFirstResponder()
        changeColorOfView = 1
        let  vc = Color.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        vc.delegates = self
        self.view.addSubview(vc)
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    func photoview(sender:UIButton){
        let i = sender.tag
        let newArr = imageViewArr[i]
        
        let browser = SKPhotoBrowser(photos: newArr)
        browser.initializePageIndex(0)
        
        present(browser, animated: true, completion: {})
    }
    
    
    func colorTapped(color:UIColor){
        self.bool = true
        
        if changeColorOfView == 0{
            mainView.backgroundColor = color
            for index in 0..<DragviewIcon1.count {
                DragviewIcon1[index].backgroundColor = color
            }
            self.backgroundbtn.backgroundColor = color
            
        }
        else if changeColorOfView == 1{
            self.currentTxtView.textColor = color
        }
            
        else if changeColorOfView == 2{
            
            currentIconView.image = currentIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            currentIconView.tintColor = color
        }
    }
    // Add delegate methods and observe changes!
    var lastPoint = CGPoint()
    
    var newPoint = CGPoint()
    
    //MARK: - Dragview Delegates
    func draggingDidBegan(_ sender: UIView) {
        
        if DragviewIcon1.count > 0 {
            
            
            for index in 0..<DragviewIcon1.count {
                
                DragviewIcon1[index].tag  = index
                
            }
            
            for index in 0..<DragviewIcon1.count - 1 {
                
                
                let view = DragviewIcon1[index]
                
                let frame = view.frame.origin.x + view.frame.size.width/2
                let frame12 = view.frame.origin.y + view.frame.size.height
                lastPoint = CGPoint(x: frame, y: frame12 )
                print(lastPoint)
                
                
                let view1 = DragviewIcon1[index + 1]
                
                let frame1 = view1.frame.origin.x
                let frame11 = view1.frame.origin.y
                newPoint = CGPoint(x: frame1, y: frame11 )
                print(newPoint)
                if layerArray != [] {
                    
                    //  self.view.layer.sublayers =  self.view.layer.sublayers?.contains(CAShapeLayer)
                    mainView.layer.sublayers!.removeFirst()
                    layerArray.removeFirst()
                    
                    
                }
                //addLine(fromPoint: lastPoint, toPoint: newPoint , index: index)
                
            }
            
        }
    }
    
    
    
    @IBAction func tabOnView(_ sender: Any) {
        
        
        
    }
    
    
    
    
    
    
    
    func draggingDidEnd(_ sender: UIView) {
        if DragviewIcon1.count > 0 {
            for index in 0..<DragviewIcon1.count {
                
                DragviewIcon1[index].tag  = index
                
            }
            
            for index in 0..<DragviewIcon1.count - 1 {
                
                
                let view = DragviewIcon1[index]
                
                let frame = view.frame.origin.x + view.frame.size.width/2
                let frame12 = view.frame.origin.y + view.frame.size.height
                lastPoint = CGPoint(x: frame, y: frame12 )
                print(lastPoint)
                
                
                let view1 = DragviewIcon1[index + 1]
                
                let frame1 = view1.frame.origin.x + view1.frame.size.width/2
                let frame11 = view1.frame.origin.y + view1.frame.size.height
                newPoint = CGPoint(x: frame1, y: frame11 )
                print(newPoint)
                
              //  addLine(fromPoint: lastPoint, toPoint: newPoint , index: index)
                
            }
        }
        
    }
    
    
    var layerArray = [CAShapeLayer]()
    
    
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint , index: Int) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.lineDashPattern = [4,4]
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 1
        line.lineJoin = kCALineJoinRound
        layerArray.insert(line, at: index)
        mainView.layer.insertSublayer(line, at: UInt32(index))
    }
    
    
    func showActionSheet(index : Int ,vc : AADraggableView , isTextView : Bool){
        
        let alertController = UIAlertController(title: nil, message: "Delete?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
    
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
          print("Delete")
            if isTextView == true {
                self.DragviewText1.remove(at: index)
            }
            else{
                self.DragviewIcon1.remove(at: index)
            }
            
           
            
             vc.removeFromSuperview()
            
        }
        alertController.addAction(destroyAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        
        self.present(alertController, animated: true) {
          
        }
        
    }
    
    
    
    func showActionSheet( count : Int , isAddMore : Bool){
        
        let alertController = UIAlertController(title: nil, message: "Select Option", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: .destructive) { (action) in
            print("Gallary")
            
            
            if isAddMore == true {
                let picker = NohanaImagePickerController()
                picker.delegate = self
                picker.maximumNumberOfSelection = count
                
                self.present(picker, animated: true, completion: nil)
                
            }
            else{
                let picker = NohanaImagePickerController()
                picker.delegate = self
                picker.maximumNumberOfSelection = 4
                self.isAdd = false
                
                self.bool = true
                self.present(picker, animated: true, completion: nil)
                
            }
            
            
        }
        
        
        let cameraAction = UIAlertAction(title: "Camera", style: .destructive) { (action) in
            print("Camera")
             self.bool = true
            self
            .openCamera()
            
        }
         alertController.addAction(gallaryAction)
        alertController.addAction(cameraAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        
        self.present(alertController, animated: true) {
            
        }
        
    }
    
    
    
    
    func didSelectCollectionOncell(indexPath:IndexPath){
        let imageview = UIImageView()
        
        var DragviewIcon:AADraggableView = AADraggableView()
        
        DragviewIcon = AADraggableView(frame: CGRect(x:100 , y: 150, width: 40, height: 40))
        DragviewIcon.layer.cornerRadius = 5
        DragviewIcon.layer.masksToBounds = true
        DragviewIcon.delegate = self // AADraggableViewDelegate
        // view.respectedView = // reference view
        DragviewIcon.respectedView = self.mainView
        DragviewIcon.isUserInteractionEnabled = true
        DragviewIcon.repositionIfNeeded() //
        DragviewIcon.backgroundColor = mainView.backgroundColor
        
        imageview.clipsToBounds = true
        imageview.image = UIImage(named:(iconsArr[indexPath.item]))
        imageview.tintColor = UIColor.black
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        imageview.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tabIconView(sender:)))
        tapGesture.numberOfTapsRequired = 2
        imageview.addGestureRecognizer(tapGesture)
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.tabIconLong(sender:)))
           DragviewIcon.addGestureRecognizer(longPressRecognizer)
        
       
        
        
        DragviewIcon.addSubview(imageview)
        imageview.snp.makeConstraints { (make) -> Void in
            //make.width.height.equalTo(50)
            make.top.bottom.equalTo(DragviewIcon)
            make.trailing.leading.equalTo(DragviewIcon)
            
        }
        mainView.addSubview(DragviewIcon)
        self.DragviewIcon1.append(DragviewIcon)
        for index in 0..<DragviewIcon1.count {
            
            DragviewIcon1[index].tag  = index
            
        }
        self._bottomviewy.constant = -65
        self.bool = true
        temp = 1
        
        
    }
    
    
    func seletedImages(images : [UIImage]){
        
        if isAdd == true{
            
            for i in 0..<images.count{
                imageArr[currentIcontag].append(images[i])
            }
            
            let vc = Dragview1[currentIcontag]
            
            Dragview = AADraggableView(frame: CGRect(x:vc.frame.origin.x , y: vc.frame.origin.y, width: 50, height: 50))
            
            Dragview.layer.cornerRadius = 5
            Dragview.layer.masksToBounds = true
            Dragview.delegate = self
            
            Dragview.respectedView = self.mainView
            
            Dragview.repositionIfNeeded() //
            Dragview.backgroundColor = UIColor.clear
            
            let photoIcon = PhotoIcon()
            photoIcon.delegates = self
            photoIcon.imageArr =   self.imageArr[currentIcontag]
            photoIcon.setupframe()
            photoIcon.tag = currentIcontag
            Dragview.addSubview(photoIcon)
            
            
            
            
            photoIcon.snp.makeConstraints { (make) -> Void in
                make.top.bottom.equalTo(Dragview)
                make.trailing.leading.equalTo(Dragview)
                
            }
            
            mainView.addSubview(Dragview)
            
            let view1 = Dragview1[currentIcontag]
            
            view1.removeFromSuperview()
            
            
            Dragview1[currentIcontag] = Dragview
            
            
            
            
            let parameter : Parameters = ["action": "upload_phototour_images",
                                          "userid":standard.value(forKey: "user_id") as? String ?? ""]
            
            self.uploadImagesAndData(params: parameter as [String : AnyObject], imageArr: images, photoIcon: photoIcon)
            
            
            
            
            
            
            
        }
        else{
            
            imageArr.append(images)
            
            Dragview = AADraggableView(frame: CGRect(x:100 , y: 150, width: 50, height: 50))
            mainView.addSubview(Dragview)
            
            
            
            Dragview.layer.cornerRadius = 5
            Dragview.layer.masksToBounds = true
            Dragview.delegate = self
            
            Dragview.respectedView = self.mainView
            
            Dragview.repositionIfNeeded() 
            Dragview.backgroundColor = UIColor.clear
            
            let photoIcon = PhotoIcon()
            photoIcon.delegates = self
            photoIcon.imageArr = images
            photoIcon.setupframe()
            
            Dragview.addSubview(photoIcon)
            
            
            
            
            photoIcon.snp.makeConstraints { (make) -> Void in
              
                make.top.bottom.equalTo(Dragview)
                make.trailing.leading.equalTo(Dragview)
                
            }
            
            let parameter : Parameters = ["action": "upload_phototour_images",
                                          "userid":standard.value(forKey: "user_id") as? String ?? ""]
            
            self.uploadImagesAndData(params: parameter as [String : AnyObject], imageArr: images, photoIcon: photoIcon)
            
            mainView.addSubview(Dragview)
            
            Dragview1.append(Dragview)
            photoIcon.tag = Dragview1.count - 1
            
            
        }
        
    }
    
    
}


extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
    }
}
extension PhototourViewController: NohanaImagePickerControllerDelegate {
    
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController) {
        print("🐷Canceled🙅")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts :[PHAsset]) {
        print("🐷Completed🙆\n\tpickedAssets = \(pickedAssts)")
        
        
        var images = [UIImage]()
        
        
        
        picker.dismiss(animated: true, completion: nil)
        
        let options:PHImageRequestOptions = PHImageRequestOptions()
        options.version = PHImageRequestOptionsVersion.unadjusted
        options.isSynchronous = false
        
        
        for asset in pickedAssts{
            _ = CGSize(width: asset.pixelWidth,
                       height: asset.pixelHeight)
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options, resultHandler: { (image, _) in
                
                
                images.append(image!)
                
                print(pickedAssts.count)
                
                if images.count == pickedAssts.count{
                    self.seletedImages(images: images)
                    
                }
            
            })
           
        }
        
        
     
        
        
        
        
    }
}
