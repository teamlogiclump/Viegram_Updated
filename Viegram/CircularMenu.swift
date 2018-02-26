                                             //
//  CircularMenu.swift
//  cicular menu
//
//  Created by Apple on 5/30/17.
//  Copyright © 2017 Relinns. All rights reserved.

                                             
                                             // Have to look

import UIKit

class CircularMenu: UIView {
    @IBOutlet var view: UIView!

    @IBOutlet weak var menuViewShort: UIView!
    var first = true
   
    @IBOutlet weak var changeleading: NSLayoutConstraint!
  
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var largeWhite: UIView!
    @IBOutlet weak var largeGradient: UIView!
    @IBOutlet weak var smallGradient: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpScreen()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
    let nav = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
    
    
    func setUpScreen(){
       
    self.view = Bundle.main.loadNibNamed("CircularMenu", owner: self, options: nil)?[0] as? UIView
    self.view.frame = self.bounds
        //self.frame  = CGRect(x: -30, y:(self.superview?.frame.size.height)! - 130, width: 80, height: 80)
        self.largeGradient.isHidden = true
        //self.frame  = CGRect(x: -30, y:(self.superview?.frame.size.height)! - 130, width: 80, height: 80)
        self.addSubview(self.view)
       
    }
   
    
    func closeview(){
        
        
        self.smallGradient.isHidden = false
        self.largeGradient.isHidden = true
        self.buttonView.isHidden = false
        
        setUpScreen()
    }
    @IBAction func closeMenu(_ sender: UIButton) {
        
    self.frame  = CGRect(x: -30, y:(self.superview?.frame.size.height)! - 130, width: 80, height: 80)
        self.smallGradient.isHidden = false
        self.largeGradient.isHidden = true
        self.buttonView.isHidden = false
        
        setUpScreen()

        
       

    }
    
   
    @IBOutlet weak var homebtn: UIButton!
    @IBAction func homebtn(_ sender: UIButton) {
        if self.largeGradient.isHidden == false{
            DispatchQueue.main.async {

            self.nav.popToRootViewController(animated: true)
        }
    }
    }
        let navigationController = UINavigationController()
    
    @IBOutlet weak var homebtn_1: UIButton!
    @IBAction func homebtn1(_ sender: Any) {
       
        
    }
    
    func checkPresence(of viewController:UIViewController) -> Bool{
        if self.nav.viewControllers.last!.isKind(of: viewController.classForCoder){
            self.nav.viewControllers.removeLast()
            self.nav.viewControllers.append(viewController)
            self.window?.makeKeyAndVisible()
            return true
        }else{
            return false
        }
        
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    @IBAction func profilebtn(_ sender: UIButton) {
        let vc = mainStroyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController

        guard self.checkPresence(of: vc) == false else{
            return
        }

                 DispatchQueue.main.async {
                    self.closeview()
                    self.nav.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func stats(_ sender: UIButton) {
        let vc = storyboard.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
        guard self.checkPresence(of: vc) == false else{
            return
        }
        DispatchQueue.main.async {
            self.closeview()
            self.nav.pushViewController(vc, animated: true)
        }
    }
    @IBAction func noti(_ sender: UIButton) {
        
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        guard self.checkPresence(of: vc) == false else{
            return
        }
        DispatchQueue.main.async {
            self.closeview()
            self.nav.pushViewController(vc, animated: true)
        }

    }
    @IBAction func follower(_ sender: UIButton) {
        let vc = self.storyboard.instantiateViewController(withIdentifier: "AUserFollowerViewController") as! AUserFollowerViewController
        guard self.checkPresence(of: vc) == false else{
            return
        }
        DispatchQueue.main.async {
            self.closeview()
            self.nav.pushViewController(vc, animated: true)
        }
    }
    @IBAction func options(_ sender: UIButton) {
        let vc = self.storyboard.instantiateViewController(withIdentifier: "Options2ViewController") as! Options2ViewController
        guard self.checkPresence(of: vc) == false else{
            return
        }
        DispatchQueue.main.async {
            self.closeview()
            self.nav.pushViewController(vc, animated: true)
        }
    }
    @IBAction func search(_ sender: UIButton) {
        
        let vc = self.storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        guard self.checkPresence(of: vc) == false else{
            return
        }
        DispatchQueue.main.async {
            self.closeview()
            self.nav.pushViewController(vc, animated: true)
        }
    }
    @IBAction func ranking(_ sender: UIButton) {
        let vc = self.storyboard.instantiateViewController(withIdentifier: "RankingViewController") as! RankingViewController
        guard self.checkPresence(of: vc) == false else{
            return
        }
        DispatchQueue.main.async {
            self.closeview()
            self.nav.pushViewController(vc, animated: true)
        }    }
    
    @IBAction func upload(_ sender: UIButton) {
        
        let vc = self.storyboard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        guard self.checkPresence(of: vc) == false else{
            return
        }
        DispatchQueue.main.async {
            self.closeview()
            self.nav.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func menuBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            
            self.menuViewShort.isHidden = true
            
            self.frame  = CGRect(x: -75, y:(self.superview?.frame.size.height)! - 185, width: 175, height: 200)
                                //self.buttonGradient.colors = [ orange.cgColor,purple.cgColor,blue.cgColor,green.cgColor]
                //self.buttonGradient.frame = self.buttonoutlet.bounds
               // self.buttonoutlet.layer.insertSublayer(self.buttonGradient, at: 0)
                //self.changeleading.constant = 10
                self.largeWhite.isHidden = true
                self.smallGradient.isHidden = true
                self.largeGradient.isHidden = false
            self.buttonView.isHidden = true
               // self.backOutlet.isHidden = false
            self.homebtn_1.setImage(#imageLiteral(resourceName: "imghome"), for: .normal)

            
        }
    }
    

}
