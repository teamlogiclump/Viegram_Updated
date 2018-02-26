//
//  HomeViewController.swift
//  Viegram
//
//  Created by Apple on 5/24/17.
//  Copyright © 2017 Relinns. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import AVKit
import AVFoundation
import MMPlayerView
import JPVideoPlayer
import DZNEmptyDataSet
public enum kJPVideoPlayerDemoScrollDerection: Int {
    case none
    case up // scroll up.
    case down // scroll down.
}
let screenSize = UIScreen.main.bounds.size
class HomeViewController: UIViewController , del, RepostviewcontrollerDelegate{
    var showLoader: (apiCall: Bool,lastcell:Bool) = (false,true)
    
    var arrayModel = [TimeLineModel]()
    var observer:Any!
    var errString = "Loading"
    var playingCell : HomeTableViewCell?
    var currentDerection = kJPVideoPlayerDemoScrollDerection.none
    var playingIndex : IndexPath?
    lazy var tableViewRange : UIView = self.generateTableViewRange()
    var flagView: flagPost?
    let generateTableViewRange = { () -> UIView in
        let tableViewRange = UIView(frame: CGRect(x: 0, y: 64, width: screenSize.width, height: screenSize.height-64))
        tableViewRange.isUserInteractionEnabled = false
        tableViewRange.backgroundColor = UIColor.clear
        tableViewRange.isHidden = true
        
        return tableViewRange
    }
    
    lazy var dictOfVisiableAndNotPlayCells: Dictionary<String, Int> = {
        return ["4" : 1, "3" : 1, "2" : 0]
    }()
    
    // The number of cells cannot stop in screen center.
    var maxNumCannotPlayVideoCells: Int {
        let radius = screenSize.height / 200
        let maxNumOfVisiableCells = Int(ceilf(Float(radius)))
        if maxNumOfVisiableCells >= 3 {
            return dictOfVisiableAndNotPlayCells["\(maxNumOfVisiableCells)"]!
        }
        return 0
    }
    
    var offsetY_last : CGFloat = 0.0
    
    //
    
    @IBOutlet weak var emptyhome: UIView!
    var circularview:CircularMenu?
    @IBOutlet weak var viewdigit1: UIView!
    @IBOutlet weak var viewdigit2: UIView!
    @IBOutlet weak var viewdigit3: UIView!
    @IBOutlet weak var viewdigit4: UIView!
    @IBOutlet weak var viewdigit5: UIView!
    @IBOutlet weak var viewdigit6: UIView!
    @IBOutlet weak var viewdigit7: UIView!
    @IBOutlet weak var viewdigit8: UIView!
    @IBOutlet weak var viewdigit9: UIView!
    
    var first = true
    var postidNoti = String()
    var points = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navView: UIView!
    var abc = Int()
    var offset = Int()
    var totalOffset = Int()
    @IBOutlet weak var homepopupimg: UIImageView!
    
    let  refreshControl = UIRefreshControl()
    
    //AVplayer
    var avPlayer: AVPlayer!
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var videoURLs = Array<URL>()
    
    // SQLite DB
    var sqliteDataArr = false
    
    // MARK: -  viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyhome.isHidden = true
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.currentpage = 1
        self.setuptableview()
        
