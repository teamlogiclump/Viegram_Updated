//
//  LoginViewController.swift
//  Viegram
//
//  Created by Apple on 5/24/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import Lottie

class LoginViewController: UIViewController {
    var beizer = UIBezierPath()
    @IBOutlet weak var loginViewBg: UIView!
    @IBOutlet weak var txt_pass: UITextField!
    
    @IBOutlet weak var txt_email: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iconImage.image = #imageLiteral(resourceName: "imgAppIcon").withRenderingMode(.alwaysTemplate)
       self.addshodow(view: loginViewBg, radius: 4, opacity: 0.3)
        self.addshodow(view: loginButton, radius: 3, opacity: 0.7)
        
         animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        
        
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ForgotPass(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func terms(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsconditionsViewController") as! TermsconditionsViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func loginAction(_ sender: Any) {
        
        if txt_email.text?.isEmpty == true {
            showalertview(messagestring: "Enter Your Email")
        }
        else if txt_email.text?.isValidEmail() == false {
            self.showalertview(messagestring: "Please provide a valid email")
            return
        }
        else if (txt_pass.text?.characters.count)! < 8
        {
            self.showalertview(messagestring: "Password should contains at Least 8 Characters ")
            return
        }
       
        else{
            
            
            apicall()
            
        }}
    
    override func viewDidLayoutSubviews() {
        //CODE TO CLIP THE LOGIN VIEW
        beizer.move(to: CGPoint(x:0,y: 70))
        beizer.addLine(to: CGPoint(x:0,y: self.loginViewBg.frame.maxY))
        beizer.addLine(to: CGPoint(x:self.loginViewBg.frame.maxY,y: self.loginViewBg.frame.maxY))
        beizer.addLine(to: CGPoint(x:self.loginViewBg.frame.maxY,y: 0))
        beizer.addLine(to: CGPoint(x:0,y: 70))
        beizer.close()
        let maskForYourPath = CAShapeLayer()
        maskForYourPath.path = beizer.cgPath
        self.loginViewBg.layer.mask = maskForYourPath
        self.loginViewBg.layer.rasterizationScale     = UIScreen.main.scale;
        self.loginViewBg.layer.shouldRasterize = true;
    }
    
    func addshodow(view:UIView,radius:CGFloat,opacity:Float){
        //code to add shadow to views
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = radius
        view.layer.masksToBounds = false
    }
    
    @IBAction func signUpAction(_ sender: Any) {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func apicall(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"login", "email":"\(txt_email.text ?? "")", "password":"\(txt_pass.text ?? "")" ,"device_token": "\((standard.value(forKey: "gcm") as? String) ?? "")","device_type" : "ios"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "password_object.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                self.showalertview(messagestring: response.result.error!.localizedDescription)
                animationView.pause()
                animationView.removeFromSuperview()
                return
            }
            var json = JSON(response.result.value!)
            print(json)
            
            
            guard (json["result"]["msg"] .intValue) == 201 else {
            self.showalertview(messagestring: "Email or password is incorrect")
                print("failure")
                animationView.pause()
                animationView.removeFromSuperview()
                return
            }
           
           // print("success")
            
            standard.set(json["result"]["detail"]["user_id"].stringValue, forKey: "user_id")
            standard.set(json["result"]["detail"]["profile_image"].stringValue, forKey: "profile_image")
            standard.set(json["result"]["detail"]["cover_image"].stringValue, forKey: "cover_image")
            standard.set(json["result"]["detail"]["full_name"].stringValue, forKey: "full_name")
            standard.set(json["result"]["detail"]["display_name"].stringValue, forKey: "display_name")
            standard.set(json["result"]["detail"]["email"].stringValue, forKey: "email")
            standard.set("", forKey: "signup")
            DispatchQueue.main.async {

                self.Rootview()
            }
            
        }
    }
    
    var window: UIWindow?
    func Rootview(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navigate = self.navigationController
        navigate?.viewControllers = [vc]
        UIApplication.shared.keyWindow?.rootViewController = navigate
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}
