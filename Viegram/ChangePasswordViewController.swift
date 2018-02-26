//
//  ChangePasswordViewController.swift
//  Viegram
//
//  Created by Apple on 6/1/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var txt_confirmPassword: UITextField!
    @IBOutlet weak var txt_newPassword: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var emailstr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "imgMenuBar"), for: .default)
        // Do any additional setup after loading the view.
        
        //without adding the view
        
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationBar.layer.shadowOpacity = 0.3
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationBar.layer.shadowRadius = 2.5
       // self.addshodow(view: self.currentView , radius: 1, opacity: 0.3)
        self.addshodow(view: self.newView , radius: 1, opacity: 0.3)
        self.addshodow(view: self.confirmView , radius: 1, opacity: 0.3)
        // Do any additional setup after loading the view.
        
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upadte(_ sender: UIButton) {
        if txt_newPassword.text?.isEmpty == true {
            showalertview(messagestring: "Enter Text")
            return
        }
        else if txt_confirmPassword.text?.isEmpty == true {
            showalertview(messagestring: "Enter Text")
            return
        }
        
        else if (txt_newPassword.text?.characters.count)! < 8
        {
            self.showalertview(messagestring: "Password should contains at Least 8 Characters ")
            return
        }
        else if txt_newPassword.text?.checkCapital() == false {
            self.showalertview(messagestring: "Password should include one capital letter  ")
            return
            
        }else if txt_newPassword.text != txt_confirmPassword.text {
            showalertview(messagestring: "Password does not match")
            return
        }

        else{
            
            
            apicall()
            
            
        }
        
    }
    func addshodow(view:UIView,radius:CGFloat,opacity:Float){
        //code to add shadow to views
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = radius
        view.layer.masksToBounds = false
    }

    func apicall(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"reset_password", "email":"\(emailstr)" ,"new_password" : "\(txt_newPassword.text!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "password_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                self.showalertview(messagestring: json["result"]["reason"].string!)
                print("failure")
                animationView.pause()
                animationView.removeFromSuperview()
                
                return
            }
           
            animationView.pause()
            animationView.removeFromSuperview()
            print("success")
            
            standard.setValue(json["result"]["user_id"].stringValue, forKey: "user_id")
            
            
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                vc.abc = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
}