        arrayModel = DBManager.shared.loadTimeLine()
        if abc == 1 {
            self.DeleteFlagApi()
        }
        if photoposted == true {
            self.DeleteFlagApi()
        }
        if abc == 1 {
            circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
            
            self.view.addSubview(circularview!)
            self.opcatityview.isHidden = true
            self.popupview.isHidden = true
            crossbtn.isHidden = true
            homepopupimg.isHidden = true
            self.repostimview.isHidden = true
            // self.emptyhome.isHidden = true
            self.repostview.isHidden = true
            
        }else if abc == 2{
            self.opcatityview.isHidden = false
            self.opcatityview.layer.opacity = 0.7
            self.popupview.isHidden = false
            crossbtn.isHidden = false
            homepopupimg.isHidden = false
            //  self.emptyhome.isHidden = true
            self.repostimview.isHidden = true
            self.repostview.isHidden = true
            self.DeleteFlagApi()
        }else {
            self.opcatityview.isHidden = true
            self.popupview.isHidden = true
            crossbtn.isHidden = true
            homepopupimg.isHidden = true
            self.repostimview.isHidden = true
            self.opcatityview.layer.opacity = 0.7
            self.repostview.isHidden = true
            // self.emptyhome.isHidden = true
            circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
            self.view.addSubview(circularview!)
        }
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160
        self.addshodow(view: self.navView, radius: 3, opacity: 0.3)
        // Do any additional setup after loading the view.
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action:  #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 20, y: self.view.frame.size.height/2 - 20, width: 40, height: 40)
        visibleIP = IndexPath.init(row: 0, section: 0)
        //        displayTableViewRange()
    }
    func setuptableview(){
        for i in 0..<arrayModel.count{
            sqliteDataArr = true
            self.arrWidth.add(arrayModel[i].image_width)
            self.arrHeight.add(arrayModel[i].image_height)
            self.post_points.add(arrayModel[i].post_points)
            self.PhotoArr.add(arrayModel[i].photo)
            self.DisplayName.add(arrayModel[i].display_name)
            self.timeArr.add(arrayModel[i].time_ago)
            self.profileImgArr.add(arrayModel[i].profile_image)
            self.captionArr.add(arrayModel[i].caption)
            self.guestuser_id.add(arrayModel[i].second_userid)
            self.postlike.add(arrayModel[i].post_like)
            self.post_type.add(arrayModel[i].post_type)
            self.post_id.add(arrayModel[i].post_id)
            self.second_userid.add(arrayModel[i].second_userid)
            self.second_name.add(arrayModel[i].second_name)
            self.file_type.add(arrayModel[i].file_type)
            self.video1.add(arrayModel[i].video)
            self.multiple_images.append(arrayModel[i].multiple_images)
            self.x_cord.append(arrayModel[i].x_cord)
            self.y_cord.append(arrayModel[i].y_cord)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if playingCell == nil {
            // Find the first cell need to play video in visiable cells.
            playVideoInVisiableCells()
        }
        else{
            //            if playingCell?.fileTypeImage == false {
            //                let url = URL(string: (playingCell?.videoPath)!)
            //                playingCell?.imgPost.jp_playVideoHiddenStatusView(with: url)
            //            }
        }
        //        tableViewRange.isHidden = false
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        paused = true
        
        //        tableViewRange.isHidden = true
        
        if (playingCell != nil) {
            playingCell?.imgPost.jp_stopPlay()
            playingCell?.playbutton.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
        }
    }
    
    func refreshtable() {
        
        self.refreshControl.beginRefreshing()
        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
        
        self.currentpage = 1
        self.DeleteFlagApi()
//        self.emptyArr()
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        //end refersh on api response
        refreshtable()
        
    }
    func createIndexPath(sender:UIView,superView:UITableView) -> IndexPath?{
        let point = sender.convert(CGPoint.zero, to: superView)
        return superView.indexPathForRow(at: point)
    }
    
    func alert(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.fetchdetails(page: currentpage)

        
        if photoposted == false {
            
            self.refreshtable()
            photoposted = true
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
    
    override func viewDidLayoutSubviews() {
        if first == true {
            first = false
            self.setGradientBackground(view: viewdigit1)
            self.setGradientBackground(view: viewdigit2)
            self.setGradientBackground(view: viewdigit3)
            self.setGradientBackground(view: viewdigit4)
            self.setGradientBackground(view: viewdigit5)
            self.setGradientBackground(view: viewdigit6)
            self.setGradientBackground(view: viewdigit7)
            self.setGradientBackground(view: viewdigit8)
            self.setGradientBackground(view: viewdigit9)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.playingCell != nil {
            playingCell?.imgPost.jp_stopPlay()
            playingCell?.playbutton.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
            playingCell?.isPlaying = "stopped"
        }
    }
    
    
    //MARK: - Memory WArning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    }
    // MARK: -  Likebtn
    @IBAction func likeAction(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexpath = self.tableView.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let postPoint = post_points[indexpath.row] as! String
        let status = postlike[indexpath.row] as! String
        let string = postPoint
        let post_id = (self.repost_id[indexpath.row] as! String)
        let guestId = (self.guestuser_id[indexpath.row] as! String)
        LikeApicall(postid: post_id, postuserID: guestId)
        let guest_id = (self.guestuser_id[indexpath.row] as! String)
//        if file_type[indexpath.row] as! String == "image" {
            let cell = self.tableView.cellForRow(at: indexpath) as! HomeTableViewCell
            if guest_id != standard.value(forKey: "user_id") as! String{
                if let number = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                    if  status == "0"{
                        cell.lbl_points.text = "\(number + 10 ) points"
                        postlike[indexpath.row] = "1"
                        post_points[indexpath.row] = "\(number + 10 ) points"
                    }
                    else{
                        if number > 0 {
                            cell.lbl_points.text = "\(number - 10 ) points"
                            postlike[indexpath.row] = "0"
                            post_points[indexpath.row] = "\(number - 10 ) points"
                        }
                    }
                }
            }else{
                if let number = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                    if  status == "0"{
                        postlike[indexpath.row] = "1"
                    }
                    else{
                        if number > 0 {
                            postlike[indexpath.row] = "0"
                        }
                    }
                }
            }
            if sender.imageView?.image == #imageLiteral(resourceName: "imgLike") {
                sender.setImage(#imageLiteral(resourceName: "imgLikeFilled"), for: .normal)
                sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: 1.0,
                               delay: 0,
                               usingSpringWithDamping: 0.2,
                               initialSpringVelocity: 5.0,
                               options: .curveEaseOut,
                               animations: {
                                sender.transform = .identity
                },
                               completion: {
                                action in
                                print ("complete")
                })
            }else{
                sender.setImage(#imageLiteral(resourceName: "imgLike"), for: .normal)
            }
            
            
//        }
//        else{
//            let cell = self.tableView.cellForRow(at: indexpath) as! VideoCellTableViewCell
//            if guest_id != standard.value(forKey: "user_id") as! String{
//                if let number = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
//                    if  status == "0"{
//                        cell.lbl_points.text = "\(number + 10 ) points"
//                        postlike[indexpath.row] = "1"
//                        post_points[indexpath.row] = "\(number + 10 ) points"
//                    }
//                    else{
//                        if number > 0 {
//                            cell.lbl_points.text = "\(number - 10 ) points"
//                            postlike[indexpath.row] = "0"
//                            post_points[indexpath.row] = "\(number - 10 ) points"
//                        }
//                    }
//                }
//            }else{
//                if let number = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
//                    if  status == "0"{
//                        postlike[indexpath.row] = "1"
//                    }
//                    else{
//                        if number > 0 {
//                            postlike[indexpath.row] = "0"
//                        }
//                    }
//                }
//            }
//            if sender.imageView?.image == #imageLiteral(resourceName: "imgLike") {
//                sender.setImage(#imageLiteral(resourceName: "imgLikeFilled"), for: .normal)
//                sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//                UIView.animate(withDuration: 1.0,
//                               delay: 0,
//                               usingSpringWithDamping: 0.2,
//                               initialSpringVelocity: 5.0,
//                               options: .curveEaseOut,
//                               animations: {
//                                sender.transform = .identity
//                },
//                               completion: {
//                                action in
//                                print ("complete")
//                })
//            }else{
//                sender.setImage(#imageLiteral(resourceName: "imgLike"), for: .normal)
//            }
//        }
        
    }
    // MARK: -  commentbtn
    @IBAction func commentAction(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexpath = self.tableView.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let post_id = (self.repost_id[indexpath.row] as! String)
        let guest_id = (self.guestuser_id[indexpath.row] as! String)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
        vc.repostid = post_id
        vc.guest_id = guest_id
        
        vc.indexPath = indexpath
        vc.points = post_points[indexpath.row] as! String
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func flagAction(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexpath = self.tableView.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let repost_id = (self.repost_id[indexpath.row] as! String)
        var post_id = (self.post_id[indexpath.row] as! String)
        
        if ( post_id is NSNull)
        {
            
            post_id = ""
            //do your stuff
        }
        
       
        let post_type = (self.post_type[indexpath.row] as! String)
        //        let guestId = (self.guestuser_id[indexpath.row] as! String)
        //        var second_userid = (self.second_userid[indexpath.row] as! String)
        if post_type != "repost post" {
            post_id = repost_id
            //            second_userid = guestId
        }
        self.flagView = flagPost.init(frame: self.view.bounds, postId: post_id, index: indexpath,messageTitle:"Do you want to report this post as inappropriate?",successTitle:"REPORT",image:"imgReport")
        flagView?.delegate = self
        self.view.addSubview(self.flagView!)
    }
    // protocal method
    func refreshtimeline()
    {
        self.refreshtable()

       // self.fetchdetails(page: currentpage)
    }
    
    @IBAction func repostAction(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexpath = self.tableView.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let repost_id = (self.repost_id[indexpath.row] as! String)
        let post_id = (self.post_id[indexpath.row] as! String)
        let post_type = (self.post_type[indexpath.row] as! String)
        let guestId = (self.guestuser_id[indexpath.row] as! String)
        let second_userid = (self.second_userid[indexpath.row] as! String)
        var dict = [String:Any]()
        if post_type == "repost post" {
            dict["post_id"] = post_id
            dict["postUserId"] = second_userid
            
        }else {
            dict["post_id"] = repost_id
            dict["postUserId"] = guestId
        }
        dict["postimage"] = self.PhotoArr[indexpath.row] as! String
        dict["filetype"] = self.file_type[indexpath.row] as! String
        dict["video"] = self.video1[indexpath.row] as! String
        dict["imgWidth"] = self.arrWidth[indexpath.row] as? Int
        dict["imgHeight"] = self.arrHeight[indexpath.row] as? Int
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepostViewController") as! RepostViewController
        vc.data = dict
        vc.delegates = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func animate(){
        self.opcatityview.isHidden = false
        self.repostview.isHidden = false
        self.repostimview.isHidden = false
        self.opcatityview.alpha = 0
        self.repostview.alpha = 0
        self.repostimview.alpha = 0
        
        UIView.animate(withDuration: 2) { () -> Void in
            self.repostview.alpha = 1
            self.repostimview.alpha = 1
            
            self.opcatityview.alpha = 0.7
            
            self.view.layoutIfNeeded()
        }
    }
    
    func setGradientBackground(view:UIView) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
        //gradientLayer.locations = [ 0.0,0.25,0.50, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addshodow(view:UIView,radius:CGFloat,opacity:Float){
        //code to add shadow to views
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = radius
    }
    
    
    
    @IBOutlet weak var repostview: UIView!
    @IBOutlet weak var repostimg: UIImageView!
    @IBAction func cancel(_ sender: UIButton) {
        circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        self.view.addSubview(self.circularview!)
        
        self.opcatityview.isHidden = true
        self.repostview.isHidden = true
        self.repostimview.isHidden = true
    }

    // MARK: -  Repost
    @IBAction func repost(_ sender: UIButton)
    {
        
        
    }
    
    @IBOutlet weak var repostimview: UIImageView!
    @IBOutlet weak var crossbtn: UIButton!
    @IBOutlet weak var opcatityview: UIView!
    @IBOutlet weak var popupview: UIView!
    
    @IBAction func crossbtn(_ sender: UIButton) {
        self.opcatityview.isHidden = true
        self.popupview.isHidden = true
        self.homepopupimg.isHidden = true
        sender.isHidden = true
        if self.abc == 2 {
            
            circularview = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
            
            self.view.addSubview(circularview!)
        }

    }
    
    
    
    @IBOutlet var scorelbls: [UILabel]!
    
    var seektime = [Float]()
    var PhotoArr = NSMutableArray()
    var DisplayName = NSMutableArray()
    var timeArr = NSMutableArray()
    var profileImgArr = NSMutableArray()
    var captionArr = NSMutableArray()
    var repost_id = NSMutableArray()
    var guestuser_id = NSMutableArray()
    var postlike = NSMutableArray()
    var post_points = NSMutableArray()
    var post_type = NSMutableArray()
    var post_id = NSMutableArray()
    var second_userid = NSMutableArray()
    var second_name = NSMutableArray()
    var file_type = NSMutableArray()
    var location = NSMutableArray()
    var arrHeight = NSMutableArray()
    var arrWidth = NSMutableArray()
    var video1 = NSMutableArray()
    var multiple_images = [String]()
    var x_cord = [String]()
    var y_cord = [String]()
    
    func removeIndexArr(index: Int) {
        PhotoArr.removeObject(at: index)
        DisplayName.removeObject(at: index)
        timeArr.removeObject(at: index)
        profileImgArr.removeObject(at: index)
        captionArr.removeObject(at: index)
        repost_id.removeObject(at: index)
        guestuser_id.removeObject(at: index)
        postlike.removeObject(at: index)
        post_points.removeObject(at: index)
        post_type.removeObject(at: index)
        post_id.removeObject(at: index)
        second_userid .removeObject(at: index)
        second_name.removeObject(at: index)
        file_type.removeObject(at: index)
        arrHeight.removeObject(at: index)
        arrWidth.removeObject(at: index)
        mainArr.removeObject(at: index)
        tagpersons.removeObject(at: index)
        displayname.remove(at: index)
        multiple_images.remove(at: index)
        x_cord.remove(at: index)
        y_cord.remove(at: index)
        video1.remove(at: index)
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.reloadData()
            })
            
        }
    }
    
    func emptyArr() {
        PhotoArr.removeAllObjects()
        DisplayName.removeAllObjects()
        timeArr.removeAllObjects()
        profileImgArr.removeAllObjects()
        captionArr.removeAllObjects()
        repost_id.removeAllObjects()
        guestuser_id.removeAllObjects()
        postlike.removeAllObjects()
        post_points.removeAllObjects()
        post_type.removeAllObjects()
        post_id.removeAllObjects()
        second_userid .removeAllObjects()
        second_name.removeAllObjects()
        file_type.removeAllObjects()
        arrHeight.removeAllObjects()
        arrWidth.removeAllObjects()
        mainArr.removeAllObjects()
        tagpersons.removeAllObjects()
        displayname.removeAll()
        _Xpos.removeAll()
        _Ypos.removeAll()
        multiple_images.removeAll()
        x_cord.removeAll()
        y_cord.removeAll()
        video1.removeAllObjects()
        self.seektime.removeAll()
    }
    
    // MARK:- tag people data
    var mainArr = NSMutableArray()
    var tagpersons = NSMutableArray()
    var displayname = [String]()
    var _Xpos = [CGFloat]()
    var _Ypos = [CGFloat]()
    
    
    var arrayTagPeople = [Bool]()
    //var VideoArr =  [Bool]()
    var currentpage = 1
    
    
    func DeleteFlagApi(){
//        let params :Parameters = ["action": "delete_flagpost","userid":(standard.value(forKey: "user_id") as? String) ?? ""]
//        animationView.play()
//        animationView.loopAnimation = true
//        Api.requestPOST(mainurl + "content_object.php", params: params, headers: [:], success: { (json, statuscode) in
//            
//            print(json)
//            
//            guard json["response"]["msg"].stringValue == "201" else{
//                DispatchQueue.main.async {
//                    animationView.pause()
//                    animationView.removeFromSuperview()
//                }
//                
//                return
//            }
//            
//            DispatchQueue.main.async {
//                animationView.pause()
//                animationView.removeFromSuperview()
                self.fetchdetails(page : self.currentpage)
//            }
//            //            self.removeIndexArr(index: index.row)
//        }) { (error) in
//            animationView.pause()
//            animationView.removeFromSuperview()
//        }
    }
    
    // MARK:- Fetch Details API
    func fetchdetails(page:Int){
        
        let parameter: Parameters = ["action":"fetch_timeline","userid": "\(standard.value(forKey: "user_id")!)" , "page": "\(page)"]
        print(parameter)
        self.showLoader.apiCall = true
        print(mainurl + "timeline_object.php")
        Alamofire.request(mainurl + "timeline_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                DispatchQueue.main.async {
                    
                    if self.refreshControl.isRefreshing == true {
                        self.refreshControl.endRefreshing()
                    }
                    self.nofollow = true
                    self.errString = response.error?.localizedDescription ?? "Network error"
                    self.showLoader.apiCall = false
                    self.tableView.reloadData()
                }
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            self.showLoader.apiCall = false
            guard (json["result"]["msg"] .intValue) == 201 else {
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing == true {
                        self.refreshControl.endRefreshing()
                    }
                    self.errString = "Seems like there are no posts on your timeline.\nFollow people to see their posts."
                    if (json["result"]["reason"] .stringValue) ==  "You have no following yet" || (json["result"]["reason"] .stringValue) ==  "No post is upload in viegram yet" {
                        self.nofollow = true
                    }
                    self.showLoader.lastcell = false
                    self.tableView.reloadData()
                }
                return
            }
            DispatchQueue.main.async {
                
                if self.refreshControl.isRefreshing == true {
                    self.refreshControl.endRefreshing()
                    
                    self.emptyArr()
                }
                if self.sqliteDataArr == true {
                    self.emptyArr()
                    self.sqliteDataArr = false
                }
                self.totalOffset = ((json["result"]["total_records"].intValue))
                let imgurls = (((json["result"]["timeline_posts"]).arrayValue).map({$0["photo"].stringValue}))
                let video = (((json["result"]["timeline_posts"]).arrayValue).map({$0["video"].stringValue}))
                let DNames = (((json["result"]["timeline_posts"]).arrayValue).map({$0["display_name"].stringValue}))
                let timeArr1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["time_ago"].stringValue}))
                let profileImgArr1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["profile_image"].stringValue}))
                let captionArr1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["caption"].stringValue}))
                let repost_id1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["repost_id"].stringValue}))
                let post_id1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["post_id"].stringValue}))
                let guest_id1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["userid"].stringValue}))
                let second_userid1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["second_userid"].stringValue}))
                let second_name1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["first_display_name"].stringValue}))
                let post_like = (((json["result"]["timeline_posts"]).arrayValue).map({$0["post_like"].stringValue}))
                let post_points1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["post_points"].stringValue}))
                let post_type1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["post_type"].stringValue}))
                let file_type1 = (((json["result"]["timeline_posts"]).arrayValue).map({$0["file_type"].stringValue}))
                let location = (((json["result"]["timeline_posts"]).arrayValue).map({$0["location"].stringValue}))
                let tagpeople = ((((json["result"]["timeline_posts"]).arrayValue).map({$0["tag_people"].arrayObject})))
                let multipleImages = ((((json["result"]["timeline_posts"]).arrayValue).map({$0["multiple_images"].stringValue })))
                let x_cord = ((((json["result"]["timeline_posts"]).arrayValue).map({$0["x_cord"].stringValue})))
                let y_cord = ((((json["result"]["timeline_posts"]).arrayValue).map({$0["y_cord"].stringValue})))
                for _ in tagpeople{
                    self.arrayTagPeople.append(false)
                }
                
                let imgWidth = (((json["result"]["timeline_posts"]).arrayValue).map({$0["image_width"].intValue}))
                let imgHeight = (((json["result"]["timeline_posts"]).arrayValue).map({$0["image_height"].intValue}))
                
                
                self.arrWidth.addObjects(from: imgWidth)
                self.arrHeight.addObjects(from: imgHeight)
                self.location.addObjects(from: location)
                self.tagpersons.addObjects(from: tagpeople)
                self.post_points.addObjects(from: post_points1)
                self.PhotoArr.addObjects(from: imgurls)
                self.DisplayName.addObjects(from: DNames)
                self.timeArr.addObjects(from: timeArr1)
                self.profileImgArr.addObjects(from: profileImgArr1)
                self.captionArr.addObjects(from: captionArr1)
                self.repost_id.addObjects(from: repost_id1)
                self.guestuser_id.addObjects(from: guest_id1)
                self.postlike.addObjects(from: post_like)
                self.post_type.addObjects(from: post_type1)
                self.post_id.addObjects(from: post_id1)
                self.second_userid.addObjects(from: second_userid1)
                self.second_name.addObjects(from: second_name1)
                self.file_type.addObjects(from: file_type1)
                self.video1.addObjects(from: video)
                self.multiple_images.append(contentsOf: multipleImages)
                self.x_cord.append(contentsOf: x_cord)
                self.y_cord.append(contentsOf: y_cord)
                for _ in 0..<self.PhotoArr.count{
                    self.seektime.append(0.0)
                }
                
                if standard.value(forKey: "data") as? String == "false" && self.currentpage == 1 {
                    _ = DBManager.shared.deleteTimeLine()
                    for index in 0..<post_type1.count {
                        
                        if index < 15 {
                            let isSucess = DBManager.shared.insertData(profile_image1: self.profileImgArr[index] as! String, post_id1: self.repost_id[index] as! String, userid1: self.guestuser_id[index] as! String, second_userid1: self.second_userid[index] as! String, post_like1: self.postlike[index] as! String, location1: self.location[index] as? String ?? "", first_display_name1: self.DisplayName[index] as! String, post_points1: self.post_points[index] as! String, first_user_profile_image1: self.profileImgArr[index] as! String, caption1: self.captionArr[index] as! String, date_time1: "", time_ago1: self.timeArr[index] as! String, post_type1: self.post_type[index] as! String, image_width1: "\(self.arrWidth[index])", display_name1: self.DisplayName[index] as! String, photo1: self.PhotoArr[index] as! String, first_caption1: self.captionArr[index] as! String, image_height1: "\(self.arrHeight[index])", file_type1: self.file_type[index] as! String, second_name1:  self.second_name[index] as! String , video1: self.video1[index] as! String, multiple: self.multiple_images[index] , xcord: self.x_cord[index], ycord: self.y_cord[index]  )
                            print(isSucess)
                        }
                        standard.set("true", forKey: "data")
                    }
                }
                self.currentpage += 1
                DispatchQueue.main.async {
                    let scoreStr = (json["result"]["total_score"].stringValue)
                    standard.setValue(scoreStr, forKey: "overall")
                    print(scoreStr)
                    let characters1 = scoreStr.characters
                    let reversedCharacters = characters1.reversed()
                    let reversedString = String(reversedCharacters)
                    let characters = [Character](reversedString.characters)
                    for  i in 0..<scoreStr.characters.count {
                        let label:UILabel = self.scorelbls[i]
                        label.text = String(characters[i])
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.nofollow = false
            print("success")
        }
        
    }
    var nofollow = Bool()
    
    func Anotheruserprofile(userid2: String){
        // self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
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
                animationView.pause()
                animationView.removeFromSuperview()
                
                
                
                return
            }
            
            let user_id = ((json["result"]["details"]["user_id"].stringValue))
            let scorepoint = ((json["result"]["details"]["scorepoint"].stringValue))
            let link = ((json["result"]["details"]["link"].stringValue))
            let privacy_status = ((json["result"]["details"]["privacy_status"].stringValue))
            let profile_image1 = ((json["result"]["details"]["profile_image"].stringValue))
            let bio_data = ((json["result"]["details"]["bio_data"].stringValue))
            let cover_image1 = ((json["result"]["details"]["cover_image"].stringValue))
            let follower_status = ((json["result"]["details"]["follower_status"].stringValue))
            let full_name = ((json["result"]["details"]["full_name"].stringValue))
            let display_name = ((json["result"]["details"]["display_name"].stringValue))
            
            let post_id = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["post_id"].stringValue})))
            let photo = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["photo"].stringValue})))
            let type = ((((json["result"]["details"]["posts"]).arrayValue).map({$0["type"].stringValue})))
            
            //self.delegate1?.data(user_id: user_id, scorepoint: scorepoint, link: link, privacy_status: privacy_status, profile_image: profile_image, bio_data: bio_data, cover_image: cover_image, follower_status: follower_status, post_id: post_id as NSArray, photo: photo as NSArray ,fullname:full_name , Displayname: display_name )
            
            print("success")
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
            vc.cover_image = cover_image1
            vc.profile_image = profile_image1
            vc.fullname = full_name
            vc.displayname1 = display_name
            vc.scorepoint = scorepoint
            vc.link  = link
            vc.bio_data = bio_data
            vc.privacy_status = privacy_status
            vc.guest_id = user_id
            vc.followStatus = follower_status
            vc.postId = post_id as NSArray
            vc.postimageArr = photo as NSArray
            vc.type1 = type as NSArray
            self.navigationController?.pushViewController(vc, animated: true)
            animationView.pause()
            animationView.removeFromSuperview()
        }
        
    }
    
    
    func LikeApicall(postid: String ,postuserID : String){
        // self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"like_post", "liked_userid":"\(standard.value(forKey: "user_id")!)", "postid":"\(postid)" , "post_userid" : "\(postuserID)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "post_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                animationView.pause()
                animationView.removeFromSuperview()
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: "Error")
                print("failure")
                
                animationView.pause()
                animationView.removeFromSuperview()
                
                
                return
            }
            animationView.pause()
            animationView.removeFromSuperview()
            print("success")
        }
    }
    var index = String()
    var bool = Bool()
    
    func checkUser(guest_id:String){
        DispatchQueue.main.async {
            if guest_id == standard.value(forKey: "user_id") as! String{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.Anotheruserprofile(userid2: guest_id)
            }
        }
        
    }
    //tapgesture
    func tapgesture1(sender:UITapGestureRecognizer){
        // print("tap working",sender.view!.tag)
        let point = sender.location(in: self.tableView)
        guard let indexpath = self.tableView.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let guest_id = (self.guestuser_id[indexpath.row] as! String)
        print(guest_id)
        
        guard post_type[indexpath.row] as! String == "repost post" else{
            
            self.checkUser(guest_id: guest_id)
            return
        }
        let cell = self.tableView.cellForRow(at: indexpath) as! HomeTableViewCell
        
        let name1 = (DisplayName[sender.view!.tag] as! String)
        let name2 = (second_name[sender.view!.tag] as! String)
        let string = cell.lbl_username.text!
        
        let tapLocation = sender.location(in: cell.lbl_username)
        
        let index = cell.lbl_username.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        if let range = string.range(of: name1) {
            let startPos = string.distance(from: string.startIndex, to: range.lowerBound)
            let endPos = string.distance(from: string.startIndex, to: range.upperBound)
            if index > startPos && index < endPos{
                print("user tapped first id")
                self.checkUser(guest_id: self.guestuser_id[indexpath.row] as! String)
                //YES, THE TAPPED CHARACTER IS IN RANGE
            }
        }
        if let range = string.range(of: name2) {
            let startPos = string.distance(from: string.startIndex, to: range.lowerBound)
            let endPos = string.distance(from: string.startIndex, to: range.upperBound)
            if index > startPos && index < endPos{
                print("user tapped Second id")
                self.checkUser(guest_id: (second_userid[indexpath.row] as? String)!)
                //YES, THE TAPPED CHARACTER IS IN RANGE
            }
        }
        return
    }
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return PhotoArr.count + (self.showLoader.lastcell == true ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !(indexPath.row == self.PhotoArr.count && (self.showLoader.lastcell == true)) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadercell")
            let animator = cell?.viewWithTag(57) as! UIActivityIndicatorView
            animator.startAnimating()
            return cell!
            
        }
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell
        cell.videoview.isHidden = true
        
        
        if PhotoArr.count > 0 {
            // If User click notification then scroll to
            if postidNoti == post_id[indexPath.row] as! String && postidNoti != "" {
                let index =  post_id[indexPath.row] as! NSIndexPath
                self.tableView.scrollToRow(at: index as IndexPath, at: .middle, animated: true)
                bool = false
            }
            _=cell.imgPost.subviews.map({ $0.removeFromSuperview() })
            cell.selectionStyle = .none
            cell.imgPost.sd_setImage(with: URL(string: (PhotoArr[indexPath.row] as? String)!), placeholderImage: placeholder, options: SDWebImageOptions.refreshCached)
            cell.imgPost.contentMode = .scaleAspectFit
            cell.imgPost.isHidden = false
            
            if  let str = self.location[indexPath.row] as? String {
                cell.lbl_location.text = str == "null" ? "" : str
            }
            
            let width = self.arrWidth[indexPath.row] as? Int
            let height = self.arrHeight[indexPath.row] as? Int
            if (width != nil) && height != nil && (width! != 0) && (height != 0) {
                let ratio : CGFloat  = (CGFloat(width!) / CGFloat(height!))
                let screenWidth = self.view.bounds.width
                let imageheight = ((screenWidth) / (ratio))
                
                if imageheight > self.tableView.bounds.height * 0.9 {
                    cell.imgPostHeightConstraint.constant = (self.file_type[indexPath.row] as! String) == "image" ? imageheight :  self.tableView.bounds.height * 0.9
                }else{
                    cell.imgPostHeightConstraint.constant = imageheight
                }
                
            }
            _=cell.imgPost.subviews.map({ $0.removeFromSuperview() })
            let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapPerson(sender:)))
            cell.imgPost.tag = indexPath.row
            cell.imgPost.isUserInteractionEnabled = true
            cell.imgPost.addGestureRecognizer(tap)
            
            if tagpersons.count > 0 {
                let a = tagpersons[indexPath.row] as! NSArray
                for index1 in 0..<a.count{
                    if index1 == 0{
                        self.displayname.removeAll()
                        self._Xpos.removeAll()
                        self._Ypos.removeAll()
                        self.mainArr.removeAllObjects()
                    }
                    let dict = a[index1] as! NSDictionary
                    self.mainArr.add(dict)
                    print(self.mainArr)
                    let display_name = (self.mainArr[index1] as! NSDictionary).value(forKey: "display_name")
                    let positionX = (self.mainArr[index1] as! NSDictionary).value(forKey: "x_cordinates")
                    let positionY = (self.mainArr[index1] as! NSDictionary).value(forKey: "y_cordinates")
                    if display_name as? String != nil &&  positionX as? String != nil  && positionY as? String != nil{
                        if let n = NumberFormatter().number(from: positionX as! String) {
                            let fl = CGFloat(n)
                            _Xpos.append(fl)
                        }
                        if let n = NumberFormatter().number(from: positionY as! String) {
                            let fl = CGFloat(n)
                            _Ypos.append(fl)
                        }
                        displayname.append(display_name as! String)
                    }
                }
                
                print(displayname)
                if (_Xpos.count > 0) {
                    
                    for index in 0..<displayname.count {
                        let label = UILabel(frame: CGRect(x: ((_Xpos[index] )*cell.imgPost.frame.size.width)/100 , y: ((_Ypos[index] )*cell.imgPost.frame.size.width)/100, width: 60 , height: 30))
                        label.backgroundColor = UIColor.black
                        label.alpha = 0.6
                        label.font = UIFont(name: "Avenir-Light", size: 11.0)
                        label.font = UIFont.systemFont(ofSize: 13)
                        label.textColor = UIColor.white
                        label.textAlignment = NSTextAlignment.center
                        label.layer.cornerRadius = 5
                        label.layer.masksToBounds = true
                        label.text = displayname[index]
                        if self.arrayTagPeople[indexPath.row] == false {
                            label.isHidden = true
                        }else{
                            label.isHidden = false
                        }
                        cell.imgPost.addSubview(label)
                    }
                    
                }
            }
            let profileTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapProfileImage(sender:)))
            cell.imgProfilePic.tag = indexPath.row
            cell.imgProfilePic.isUserInteractionEnabled = true
            cell.imgProfilePic.addGestureRecognizer(profileTap)
            
            
            cell.imgProfilePic.sd_setImage(with: URL(string: (profileImgArr[indexPath.row] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            cell.lbl_username.text = DisplayName[indexPath.row] as? String
            cell.lbl_postTime.text = timeArr[indexPath.row] as? String
            cell.lbl_postText.text = captionArr[indexPath.row] as? String
            cell.lbl_points.text = post_points[indexPath.row] as? String
            cell.lbl_name.text = DisplayName[indexPath.row] as? String
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapFunction))
            cell.lbl_points.tag = indexPath.row
            cell.lbl_points.isUserInteractionEnabled = true
            cell.imgPost.tag = indexPath.row
            cell.imgPost.isUserInteractionEnabled = true
            cell.imgPost.addGestureRecognizer(tap)
            cell.lbl_points.addGestureRecognizer(tap1)
            cell.likeButton.setImage(postlike[indexPath.row] as? String == "1" ? #imageLiteral(resourceName: "imgLikeFilled") :#imageLiteral(resourceName: "imgLike"), for: .normal)
            
            if post_type[indexPath.row] as? String == "repost post" {
                let yourAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 13) ]
                let yourOtherAttributes = [NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
                
                let partOne = NSMutableAttributedString(string: "\(DisplayName[indexPath.row])" + " Shared ", attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: "\(second_name[indexPath.row])" + "'s post", attributes: yourOtherAttributes)
                let combination = NSMutableAttributedString()
                combination.append(partOne)
                combination.append(partTwo)
                cell.lbl_username.attributedText = combination
                
            }
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapgesture1(sender:)))
            gestureRecognizer.numberOfTapsRequired = 1;
            gestureRecognizer.numberOfTouchesRequired = 1;
            cell.lbl_username.tag = indexPath.row
            cell.lbl_username.isUserInteractionEnabled = true
            cell.lbl_username.addGestureRecognizer(gestureRecognizer);
            cell.indexPath = indexPath
            cell.videoPath = self.video1[indexPath.row] as! String
            
            var maxNumCannotPlayVideoCells: Int {
                let radius = screenSize.height / (cell.imgPostHeightConstraint.constant + 128)
                let maxNumOfVisiableCells = Int(ceilf(Float(radius)))
                if maxNumOfVisiableCells >= 3 {
                    return dictOfVisiableAndNotPlayCells["\(maxNumOfVisiableCells)"]!
                }
                return 0
            }
            if maxNumCannotPlayVideoCells>0 {
                if indexPath.row<=maxNumCannotPlayVideoCells-1 {
                    cell.cellStyle = kJPPlayUnreachCellStyle.up
                }
                else if indexPath.row>=self.video1.count-maxNumCannotPlayVideoCells {
                    cell.cellStyle = kJPPlayUnreachCellStyle.down
                }
                else{
                    cell.cellStyle = kJPPlayUnreachCellStyle.none
                }
            }
            else{
                cell.cellStyle = kJPPlayUnreachCellStyle.none
            }
            
            cell.fileTypeImage = file_type[indexPath.row] as! String != "video" ? true : false
        }
        cell.playbutton.isHidden = (file_type[indexPath.row] as? String ?? "" ) != "video" ? true : false
        cell.playbutton.tag = indexPath.row
        cell.playbutton.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
        cell.playbutton.addTarget(self, action: #selector(self.playVideo(sender:)), for: .touchUpInside)
        cell.imgPost.jp_pause()
        return cell
    }
    
    
    func playVideo(sender: UIButton) {
        
        let cell = tableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! HomeTableViewCell
        if cell.isPlaying == "stopped" {
            sender.setImage(nil, for: .normal)
            let url = URL.init(string: cell.videoPath)
            cell.imgPost.jp_playVideoHiddenStatusView(with: url)
            cell.isPlaying = "playing"
            self.playingCell = cell
        }else if cell.isPlaying == "playing"{
            sender.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
            cell.imgPost.jp_pause()
            cell.isPlaying = "pause"
        }else if cell.isPlaying == "pause"{
            sender.setImage(nil, for: .normal)
            let url = URL.init(string: cell.videoPath)
            cell.imgPost.jp_playVideoHiddenStatusView(with: url)
            cell.isPlaying = "playing"
            self.playingCell = cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.DisplayName.count - 3 && self.showLoader.apiCall == false && self.showLoader.lastcell == true{
            fetchdetails(page: currentpage)
        }
    }
    
    //tap
    func tapFunction(sender:UITapGestureRecognizer) {
        
        print("tap working",sender.view!.tag)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PointOnPostViewController") as! PointOnPostViewController
        print(self.guestuser_id[sender.view!.tag] as! String)
        vc.guestID = self.guestuser_id[sender.view!.tag] as! String
        vc.postID = self.repost_id[sender.view!.tag] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapProfileImage(sender:UITapGestureRecognizer){
        self.checkUser(guest_id: self.guestuser_id[sender.view!.tag] as? String ?? "")
    }
    
    //  tapPerson
    func tapPerson(sender:UITapGestureRecognizer) {
        
        print("tap working",sender.view!.tag)
        let point = sender.location(in: self.tableView)
        guard let indexpath = self.tableView.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let  cell = self.tableView.cellForRow(at: indexpath) as! HomeTableViewCell
        guard self.multiple_images[indexpath.row].isEmpty == true else {
            
            let pointInImage = sender.location(in: cell.imgPost)
            print("point in poinst \(pointInImage)")
            let touchableView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 75, height: 75))
            touchableView.backgroundColor = UIColor.clear
            cell.imgPost.addSubview(touchableView)
            let multipleImageIds = self.multiple_images[indexpath.row].components(separatedBy: "/,")
            let multipleXCords = self.x_cord[indexpath.row].components(separatedBy: ",")
            let multipleYCords = self.y_cord[indexpath.row].components(separatedBy: ",")
            for index in 0..<multipleImageIds.count {
                let xPoint = (CGFloat(Float(multipleXCords[index] ) ?? 0.0)*cell.imgPost.frame.size.width)/100
                print("xPoint after translation \(xPoint)")
                let yPoint = (CGFloat(Float(multipleYCords[index] ) ?? 0.0)*cell.imgPost.frame.size.height)/100
                print("yPoint after translation \(yPoint)")
                let centrePoint = CGPoint.init(x: xPoint, y: yPoint)
                print("centre point \(centrePoint)")
                touchableView.frame.origin = centrePoint
                if touchableView.frame.contains(pointInImage) {
                    print("contains")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewPhotoTourController") as! ViewPhotoTourController
                        vc.imageIds = multipleImageIds[index]
                        let dict = [
                            "profileImage": (self.profileImgArr[indexpath.row] as? String),
                            "username": self.DisplayName[indexpath.row] as? String,
                            "time": self.timeArr[indexpath.row] as? String,
                            "points": self.post_points[indexpath.row] as? String
                        ]
                        vc.postDetails = dict
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }
            
            
            return
        }
        
        
        if self.file_type[indexpath.row] as! String != "video"{
            _=cell.imgPost.subviews.map({ $0.isHidden = !$0.isHidden})
            self.arrayTagPeople[indexpath.row] = !self.arrayTagPeople[indexpath.row]
        }
    }
    
    
    
    func userProfile(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexpath = self.tableView.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let guest_id = (self.guestuser_id[indexpath.row] as! String)
        print(guest_id)
        if guest_id == standard.value(forKey: "user_id") as! String{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Anotheruserprofile(userid2: guest_id)
        }
    }
    
    func userProfile1(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexpath = self.tableView.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let guest_id = (self.second_userid[indexpath.row] as! String)
        print(guest_id)
        if guest_id == standard.value(forKey: "user_id") as! String{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Anotheruserprofile(userid2: guest_id)
        }
    }
}

