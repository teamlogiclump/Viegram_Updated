//
//  ForgotPasswordViewController.swift
//  Viegram
//
//  Created by Apple on 6/1/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
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
         animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chnge(_ sender: UIButton) {
        
        if txt_email.text?.isEmpty == true {
            showalertview(messagestring: "Enter Your Email")
        }
        else if txt_email.text?.isValidEmail() == false {
            self.showalertview(messagestring: "Please provide a valid email")
            return
        }
        
        else{
            
            
            apicall()
            
        }

        
            }

    func apicall(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"forget_password", "email":"\(txt_email.text!)", ]
        
        print(parameter)
        
        Alamofire.request(mainurl + "password_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
                if (json["result"]["msg"] .intValue) == 204 {
                    self.showalertview(messagestring: "Email does not exits")
                }
               
                print("failure")
                animationView.pause()
                animationView.removeFromSuperview()
                
                
                
                return
            }
            animationView.pause()
            animationView.removeFromSuperview()
            print("success")
            
//            standard.setValue(json["detail"]["user_id"].stringValue, forKey: "user_id")
           
            standard.set("", forKey: "signup")
            
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpverificationViewController") as! OtpverificationViewController
               vc.emailstr = (self.txt_email.text)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }

}
