//
//  AuserCommentViewController.swift
//  Viegram
//
//  Created by Relinns on 31/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage
import DZNEmptyDataSet
import MBProgressHUD



class AuserCommentViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate ,UITextViewDelegate {
    var repostid = String()
    var apiData = JSON.init([String:Any])
    
    var data = [CommentModel]()
    var indexPath : IndexPath?
    
    var points = String()
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var textview: UITextView!
    var curstorPosition = 0
    
    @IBOutlet weak var commentTableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchtableheightconstraint: NSLayoutConstraint!
    
    // MARK: - backbtn
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchtableView.isHidden = true
        fetch_comments(postid: repostid)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        self.navbar.setBackgroundImage(#imageLiteral(resourceName: "imgMenuBar"), for: .default)
        self.addShadow(view: self.navbar, opacity: 0.3, radius: 2.5)
        textview.text = "Write a comment"
        textview.textColor = UIColor.lightGray
        textview.delegate = self
        self.tableview.rowHeight = UITableViewAutomaticDimension
        let view = CircularMenu.init(frame:  CGRect(x: -30, y:self.view.frame.size.height - 130, width: 80, height: 80))
        
        self.view.addSubview(view)
    }
    
    
    func addShadow(view:UIView,opacity:Float,radius:CGFloat){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = radius
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        self.commentTableviewHeightConstraint.constant = self.view.frame.height - 114
        addshodow(view: view1)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.searchtableheightconstraint.constant = keyboardRectangle.height + 54
            self.commentTableviewHeightConstraint.constant = self.self.view.frame.height - 114 -  keyboardRectangle.height
        }
    }
    func keyboardWillHide(_ notification: Notification) {
        
        if let _: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            self.commentTableviewHeightConstraint.constant = self.view.frame.height - 114
        }
    }
    
    // MARK: - textfield delegate
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard textView.text.isEmpty == false else {
            self.mentionidArr.removeAll()
            DispatchQueue.main.async {
                self.searchtableView.isHidden = true
            }
            return
        }
        let str =  textView.text!
        let numbers = str.components(separatedBy: " ")
        print(numbers)
        for str1 in numbers {
            if str1.contains("@") {
                let myStr =     str1.replacingOccurrences(of: "@", with: "", options: .literal, range: nil)
                searchPeople(str: myStr)
            }
        }
        
        if let selectedRange = textView.selectedTextRange {
            
            let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            self.curstorPosition = cursorPosition
            print("\(cursorPosition)")
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    // MARK: - Send cooment api call
    
    @IBAction func send(_ sender: UIButton) {
        commentApi(postid: repostid, guest_id: guest_id)
    }
    
    @IBOutlet weak var emptyview: UIView!
    
    
    
    // MARK: - tableviewdelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableview {
            return self.data.count
            
        }else{
            return serachuserid1.count
        }
    }
    
    
    
    
    //Tag mention array
    var nameArr = [String]()
    var useridAsrr = [String]()
    var mainArr = NSMutableArray()
    var range1 = [Int]()
    var range2 = [Int]()
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableview {
            let cell1 = tableview.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! AUserCommentTableViewCell
            cell1._img.sd_setImage(with: URL(string: self.data[indexPath.row].getprofileimage()), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            cell1._name.text = self.data[indexPath.row].display_name
            cell1._comment.text = self.data[indexPath.row].comment
            if self.data[indexPath.row].likes == "0" {
                cell1._likebtn.setBackgroundImage(#imageLiteral(resourceName: "imgLike"), for: .normal)
            }else{
                cell1._likebtn.setBackgroundImage(#imageLiteral(resourceName: "imgLikeFilled"), for: .normal)
            }
            
            
            
            if self.data[indexPath.row].total_likes == "0 points" {
                cell1._imgstar.isHidden = true
                cell1._totallikes.text = ""
            }else{
                cell1._imgstar.isHidden = false
                cell1._totallikes.text = self.data[indexPath.row].total_likes
                let tap = UITapGestureRecognizer(target: self, action: #selector(AuserCommentViewController.tapFunction))
                cell1._totallikes.tag = indexPath.row
                cell1._totallikes.isUserInteractionEnabled = true
                cell1._totallikes.addGestureRecognizer(tap)
            }
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(AuserCommentViewController.openProfile(sender:)))
            let gesture1 = UITapGestureRecognizer(target: self, action: #selector(AuserCommentViewController.openProfile(sender:)))
            cell1._img.tag = indexPath.row
            cell1._name.tag = indexPath.row
            cell1._img.isUserInteractionEnabled = true
            cell1._name.isUserInteractionEnabled = true
            cell1._img.addGestureRecognizer(gesture)
            cell1._name.addGestureRecognizer(gesture1 )
            
            cell1._time.text = self.data[indexPath.row].time_ago
            cell1._likebtn.addTarget(self, action: #selector(self.likebtn(sender:)) , for: .touchUpInside)
            for index in 0..<self.data[indexPath.row].mentionedPeople.count{
                self.nameArr.append((self.data[indexPath.row].mentionedPeople[index]["display_name"] as? String ?? ""))
                self.useridAsrr.append((self.data[indexPath.row].mentionedPeople[index]["id"] as? String ?? ""))
            }
            print(nameArr)
            var attributedString = NSMutableAttributedString()
            let yourAttributes = [NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
            attributedString = NSMutableAttributedString(string:self.data[indexPath.row].comment)
            
            for index in 0..<nameArr.count {
                let str = nameArr[index]
                if self.data[indexPath.row].comment.contains(str){
                    
                    let testString = self.data[indexPath.row].comment
                    let int = Int(testString.range(of: str)!.lowerBound, in: testString)
                    print(int)
                    let  char = str.characters.count
                    range1.append(int)
                    range2.append(char)
                    attributedString.setAttributes(yourAttributes, range: NSMakeRange(range1[index], range2[index]))
                    
                }
                cell1._comment.attributedText = attributedString
                cell1.textViewHeight.constant = cell1._comment.sizeThatFits(cell1._comment.frame.size).height
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapgesture(sender:)))
                gestureRecognizer.numberOfTapsRequired = 1;
                gestureRecognizer.numberOfTouchesRequired = 1;
                cell1._comment.isUserInteractionEnabled = true
                cell1._comment.tag = indexPath.row
                cell1._comment.addGestureRecognizer(gestureRecognizer);
                
                
            }
            self.range1.removeAll()
            self.range2.removeAll()
            self.nameArr.removeAll()
            self.useridAsrr.removeAll()
            return cell1
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchTableViewCell
            cell.namelbl.text = profile_name[indexPath.row] as? String
            cell.img.sd_setImage(with: URL(string: (profile_image1[indexPath.item] as? String)!), placeholderImage: placeholder1, options: SDWebImageOptions.refreshCached)
            
            return cell
        }
    }
    
    var mentionidArr = [String]()
    var mention = String()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.searchtableView {
            let name = (self.profile_name[indexPath.row] as! String)
            let userid1 = (self.serachuserid1[indexPath.row] as! String)
            mentionidArr.append(userid1)
            
            let str =  self.textview.text!
            let numbers = str.components(separatedBy: " ")
            var completedString = [String]()
            print(numbers)
            var seekPosition = 0
            for var str1 in numbers {
                seekPosition += str1.characters.count + 1
                if seekPosition >= curstorPosition {
                    str1 = "@\(name)"
                }
                completedString.append(str1)
            }
            self.textview.text = completedString.joined(separator: " ")
            self.searchtableView.isHidden = true
        }
        
        
    }
    
    
    
    
    
    // MARK: - tap gesture
    //tap gesture for lbl
    
    func tapgesture(sender:UITapGestureRecognizer){
        
        // print("tap working",sender.view!.tag)
        let point = sender.location(in: self.tableview)
        guard let indexpath = self.tableview.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        
        var nameArr = [String]()
        var userIdArr = [String]()
        for index in 0..<self.data[indexpath.row].mentionedPeople.count{
            
            nameArr.append((self.data[indexpath.row].mentionedPeople[index]["display_name"] as? String ?? ""))
            userIdArr.append((self.data[indexpath.row].mentionedPeople[index]["id"] as? String ?? "" ))
        }
        
        let stringportions = self.data[indexpath.row].comment.components(separatedBy: " ")

        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            // print the character index
            print("character index: \(characterIndex)")
            // print the character at the index
            let myRange = NSRange(location: characterIndex, length: 1)
            let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
            print("character at index: \(substring)")
            
            var seek = 0
            for i in stringportions{
                seek += i.characters.count
                if seek >= characterIndex{
                    
                    if let index = nameArr.index(of:i.replacingOccurrences(of: "@", with: "")){
                        
                        let userId = userIdArr[index]
                        if userId == standard.value(forKey: "user_id") as! String{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            Anotheruserprofile(userid2: userId)
                        }
                    }
                    
                    return
                }
            }
            
            
            
            
            
            
        }
     
        self.range1.removeAll()
        self.range2.removeAll()
        self.nameArr.removeAll()
        self.useridAsrr.removeAll()
        
    }
    
    // MARK: - likebtn
    func likebtn(sender:UIButton){
        let point = sender.convert(CGPoint.zero, to: self.tableview)
        guard let indexpath = self.tableview.indexPathForRow(at: point) else{
            print("error")
            return
        }
        
        let commentid = self.data[(indexpath.row)].comment_id
        let comment_userid = self.data[(indexpath.row)].comment_userid
        
        likecommentApi(postid: repostid, guest_id: guest_id , commentid: commentid , comment_userid: comment_userid)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func openProfile(sender:UITapGestureRecognizer){
        let point = sender.view!.convert(CGPoint.zero, to: self.tableview)
        guard let indexpath = self.tableview.indexPathForRow(at: point) else{
            print("error")
            return
        }
        let str =  self.data[indexpath.row].comment_userid
        
        if str == standard.value(forKey: "user_id") as! String{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Anotheruserprofile(userid2: str)
        }
        
        
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        
        print("tap working",sender.view!.tag)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentLikeViewController") as! CommentLikeViewController
        vc.commentID = self.data[sender.view!.tag].comment_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - API Call
    var guest_id = String()
    var profile_image = NSArray()
    var comments = NSArray()
    var comment_id = NSArray()
    var total_likes = NSArray()
    var display_name = NSArray()
    var comment_userid = NSArray()
    var like1 = NSArray()
    var timeago = NSArray()
    var mentionpeople = NSArray()
    
    ////scroll to bottom
    func scrollToBottom(){
        DispatchQueue.main.async
            {
                if (self.comments.count > 0)
                {
            
            let indexPath = IndexPath(row: self.comments.count-1, section: 0)
            self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
                else
                {
                }
        }
                
    }
    
    func fetch_comments(postid: String ){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"fetch_comments","postid":"\(repostid)","userid":"\(standard.value(forKey: "user_id")!)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "post_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
//                animationView.pause()
//                animationView.removeFromSuperview()
                
                [MBProgressHUD .hide(for: self.view, animated:true)]
                print(response.result.error!.localizedDescription)
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            self.data.removeAll()
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                if  (json["result"]["reason"] .stringValue) == "no comment done on this post"{
                    
                }else{
                    self.showalertview(messagestring: "Error")
                }
                DispatchQueue.main.async {
                    
                self.tableview.reloadData()
                    self.scrollToBottom()
                }

//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]

                
                return
            }
            
            //let user_id = ((json["result"]["details"]["user_id"].stringValue))
            
            self.apiData = json
            self.data.removeAll()
            
            for i in json["result"]["comments"].arrayValue {
                let profile_image = i["profile_image"].stringValue
                let comments =      i["comments"].stringValue
                let comment_id =   i["comment_id"].stringValue
                let total_likes =  i["total_likes"].stringValue
                let display_name =  i["display_name"].stringValue
                let comment_userid =  i["comment_userid"].stringValue
                let timeago =  i["time_ago"].stringValue
                let postUserID =  i["post_userid"].stringValue
                let like =  i["like"].stringValue
                let mentionpeople = i["mention_people"].arrayObject as! [[String:Any]]
                
                let comment = CommentModel.init(profileImg: profile_image, comment: comments, comment_id: comment_id, total_likes: total_likes, display_name: display_name, comment_userid: comment_userid, time_ago: timeago, likes: like, mentionedPeople: mentionpeople, postUserId: postUserID)
                self.data.append(comment)
            }
            
            
            let profile_image1 = ((json["result"]["comments"].arrayValue).map({$0["profile_image"].stringValue}))
            let comments1 =      ((json["result"]["comments"].arrayValue).map({$0["comments"].stringValue}))
            let comment_id1 =    ((json["result"]["comments"].arrayValue).map({$0["comment_id"].stringValue}))
            let total_likes1 =   ((json["result"]["comments"].arrayValue).map({$0["total_likes"].stringValue}))
            let display_name1 =  ((json["result"]["comments"].arrayValue).map({$0["display_name"].stringValue}))
            let comment_userid1 =  ((json["result"]["comments"].arrayValue).map({$0["comment_userid"].stringValue}))
            let timeago1 =  ((json["result"]["comments"].arrayValue).map({$0["time_ago"].stringValue}))
            
            let like =  ((json["result"]["comments"].arrayValue).map({$0["like"].stringValue}))
            let mentionpeople1 = (((json["result"]["comments"].arrayValue).map({$0["mention_people"].arrayValue})))
            
            self.mentionpeople = mentionpeople1 as NSArray
            self.profile_image = profile_image1 as NSArray
            self.comments = comments1 as NSArray
            self.total_likes = total_likes1 as NSArray
            self.display_name = display_name1 as NSArray
            self.comment_id = comment_id1 as NSArray
            self.comment_userid = comment_userid1 as NSArray
            self.like1 = like as NSArray
            self.timeago = timeago1 as NSArray
            
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            DispatchQueue.main.async {
                
                
                self.tableview.reloadData()
                self.scrollToBottom()
                
                
            }
            
        }
        
    }
    //////////////////***madebyme***/////
    
    func fetch_commentsnew(postid: String )
    {
        //        self.view.addSubview(animationView)
        //        animationView.play()
        //        animationView.loopAnimation = true
        //[MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"fetch_comments","postid":"\(repostid)","userid":"\(standard.value(forKey: "user_id")!)" ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "post_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                //                animationView.pause()
                //                animationView.removeFromSuperview()
                
                //[MBProgressHUD .hide(for: self.view, animated:true)]
                print(response.result.error!.localizedDescription)
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            self.data.removeAll()
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                if  (json["result"]["reason"] .stringValue) == "no comment done on this post"{
                    
                }else{
                    self.showalertview(messagestring: "Error")
                }
                DispatchQueue.main.async {
                    
                    self.tableview.reloadData()
                    self.scrollToBottom()
                }
                
                //                animationView.pause()
                //                animationView.removeFromSuperview()
                //[MBProgressHUD .hide(for: self.view, animated:true)]
                
                return
            }
            
            //let user_id = ((json["result"]["details"]["user_id"].stringValue))
            
            self.apiData = json
            self.data.removeAll()
            
            for i in json["result"]["comments"].arrayValue {
                let profile_image = i["profile_image"].stringValue
                let comments =      i["comments"].stringValue
                let comment_id =   i["comment_id"].stringValue
                let total_likes =  i["total_likes"].stringValue
                let display_name =  i["display_name"].stringValue
                let comment_userid =  i["comment_userid"].stringValue
                let timeago =  i["time_ago"].stringValue
                let postUserID =  i["post_userid"].stringValue
                let like =  i["like"].stringValue
                let mentionpeople = i["mention_people"].arrayObject as! [[String:Any]]
                
                let comment = CommentModel.init(profileImg: profile_image, comment: comments, comment_id: comment_id, total_likes: total_likes, display_name: display_name, comment_userid: comment_userid, time_ago: timeago, likes: like, mentionedPeople: mentionpeople, postUserId: postUserID)
                self.data.append(comment)
            }
            
            
            let profile_image1 = ((json["result"]["comments"].arrayValue).map({$0["profile_image"].stringValue}))
            let comments1 =      ((json["result"]["comments"].arrayValue).map({$0["comments"].stringValue}))
            let comment_id1 =    ((json["result"]["comments"].arrayValue).map({$0["comment_id"].stringValue}))
            let total_likes1 =   ((json["result"]["comments"].arrayValue).map({$0["total_likes"].stringValue}))
            let display_name1 =  ((json["result"]["comments"].arrayValue).map({$0["display_name"].stringValue}))
            let comment_userid1 =  ((json["result"]["comments"].arrayValue).map({$0["comment_userid"].stringValue}))
            let timeago1 =  ((json["result"]["comments"].arrayValue).map({$0["time_ago"].stringValue}))
            
            let like =  ((json["result"]["comments"].arrayValue).map({$0["like"].stringValue}))
            let mentionpeople1 = (((json["result"]["comments"].arrayValue).map({$0["mention_people"].arrayValue})))
            
            self.mentionpeople = mentionpeople1 as NSArray
            self.profile_image = profile_image1 as NSArray
            self.comments = comments1 as NSArray
            self.total_likes = total_likes1 as NSArray
            self.display_name = display_name1 as NSArray
            self.comment_id = comment_id1 as NSArray
            self.comment_userid = comment_userid1 as NSArray
            self.like1 = like as NSArray
            self.timeago = timeago1 as NSArray
            
            //            animationView.pause()
            //            animationView.removeFromSuperview()
           // [MBProgressHUD .hide(for: self.view, animated:true)]
            
            print("success")
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.scrollToBottom()
                
            }
            
        }
        
    }
    
    
    //////////////////////
    
    // Fetch Profile
    func Anotheruserprofile(userid2: String){
        // self.view.addSubview(animationView)
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
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]
        }
        
    }
    
    func commentApi(postid: String ,guest_id: String ){
        guard self.textview.text.isEmpty == false && self.textview.textColor == UIColor.black else {
            return
        }
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        mention = self.mentionidArr.joined(separator: ",")
        
        let parameter: Parameters = ["action":"comment_post","postid":"\(postid)" ,"post_userid" : "\(guest_id)" , "comment_userid" : "\(standard.value(forKey: "user_id")!)" , "comment" : "\(textview.text!)","mention_userid":"\(mention)"]
        print(parameter)
        Alamofire.request(mainurl + "post_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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
            
            DispatchQueue.main.async {
                self.textview.resignFirstResponder()
                self.textview.text = "Write a comment"
                self.textview.textColor = UIColor.lightGray
                self.textview.delegate = self
                self.points = json["result"]["total_post_points"].stringValue
                self.fetch_comments(postid: postid)
            }
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            self.mentionidArr = []
        }
    }
    
    func likecommentApi(postid: String ,guest_id: String ,commentid : String ,comment_userid : String){
        
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
       // [MBProgressHUD .showAdded(to: self.view, animated: true)]
        
        let parameter: Parameters = ["action":"like_comment","postid":"\(postid)" ,"post_userid" : "\(guest_id)" , "comment_likeby" : "\(standard.value(forKey: "user_id")!)" , "commentid" : "\(commentid)" , "comment_userid" : "\(comment_userid)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "post_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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
               // [MBProgressHUD .hide(for: self.view, animated:true)]

                return
            }
            
            self.fetch_commentsnew(postid: self.repostid)
//            animationView.pause()
           // animationView.removeFromSuperview()
            //[MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            
        }
    }
    
    func deletecommentApi(indexPath:IndexPath){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view, animated: true)]
        let parameter: Parameters = ["action":"delete_comment","postid":self.repostid,"post_userid" : self.data[indexPath.row].postUserID  , "comment_userid" : self.data[indexPath.row].comment_userid , "comment_id" : self.data[indexPath.row].comment_id]
        
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
                self.showalertview(messagestring: "Error")
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]

                return
            }