extension HomeViewController{
    
    
    func playVideoInVisiableCells() {
        let visiableCells = tableView.visibleCells
        var targetCell : HomeTableViewCell?
        for c in visiableCells {
            if let cell = c as? HomeTableViewCell {
                if cell.videoPath.characters.count>0 {
                    targetCell = cell
                    break
                }
            }
        }
        // If found, play.
        guard let videoCell = targetCell else {
            return
        }
        playingCell = videoCell
        self.playingIndex = self.tableView.indexPath(for: videoCell)!
        // display status view.
        if videoCell.fileTypeImage == false {
            //            videoCell.imgPost.jp_playVideoHiddenStatusView(with: URL(string: videoCell.videoPath))
        }
        
    }
    
    func handleScrollDerectionWithOffset(offsetY : CGFloat) {
        currentDerection = (offsetY-offsetY_last) > 0 ? kJPVideoPlayerDemoScrollDerection.up : kJPVideoPlayerDemoScrollDerection.down
        offsetY_last = offsetY
    }
    func handleQuickScroll() {
        if playingCell?.hash==0 {
            return
        }
        //        if tableViewRange.isHidden {
        //            return;
        //        }
        // Stop play when the cell playing video is unvisiable.
        if playingIndex != nil && self.tableView.cellForRow(at: playingIndex!) == nil{
            stopPlay()
        }
        
    }
    
