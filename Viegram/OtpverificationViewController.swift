//
//  OtpverificationViewController.swift
//  Viegram
//
//  Created by Jagdeep on 03/06/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie

class OtpverificationViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var nav: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        addborder(view: view1)
        addborder(view: view2)
        addborder(view: view3)
        addborder(view: view4)
       
        tf1.becomeFirstResponder()
        addshodow(view: self.nav)
        
        addshodow(view: self.view1)
        
        addshodow(view: self.view2)
        
        addshodow(view: self.view3)
        
        addshodow(view: self.view4)
        
        
               self.nav.layer.masksToBounds = false
        self.nav.layer.shadowColor = UIColor.lightGray.cgColor
        self.nav.layer.shadowOpacity = 0.3
        self.nav.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.nav.layer.shadowRadius = 2.5

        
        DispatchQueue.main.async {
            self.nav.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            
            self.nav.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
            
           
                      
        }

 animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func bckbtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
     @IBOutlet weak var view3: UIView!
     @IBOutlet weak var view4: UIView!
    func addborder(view:UIView){
        view.layer.borderWidth = 0.3
        view.layer.borderColor = apppurple.cgColor
    }
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
   
    var alldata  = String()
      var emailstr = String()
    
    @IBAction func submitbtn(_ sender: UIButton) {
        alldata = (tf1.text!+tf2.text!+tf3.text!+tf4.text!)
        
        if tf1.text?.isEmpty == true {
            showalertview(messagestring: "Enter Text")
            return
        }
        else if tf2.text?.isEmpty == true {
            showalertview(messagestring: "Enter Text")
            return
        }
        else if tf3.text?.isEmpty == true {
            showalertview(messagestring: "Enter Text")
            return
        }
        else if tf4.text?.isEmpty == true {
            showalertview(messagestring: "Enter Text")
            return
            
        }
        else{
            
            
            apicall()
            
            
        }

        
    }
    @IBAction func tf1(_ sender: UITextField) {
        if (tf1.text?.characters.count)! >= 1 {
            self.tf2.becomeFirstResponder()
        }
    }
    @IBAction func tf2(_ sender: UITextField) {
        if (tf2.text?.characters.count)! >= 1 {
            tf3.becomeFirstResponder()
        }
    }
    
    @IBAction func tf3(_ sender: UITextField) {
        if (tf3.text?.characters.count)! >= 1 {
            tf4.becomeFirstResponder()
        }
    }
    
    @IBAction func tf4(_ sender: UITextField) {
        if (tf4.text?.characters.count)! >= 1 {
           resignFirstResponder()
        }
    }
    func apicall(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"verify_otp", "email":"\(emailstr)" ,"otp_code" : "\(alldata)"]
        
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
            self.tf1.text = ""
            self.tf2.text = ""
            self.tf3.text = ""
            self.tf4.text = ""
            animationView.pause()
            animationView.removeFromSuperview()
            print("success")
            
//            standard.setValue(json["detail"]["user_id"].stringValue, forKey: "user_id")
           
            
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                vc.emailstr = self.emailstr
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }

   
    }
    

