//
//  TagViewController.swift
//  Viegram
//
//  Created by Relinns on 27/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import CoreImage
protocol tagpeople: class {
    func tag(name:[String] , user_id:[String] )
    func cgrectframe(framArr : [[String:String]])
}
class TagViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{
    
    var FollowingPersonsData = [PointOnPostModel]()
    var filteredData = [PointOnPostModel]()
    @IBOutlet weak var filterimage: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    lazy var whoIsThis = UIImageView.init(image: UIImage.init(named: "who_this"))
    @IBOutlet weak var navbar: UINavigationBar!
    weak var delegate:tagpeople?
    var tapGesture = UITapGestureRecognizer()
    @IBOutlet weak var imgpost: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var image2 = UIImage()
    var data = [[String:String]]()
    var tagname = [String]()
    var userid = [String]()
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.cgrectframe(framArr: data)
        self.delegate?.tag(name: tagname, user_id: userid)
        self.data = []
        self.tagname = []
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detectFaces()
        FolloweinglistApi()
        self.searchtf.isHidden = true
        self.imgpost.isHidden = false
        self.imgpost.image = image2
        let imageratio = self.image2.size.width / self.image2.size.height
        let height = UIScreen.main.bounds.size.width / imageratio
        self.imageHeightConstraint.constant = height
        self.tableview.isHidden = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(TagViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imgpost.addGestureRecognizer(tapGesture)
        imgpost.isUserInteractionEnabled = true
        
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        DispatchQueue.main.async {
            self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
            self.searchtf.layer.borderWidth = 0.5
            self.searchtf.layer.borderColor = apppurple.cgColor
            
            self.navbar.layer.masksToBounds = false
            self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
            self.navbar.layer.shadowOpacity = 0.3
            self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            self.navbar.layer.shadowRadius = 2.5
            
            self.setPaddingView(strImgname: "Search", txtField: self.searchtf)
            
        }
        
    }
    func createLabels (){
        
        self.LabelArr.removeAll()
        self.buttonArr.removeAll()
        self.labelview.removeAll()
        
        self.imgpost.subviews.forEach{
            $0.removeFromSuperview()
        }
        for frameCount in 0..<data.count{
            
            let label = UILabel(frame: CGRect(x: ((CGFloat(NumberFormatter().number(from: data[frameCount]["relativex"]! )!)*self.imgpost.frame.size.height)/100), y: ((CGFloat(NumberFormatter().number(from: (data[frameCount]["relativey"] )!)!))*self.imgpost.frame.size.width)/100, width: 60 , height: 30))
            
            label.backgroundColor = UIColor.black
            label.alpha = 0.6
            label.font = UIFont(name: "Avenir-Light", size: 11.0)
            
            label.font = UIFont.systemFont(ofSize: 9)
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            label.text = tagname[frameCount]
            self.imgpost.addSubview(label)
            var crossbtn = UIButton()
            crossbtn = UIButton(frame: CGRect(x: (Int(label.frame.origin.x + 50)) , y: (Int(label.frame.origin.y - 8))  , width: 20, height: 20))
            crossbtn.tag = frameCount
           
            crossbtn.backgroundColor = UIColor.clear
            let myImage = UIImage(named: "cross 30")
            
            crossbtn.setBackgroundImage(myImage, for: .normal)
            crossbtn.addTarget(self, action: #selector(self.deletelbl(sender:)), for: .touchUpInside)
            self.imgpost.addSubview(crossbtn)
            self.LabelArr.append(label)
            self.buttonArr.append(crossbtn)
            self.labelview.append(label)
        }
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.createLabels()
            }
    
    var pointx = Int()
    var pointy = Int()
    
    func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        print("tapped")
        if tapGesture.state == UIGestureRecognizerState.recognized
        {
            print(tapGesture.location(in: tapGesture.view))
            let point = tapGesture.location(in: tapGesture.view)
            pointx = Int(point.x)
            pointy = Int(point.y)
            self.whoIsThis.frame = CGRect(x: pointx - 40  , y: pointy - 18, width: 80 , height: 50)
            self.whoIsThis.isHidden = false
            self.imgpost.addSubview(self.whoIsThis)
            animate()
        }
    }
    