    func stopPlay() {
        playingCell?.imgPost.jp_pause()
        
        playingCell = nil
    }
    
    func playingCellIsVisiable() -> Bool {
        guard let cell = playingCell else {
            return true
        }
        
        var windowRect = UIScreen.main.bounds
        windowRect.origin.y = 64;
        // because have UINavigationBar here.
        windowRect.size.height -= 64;
        
        if currentDerection==kJPVideoPlayerDemoScrollDerection.up {
            let cellLeftUpPoint = cell.frame.origin
            let cellDownY = cellLeftUpPoint.y+cell.frame.size.height
            var cellLeftDownPoint = CGPoint(x: 0, y: cellDownY)
            
            cellLeftDownPoint.y -= 1
            let coorPoint = playingCell?.superview?.convert(cellLeftDownPoint, to: nil)
            
            let contain = windowRect.contains(coorPoint!)
            return contain
        }
        else if(currentDerection==kJPVideoPlayerDemoScrollDerection.down){
            var cellLeftUpPoint = cell.frame.origin
            
            cellLeftUpPoint.y += 1
            let coorPoint = cell.superview?.convert(cellLeftUpPoint, to: nil)
            
            let contain = windowRect.contains(coorPoint!)
            return contain
        }
        return true
    }
    
    func handleScrollStop() {
        
        guard let bestCell = findTheBestToPlayVideoCell() else {
            if let playingCell = self.playingCell{
                DispatchQueue.main.async {
                    playingCell.imgPost.jp_stopPlay()
                    self.playingCell?.playbutton.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
                    self.playingCell = nil
                }
            }
            return
        }
        // If the found cell is the cell playing video, this situation cannot play video again.
        if self.playingIndex != self.tableView.indexPath(for: bestCell) {
            DispatchQueue.main.async {
            self.playingCell?.imgPost.jp_stopPlay()
            self.playingCell?.playbutton.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
            //let url = URL(string: bestCell.videoPath)
            }
            // display status view.
            if bestCell.fileTypeImage == false {
                //                bestCell.imgPost.jp_playVideoHiddenStatusView(with: url)
            }
            playingCell = bestCell
            self.playingIndex = self.tableView.indexPath(for: bestCell)!
        }else{
            if let playingCell = self.playingCell{
                if tableView.visibleCells.contains(playingCell){
                    if playingCell.fileTypeImage == false {
                        playingCell.imgPost.jp_resume()
                        self.playingIndex = self.tableView.indexPath(for: playingCell)!
                    }
                }else{
                    DispatchQueue.main.async {
                        playingCell.imgPost.jp_stopPlay()
                        playingCell.playbutton.setImage(#imageLiteral(resourceName: "ic_play_circle_filled"), for: .normal)
                        self.playingCell = nil
                    }
                }
            }
        }
    }
    
    func displayTableViewRange() {
        UIApplication.shared.keyWindow!.insertSubview(tableViewRange, aboveSubview: tableView)
        
    }
    func findTheBestToPlayVideoCell() -> HomeTableViewCell? {
        
        var windowRect = UIScreen.main.bounds
        windowRect.origin.y = 64;
        windowRect.size.height -= (64 + 60 );
        
        // To find next cell need play video.
        
        var finialCell : HomeTableViewCell?
        let visiableCells : [UITableViewCell] = tableView.visibleCells ;
        var gap : CGFloat = CGFloat(MAXFLOAT)
        guard visiableCells.count > 1 else {
            if let mainCell = visiableCells[0] as? HomeTableViewCell {
                return mainCell.videoPath.characters.count>0 ? mainCell : finialCell
            }
            return finialCell
            
        }
        for cell in visiableCells {
            guard let cell = cell as? HomeTableViewCell else {
                return finialCell
            }
            if cell.videoPath.characters.count>0 { // If need to play video,
                
                // Find the cell cannot stop in screen center first.
                
                if cell.cellStyle != kJPPlayUnreachCellStyle.none {
                    
                    // Must the all area of the cell is visiable.
                    
                    if cell.cellStyle == kJPPlayUnreachCellStyle.up {
                        var cellLeftUpPoint = cell.imgPost.frame.origin
                        
                        cellLeftUpPoint.y += 1
                        let coorPoint = cell.superview?.convert(cellLeftUpPoint, to: nil)
                        let contain = windowRect.contains(coorPoint!)
                        if  contain {
                            finialCell = cell
                            break
                        }
                    }
                    else if(cell.cellStyle == kJPPlayUnreachCellStyle.down){
                        let cellLeftUpPoint = cell.imgPost.frame.origin
                        let cellDownY = cellLeftUpPoint.y+cell.imgPost.frame.size.height
                        var cellLeftDownPoint = CGPoint(x: 0, y: cellDownY)
                        
                        cellLeftDownPoint.y -= 1
                        let coorPoint = cell.superview?.convert(cellLeftDownPoint, to: nil)
                        let contain = windowRect.contains(coorPoint!)
                        if contain {
                            finialCell = cell
                            break;
                        }
                    }
                }
                else{
                    let coorCenter = cell.superview?.convert(cell.center, to: nil)
                    let delta = fabs((coorCenter?.y)!-64-windowRect.size.height*0.5)
                    if delta < gap {
                        gap = delta
                        finialCell = cell
                    }
                }
            }
        }
        return finialCell
    }
}

extension HomeViewController:UIScrollViewDelegate{
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        offsetY_last = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollDerectionWithOffset(offsetY: scrollView.contentOffset.y)
        handleQuickScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate==false {
            handleScrollStop()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollStop()
    }
}
//extension HomeViewController : RepostviewcontrollerDelegate
//{
    
    
//}

extension HomeViewController : JPVideoPlayerDelegate {
    func shouldAutoReplayAfterPlayComplete(for videoURL: URL) -> Bool {
        return true
    }
}
extension HomeViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
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
        //let font = UIFont.init(name: "Roboto-Light_1", size: 16.0)
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 14.0)!,NSForegroundColorAttributeName:UIColor.darkGray,NSParagraphStyleAttributeName:parastyle]
        return NSAttributedString.init(string: self.errString, attributes: attributes )
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let str = self.errString=="Loading" ? "" : "Retry"
        let parastyle = NSMutableParagraphStyle()
        parastyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        parastyle.alignment = NSTextAlignment.center
        //let font = UIFont.init(name: "Roboto-Light_1", size: 16.0)
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 18.0)!,NSForegroundColorAttributeName:UIColor.darkGray,NSParagraphStyleAttributeName:parastyle]
        return NSAttributedString.init(string: str, attributes: attributes )
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.fetchdetails(page: self.currentpage)
    }
}
   extension HomeViewController: flagPostDelegate
   {
    func flagSuccessAction(view: flagPost, postId: String, index: IndexPath) {
        view.removeFromSuperview()
        print(postId)
        self.flagpostApi(postId: postId, index: index)
    }
    func flagpostApi(postId: String,index: IndexPath)
    
    {
        let params :Parameters = ["action": "flag_post", "post_id": postId,"user_id":(standard.value(forKey: "user_id") as? String) ?? ""]
        print(params)
        print(mainurl + "content_object.php")
        animationView.play()
        animationView.loopAnimation = true
        Api.requestPOST(mainurl + "content_object.php", params: params, headers: [:], success: { (json, statuscode) in
            guard json["response"]["msg"].stringValue == "201" else
            {
                DispatchQueue.main.async {
                    animationView.pause()
                    animationView.removeFromSuperview()
                }
                
                self.showalertview(messagestring: json["response"]["reason"].stringValue)
                return
            }
            DispatchQueue.main.async
                {
                animationView.pause()
                animationView.removeFromSuperview()
            }
            
                self.removeIndexArr(index: index.row)
        })
        {
            (error) in
            self.showalertview(messagestring: error.localizedDescription)
        }
    }
}
