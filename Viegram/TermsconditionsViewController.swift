//
//  TermsconditionsViewController.swift
//  Viegram
//
//  Created by Relinns on 30/05/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie

class TermsconditionsViewController: UIViewController {

    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // apicall()
        DispatchQueue.main.async {
            self.navbar.setBackgroundImage(UIImage.init(named: "NUmberimg"), for: .any, barMetrics: .default)
            
            self.navbar.titleTextAttributes = [NSForegroundColorAttributeName:apppurple]
            self.navbar.layer.masksToBounds = false
            self.navbar.layer.shadowColor = UIColor.lightGray.cgColor
            self.navbar.layer.shadowOpacity = 0.3
            self.navbar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            self.navbar.layer.shadowRadius = 2.5
            animationView.frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height/2 - 40, width: 80, height: 80)
            
            // Do any additional setup after loading the view.
        }
        loadHtmlFile()
    }
    func loadHtmlFile() {
        
        
        let url = URL(string: termsconditions)!
      
            
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            
//        }
        
//        let url = Bundle.main.url(forResource: "Terms", withExtension:"html")
        let request = URLRequest(url: url)
        webview.loadRequest(request)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backbtn(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)   
    }
    
//    func apicall(){
//        self.view.addSubview(animationView)
//        animationView.play()
//        animationView.loopAnimation = true
//        let parameter: Parameters = [:]
//        
//        print(parameter)
//        
//        Alamofire.request("http://www.relinns.com/viegram/viegram_pages/terms_condition.html", method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response , data ,error) in
//            guard ((response.result.value) != nil) else{
//                
//                print(response.result.error!.localizedDescription)
//                
//                return
//            }
//            var json = JSON(response.result.value!)
//            print(json)
//            
//            
//            guard (json["result"]["msg"] .intValue) == 201 else {
//                animationView.pause()
//                animationView.removeFromSuperview()
//                
//                
//                
//                return
//            }
//            
//            // print("success")
//            
//          
//                animationView.pause()
//                animationView.removeFromSuperview()
//            
//            
//        }
//    }
//    
//    }
}
