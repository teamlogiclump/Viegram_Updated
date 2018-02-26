//
//  AppDelegate.swift
//  Viegram
//
//  Created by Apple on 5/24/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit
import GooglePlaces
import IQKeyboardManager
import Lottie
import UserNotifications

import SwiftyJSON
import SwiftyNotifications
import Fabric
import Crashlytics
import AVFoundation
let appDelegates = UIApplication.shared.delegate as! AppDelegate
var standard = UserDefaults.standard
let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!

var mainurl = "http://107.6.9.5/~viegram/apis/"
//var mainurl = "http://nationproducts.in/viegram/apis/"
let termsconditions = "http://18.221.232.102/viegram_pages/terms_condition.html"

let howitworks = "http://www.viegram.com/viegram_pages/viegram_work.html"

var animationView = LOTAnimationView(name: "loading_rainbow")
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var navcon = UINavigationController()

var temp = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        
        }
        
        UIApplication.shared.isStatusBarHidden = true
        
        GMSPlacesClient.provideAPIKey("AIzaSyBSjYsAXRiAyeinGgEFEiR8XZE5Aak6sEQ")
        
        
        if standard.value(forKey: "user_id")  as? String == "" ||  standard.value(forKey: "user_id")   == nil {
            SignInView()
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:"HomeViewController")
            
            navcon =  UINavigationController(rootViewController: vc)
            navcon.navigationBar.isTranslucent = false
            navcon.isNavigationBarHidden = true
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            self.window?.rootViewController = navcon
            
            self.window?.makeKeyAndVisible()
  
        }
        IQKeyboardManager.shared().isEnabled = true
        DBManager.shared.createDatabase()
        
        standard.set("false", forKey: "data")
        
        
        // Override point for customization after application launch.
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        return true
    }
    
    func SignInView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:"LoginViewController")
        
        navcon =  UINavigationController(rootViewController: vc)
        navcon.navigationBar.isTranslucent = false
        navcon.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.window?.rootViewController = navcon
        
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
       // gcm_id = deviceTokenString
        standard.setValue(deviceTokenString, forKey: "gcm")
        print(standard.value(forKey: "gcm") as! String)
        
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
       standard.setValue("11111", forKey: "gcm")
        
    }
     var notification = SwiftyNotifications()
    var status = String()
    var msg = String()
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
       
        
        let json = userInfo 
        print(json)
         status =    ((json["aps"] as! [String:Any])["status"]! as! String)
        
        msg =    ((json["aps"] as! [String:Any])["alert"]! as! String)
        
        if application.applicationState == .active{
            
            temp = 1
            notification = SwiftyNotifications.withStyle(style: .custom,
                                                         title: "New Notification",
                                                         subtitle: "\(msg)",
                dismissDelay: 5.0)
            self.window?.rootViewController?.view.addSubview(notification)
            notification.show()
            
            notification.setCustomColors(backgroundColor: apppurple, textColor: UIColor.white)
            notification.isMultipleTouchEnabled = false
            notification.alpha = 1
            notification.subtitleLabel.font = UIFont(name: "Avenir-Light", size: 12.0)
            notification.leftAccessoryView.image = UIImage(named: "logo")!
        }else{
       
    
        
        
        if self.status as String == "1" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
            vc.postid = (((json["aps"] as! [String:Any])["postid"]! as! String))
           vc.userid =  standard.value(forKey: "user_id")! as! String
            
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
 
            
        }else if self.status as String == "2" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
            
            vc.repostid =  (((json["aps"] as! [String:Any])["postid"]! as! String))
           
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            navcon.pushViewController(vc, animated: true)
            
 
            
        }
        
        else if self.status as String == "3" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
             vc.repostid =  (((json["aps"] as! [String:Any])["postid"]! as! String))
           
           
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
 
            
        }
        
        else if self.status as String == "4" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            vc.postidNoti = ((json["aps"] as! [String:Any])["userid"]! as! String)
            vc.bool = true
         
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
 
            
        }
        
        else if self.status as String == "5"{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
            
            vc.userid = ((json["aps"] as! [String:Any])["userid"]! as! String)
             vc.status = ((json["aps"] as! [String:Any])["status"]! as! String)
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
 
            
            
        }
        else if self.status as String == "6"{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
            
            vc.guest_id = ((json["aps"] as! [String:Any])["userid"]! as! String)
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            
 
            
        }
        else  if self.status as String == "7"{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
            
            vc.guest_id = ((json["aps"] as! [String:Any])["userid"]! as! String)
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
            

        } else  if self.status as String == "8"{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
            
            vc.repostid =  (((json["aps"] as! [String:Any])["postid"]! as! String))
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            navcon.pushViewController(vc, animated: true)
        }
        else
        {
           
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
            vc.postid = (((json["aps"] as! [String:Any])["postid"]! as! String))
            vc.userid =  standard.value(forKey: "user_id")! as! String
            
            
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
            //            vc.strSenderId = json.value(forKey: "sender_id") as! String
            navcon.pushViewController(vc, animated: true)
        }
        
       
            notification.addTouchHandler(touchHandler: {
                temp = 1
               
                if self.status as String == "1" {
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
                    vc.postid = (((json["aps"] as! [String:Any])["postid"]! as! String))
                    vc.userid =  standard.value(forKey: "user_id")! as! String
                    
                    
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    
                    //            vc.strSenderId = json.value(forKey: "sender_id") as! String
                    navcon.pushViewController(vc, animated: true)
                    
                    
                    
                }else if self.status as String == "2" {
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
                    
                    vc.repostid =  (((json["aps"] as! [String:Any])["postid"]! as! String))
                    
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    navcon.pushViewController(vc, animated: true)
                    
                    
                    
                }
                    
                else if self.status as String == "3" {
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
                    vc.repostid =  (((json["aps"] as! [String:Any])["postid"]! as! String))
                    
                    
                    
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    
                    //            vc.strSenderId = json.value(forKey: "sender_id") as! String
                    navcon.pushViewController(vc, animated: true)
                    
                    
                }
                    
                else if self.status as String == "4" {
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    
                    vc.postidNoti = ((json["aps"] as! [String:Any])["userid"]! as! String)
                    vc.bool = true
                    
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    
                    //            vc.strSenderId = json.value(forKey: "sender_id") as! String
                    navcon.pushViewController(vc, animated: true)
                    
                    
                    
                }
                    
                else if self.status as String == "5"{
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
                    
                    vc.userid = ((json["aps"] as! [String:Any])["userid"]! as! String)
                    vc.status = ((json["aps"] as! [String:Any])["status"]! as! String)
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    
                    //            vc.strSenderId = json.value(forKey: "sender_id") as! String
                    navcon.pushViewController(vc, animated: true)
                    
                    
                    
                    
                }
                else if self.status as String == "6"{
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
                    
                    vc.guest_id = ((json["aps"] as! [String:Any])["userid"]! as! String)
                    
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    
                    //            vc.strSenderId = json.value(forKey: "sender_id") as! String
                    navcon.pushViewController(vc, animated: true)
                    
                    
                    
                }
                else  if self.status as String == "7"{
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserProfileViewController") as! AuserProfileViewController
                    
                    vc.guest_id = ((json["aps"] as! [String:Any])["userid"]! as! String)
                    
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    
                    //            vc.strSenderId = json.value(forKey: "sender_id") as! String
                    navcon.pushViewController(vc, animated: true)
                    
                    
                } else  if self.status as String == "8"{
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuserCommentViewController") as! AuserCommentViewController
                    
                    vc.repostid =  (((json["aps"] as! [String:Any])["postid"]! as! String))
                    
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    navcon.pushViewController(vc, animated: true)
                }
                else
                {
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "openphotoViewController") as! openphotoViewController
                    vc.postid = (((json["aps"] as! [String:Any])["postid"]! as! String))
                    vc.userid =  standard.value(forKey: "user_id")! as! String
                    
                    
                    
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                    
                    //            vc.strSenderId = json.value(forKey: "sender_id") as! String
                    navcon.pushViewController(vc, animated: true)
                }
                
            })
        
        
        }
        
    }

}

