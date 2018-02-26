//
//  SignUpViewController.swift
//  Viegram
//
//  Created by Apple on 5/24/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie

class SignUpViewController: UIViewController , UITextFieldDelegate ,selectedCountry{
    
    var countryId = String()
    @IBOutlet weak var signUpBg: UIView!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_displayName: UITextField!
    @IBOutlet weak var txt_country: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBAction func back(_ sender: UIButton) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func signup(_ sender: UIButton) {
        
        if txt_name.text?.isEmpty == true {
            showalertview(messagestring: "Enter Username")
            return
        } else if txt_displayName.text?.isEmpty == true {
            showalertview(messagestring: "Enter Display Name")
            
        }
        else if txt_email.text?.isEmpty == true {
            showalertview(messagestring: "Enter Your Email")
        }
        else if txt_email.text?.isValidEmail() == false {
            self.showalertview(messagestring: "Please provide a valid email")
            return
        }
        else if ((txt_password.text?.characters.count)! < 8) || (txt_password.text?.checkCapital() == false)
        {
            self.showalertview(messagestring: "Password should include one capital letter and at Least 8 Characters.")
            return
        }
        else{
            apicall()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addshodow(view: signUpBg, radius: 4, opacity: 0.3)
        self.addshodow(view: signUpBtn, radius: 3, opacity: 0.7)
        self.addLeftViewMode(textField: self.txt_name, image: #imageLiteral(resourceName: "imgName"))
        self.addLeftViewMode(textField: self.txt_displayName, image: #imageLiteral(resourceName: "imgName"))
        self.addLeftViewMode(textField: self.txt_email, image: #imageLiteral(resourceName: "imgEmail"))
        self.addLeftViewMode(textField: self.txt_country, image: #imageLiteral(resourceName: "imgCountry"))
        self.addLeftViewMode(textField: self.txt_password, image: #imageLiteral(resourceName: "imgpassword"))
        // Do any additional setup after loading the view.
        
        animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
        
    }
    func data(country: String,code:String) {
        self.txt_country.text = country
        self.countryId = code

    }
    @IBAction func checkDisplayname(_ sender: UITextField) {
        validatename()
    }
    
    
    
    @IBAction func checkEmail(_ sender: UITextField) {
        validateEmail()
    }
    
    @IBAction func selectCountry(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectCountryViewController")as! SelectCountryViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addshodow(view:UIView,radius:CGFloat,opacity:Float){
        //code to add shadow to views
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = radius
    }
    
    
    func addLeftViewMode(textField:UITextField,image:UIImage){
        
        //Add left view images to textfields
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        textField.leftViewMode = .always
        textField.leftView = imageView
    }
    @IBAction func terms(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsconditionsViewController") as! TermsconditionsViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func apicall(){
        self.view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        let parameter: Parameters = ["action":"signup","full_name": txt_name.text! ,"display_name":txt_displayName.text!, "country":self.countryId, "email":"\(txt_email.text!)", "password":txt_password.text!, "device_id": deviceUUID, "device_type":"ios" , "device_token": "\((standard.value(forKey: "gcm") as? String) ?? "")"]
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
            
            standard.set(json["result"]["detail"]["user_id"].stringValue, forKey: "user_id")
            standard.set(json["result"]["detail"]["country"].stringValue, forKey: "country")
            standard.set(json["result"]["detail"]["email"].stringValue, forKey: "email")
            standard.set(json["result"]["detail"]["full_name"].stringValue, forKey: "full_name")
            standard.set(json["result"]["detail"]["display_name"].stringValue, forKey: "display_name")
            print(standard.value(forKey: "email")!)
            
            
            DispatchQueue.main.async {
                  self.Rootview()
               
            }
          
        }
    }
    
    
    var window: UIWindow?
    func Rootview(){
        DispatchQueue.main.async{
            
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            vc.abc = 2
            navcon =  UINavigationController(rootViewController: vc)
            navcon.navigationBar.isTranslucent = false
            navcon.isNavigationBarHidden = true
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navcon
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    
    
    
    
    func validatename(){
        
        let parameter: Parameters = ["action":"verify_name","display_name":"\(txt_displayName.text!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "verifyobject.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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

            self.showalertview(messagestring: "Display Name exits", Buttonmessage: "OK", handler: {
                DispatchQueue.main.async {
                    self.txt_email.becomeFirstResponder()
                }
                
            })
            
        }
        
    }
    func validateEmail(){
        let parameter: Parameters = ["action":"verify_email","email":"\(txt_email.text!)"]
        
        print(parameter)
        
        Alamofire.request(mainurl + "verifyobject.php", method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
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
            
            print("success")
            self.showalertview(messagestring: "Email already exits")
        }
        
    }

    

    
}