//            animationView.pause()
//            animationView.removeFromSuperview()
            [MBProgressHUD .hide(for: self.view, animated:true)]

            print("success")
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.scrollToBottom()
                self.fetch_comments(postid: self.repostid)
            }
            
            
        }
    }
    
    
    
    
    @IBOutlet weak var searchtableView: UITableView!
    var profile_name = NSArray()
    var profile_image1 = NSArray()
    var serachuserid1 = NSArray()
    
    func searchPeople(str:String){
        
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
        [MBProgressHUD .showAdded(to: self.view , animated: true)]
        let parameter: Parameters = ["action":"search_user","userid":"\(standard.value(forKey: "user_id")!)" , "search" : "\(str)" ]
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
                print("failure")
//                animationView.pause()
//                animationView.removeFromSuperview()
                [MBProgressHUD .hide(for: self.view, animated:true)]
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
                self.searchtableView.isHidden = false
                self.searchtableView.reloadData()
            }
        }
    }
    
}
public extension Int {
    /// Creates an `Int` from a given index in a given string
    ///
    /// - Parameters:
    ///    - index:  The index to convert to an `Int`
    ///    - string: The string from which `index` came
    init(_ index: String.Index, in string: String) {
        self.init(string.distance(from: string.startIndex, to: index))
    }
}
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y:(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension AuserCommentViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "emptycomment")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "\"Post a comment to start a discussion\""
        let attributes : [String:Any] = [NSFontAttributeName : UIFont.init(name: "Roboto-Light", size: 16.0)!,NSForegroundColorAttributeName:apppurple]
        return NSAttributedString.init(string: str, attributes: attributes )
    }
    
}

extension AuserCommentViewController{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (standard.value(forKey: "user_id") as! String) == self.data[indexPath.row].postUserID || (standard.value(forKey: "user_id") as! String) == self.data[indexPath.row].comment_userid{
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //print("Delete button tapped")
            self.deletecommentApi(indexPath:indexPath)
        }
        Delete.backgroundColor = apppurple
        return [Delete]
    }


}
extension UILabel {
    ///Find the index of character (in the attributedText) at point
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