    func animate(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.searchtf.isHidden = false
                self.searchtf.alpha = 1
                self.searchtf.becomeFirstResponder()
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func animate1(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.searchtf.isHidden = true
                self.searchtf.alpha = 0
                self.searchtf.resignFirstResponder()
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    func setPaddingView(strImgname: String,txtField: UITextField){
        let imageView = UIImageView(image: UIImage(named: strImgname))
        imageView.frame = CGRect(x: -5, y: 0, width: 20 , height: 20)
        let paddingView: UIView = UIView.init(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        paddingView.addSubview(imageView)
        txtField.rightViewMode = .always
        txtField.rightView = paddingView
        searchtf.delegate = self
    }
    
    
    
    @IBAction func search(_ sender: UITextField) {
        
        guard sender.text?.isEmpty == false else{
            DispatchQueue.main.async {
                self.whoIsThis.removeFromSuperview()
                self.imgpost.isHidden = false
                self.tableview.isHidden = true
            }
            return
        }
        
        
        self.filteredData = self.FollowingPersonsData.filter{
            $0.getUsername().lowercased().contains(sender.text!.lowercased())
        }
        
        DispatchQueue.main.async {
            self.imgpost.isHidden = true
            self.tableview.isHidden = false
            
            self.tableview.reloadData()
            
        }
        print(filteredData)
    }
    
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        _=navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var searchtf: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    var profile_image1 = NSArray()
    var profile_name = NSArray()
    var serachuserid1 = NSArray()
    
    
    
    
    
    
    func saerchPeople(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let userId = standard.value(forKey: "user_id") as? String ?? ""
        let parameter: Parameters = ["action":"search_my_userlist","userid":userId , "search" : "\(searchtf.text!)" ,"follow_following_status" : "1" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: "No user found")
                print("failure")
                animationView.pause()
                animationView.removeFromSuperview()
                
                
                
                return
            }
            
            let  profilename1 = ((json["result"]["user_details"].arrayValue).map({$0["display_name"].stringValue}))
            let   profile_image = ((json["result"]["user_details"].arrayValue).map({$0["profile_image"].stringValue}))
            
            let  search_id = ((json["result"]["user_details"].arrayValue).map({$0["user_id"].stringValue}))
            
            self.profile_name = profilename1 as NSArray
            self.profile_image1 = profile_image as NSArray
            self.serachuserid1 = search_id as NSArray
            animationView.pause()
            animationView.removeFromSuperview()
            print("success")
            DispatchQueue.main.async {
                self.imgpost.isHidden = true
                self.tableview.isHidden = false
                
                self.tableview.reloadData()
                
            }
            
            
            
        }
    }
    func FolloweinglistApi(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"following_list","userid": "\(standard.value(forKey: "user_id")!)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "random_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                // self.showalertview(messagestring: "Error")
                //  self.showalertview(messagestring: "No user follows you yet")
                // print("failure")
                animationView.pause()
                animationView.removeFromSuperview()
                
                return
            }
            
            
            
            
            let   profile_image1 = ((json["result"]["following_list"].arrayValue).map({$0["profile_image"].stringValue}))
            let   display_name1 = ((json["result"]["following_list"].arrayValue).map({$0["display_name"].stringValue}))
            let   user_id1 = ((json["result"]["following_list"].arrayValue).map({$0["user_id"].stringValue}))
            
            
            for i in 0..<profile_image1.count{
                self.FollowingPersonsData.append(PointOnPostModel.init(with: user_id1[i], userImg: profile_image1[i], userName: display_name1[i]))
            }
            
            self.filteredData = self.FollowingPersonsData
            animationView.pause()
            animationView.removeFromSuperview()
            print("success")
            DispatchQueue.main.async {
                
            }
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchTableViewCell
        cell.namelbl.text = filteredData[indexPath.row].getUsername()
        cell.img.sd_setImage(with: URL(string: (filteredData[indexPath.item].getUserImage())), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
        return cell
        
    }
    
    
    
    
    
    var LabelArr = [UILabel]()
    var buttonArr = [UIButton]()
    var frame = [Int]()
    
    
    
    
    
    var const = 0
    var labelview = [UILabel]()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = self.filteredData[indexPath.row].getUsername()
        let id = self.filteredData[indexPath.row].getUserId()
        
        self.searchtf.text = ""
        self.tagname.append(name)
        self.userid.append(id)
        DispatchQueue.main.async {
            self.imgpost.isHidden = false
            self.tableview.isHidden = true
            let label = UILabel(frame: CGRect(x: self.pointx , y: self.pointy, width: 60 , height: 30))
            let x = String(describing: (label.frame.origin.x/self.imgpost.frame.width)*100)
            let y = String(describing: (label.frame.origin.y/self.imgpost.frame.height)*100)
            let framedata = ["relativex": x,"relativey": y ]
            self.data.append(framedata)
            
            //label.center = CGPoint(x: 160, y: 285)
            label.backgroundColor = UIColor.black
            label.alpha = 0.6
            label.font = UIFont(name: "Avenir-Light", size: 11.0)
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            label.text = name
            self.labelview.append(label)
            self.whoIsThis.removeFromSuperview()
            self.imgpost.addSubview(label)
            var crossbtn = UIButton()
            crossbtn = UIButton(frame: CGRect(x: (Int(label.frame.origin.x + 50)) , y: (self.pointy - 8) , width: 20, height: 20))
            crossbtn.tag = self.buttonArr.count - 1
            
            crossbtn.backgroundColor = UIColor.clear
            let myImage = UIImage(named: "cross 30")
            
            crossbtn.setBackgroundImage(myImage, for: .normal)
            crossbtn.addTarget(self, action: #selector(self.deletelbl(sender:)), for: .touchUpInside)
            self.imgpost.addSubview(crossbtn)
            
            self.LabelArr.append(label)
            self.buttonArr.append(crossbtn)
            
            self.animate1()
            
        }
        
    }
    
    
    func deletelbl(sender:UIButton){
        let index = sender.tag
        self.data.remove(at: index)
        sender.removeFromSuperview()
        var lbl = self.labelview[index]
        lbl.removeFromSuperview()
        self.tagname.remove(at: index)
        self.userid.remove(at: index)
        DispatchQueue.main.async {
            self.createLabels()
        }
    }

    func detectFaces() {
        guard let personciImage = CIImage(image: imgpost.image!) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        // For converting the Core Image Coordinates to UIView Coordinates
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            
            print("Found bounds are \(face.bounds)")
            
            // Apply the transform to convert the coordinates
            var faceViewBounds = face.bounds.applying(transform)
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = imgpost.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceBox = UIView(frame: faceViewBounds)
            
            faceBox.layer.borderWidth = 1
            faceBox.layer.borderColor = UIColor.white.cgColor
            faceBox.backgroundColor = UIColor.clear
            
            DispatchQueue.main.async {
                self.imgpost.addSubview(faceBox)
            }
            
            
            if face.hasLeftEyePosition {
                // print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                // print("Right eye bounds are \(face.rightEyePosition)")
            }
        }
    }
}
