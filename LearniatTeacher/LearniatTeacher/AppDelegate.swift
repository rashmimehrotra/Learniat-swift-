//
//  AppDelegate.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import UIKit
import HockeySDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var appState:String = "Active"  //Active/TakenOver

    
    internal  static let sharedDataSource = AppDelegate()
    
    var interntDownImageView : InternetConnection!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        
        
        print(applicationDocumentsDirectory)
        
        
        let  lagFreeField = UITextField();
        window!.addSubview(lagFreeField)
        lagFreeField.becomeFirstResponder();
        lagFreeField.resignFirstResponder();
        lagFreeField.removeFromSuperview()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
         let eraseWidth = UserDefaults.standard.float(forKey: "selectedEraserSize")
        if eraseWidth < 25
        {
            UserDefaults.standard.set(25, forKey: "selectedEraserSize")
        }
        
        
        let brushWith = UserDefaults.standard.float(forKey: "selectedBrushsize")
        if brushWith < 8
        {
            UserDefaults.standard.set(8, forKey: "selectedBrushsize")
        }
        
        
        
        
        BITHockeyManager.shared().configure(withIdentifier: "2416e4efc85e4c2dab6b12f45e7f0335")
        // Do some additional configuration if needed here
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()

        
        URLPrefix = Config.sharedInstance.getPhpUrl()
        
        
        SSTeacherMessageHandler.sharedMessageHandler.Error_NotConnectedToInternetSignal.subscribe(on: self) { (isSuccess) in
            if(isSuccess == true)
            {
                self.hideReconnecting()
            }
            else
            {
                if (UserDefaults.standard.object(forKey: kPassword) as? String) != nil
                {
                    if AppDelegate.appState == "Active"{
                        self.showReconnecting()
                    }
                    else if AppDelegate.appState == "TakenOver"{
                        let alertController = UIAlertController(title: "Disconnected", message: "Login from other device detected ", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Reconnect", style: UIAlertActionStyle.default, handler: { action in
                            self.handleReconnect()}))
                        alertController.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler: {action in self.handleLogout()}))
                        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()
                        alertWindow.windowLevel = UIWindowLevelAlert + 1;
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                        
                    }
                }
               
            }
            
        }

        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        print(documentsPath)
        
        return true
    }
    
    func handleReconnect(){
        SSTeacherMessageHandler.sharedMessageHandler.performReconnet(connectType: "Reconnect")
        AppDelegate.appState = "Active"
        
    }
    
    
    func handleLogout(){
        if UserDefaults.standard.object(forKey: kPassword) != nil
        {
            UserDefaults.standard.removeObject(forKey: kPassword)
        }
        
        
        SSTeacherMessageHandler.sharedMessageHandler.goOffline()
        
        if let uiViewController = AppDelegate.getTopViewController() as? TeacherScheduleViewController {
            uiViewController.performSegue(withIdentifier: "ScheduleToLogin", sender: nil)
        }
        else if let uiViewController = AppDelegate.getTopViewController() as? SSTeacherClassView {
            uiViewController.performSegue(withIdentifier: "ClassToLogin", sender: nil)
        }
        else if let uiViewController = AppDelegate.getTopViewController() as? AutoSeatAllocate {
            uiViewController.performSegue(withIdentifier: "AutoAllocateToLogin", sender: nil)
        }
        else if let uiViewController = AppDelegate.getTopViewController() as? PreallocateSeatViewController {
            uiViewController.performSegue(withIdentifier: "PreAllocateToLogin", sender: nil)
        }
        else if let uiViewController = AppDelegate.getTopViewController() as? SetUpClassRoom
            {
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController : LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                uiViewController.present(loginViewController, animated: true, completion: nil)
        }
        else if let uiViewController = AppDelegate.getTopViewController() as? SetupGridview
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController : LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            uiViewController.present(loginViewController, animated: true, completion: nil)
        }

        

    }
    
    
    
    static func getTopViewController() -> UIViewController {
        
        var viewController = UIViewController()
        
        if let vc =  UIApplication.shared.delegate?.window??.rootViewController {
            
            viewController = vc
            var presented = vc
            
            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
        }
        
        return viewController
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func showReconnecting()
    {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window
        {
            
            if interntDownImageView == nil{
                
                interntDownImageView = InternetConnection.instanceFromNib() as! InternetConnection
                interntDownImageView.frame = CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height)
                window.addSubview(interntDownImageView)
                
            }
            window.bringSubview(toFront: interntDownImageView)
        }
        
        if interntDownImageView != nil
        {
            interntDownImageView.isHidden = false
            interntDownImageView.stopLoading()
            
        }
        
        
    }
    
    
    func hideReconnecting()
    {
        if interntDownImageView != nil
        {
            interntDownImageView.stopLoading()
            interntDownImageView.isHidden = true
            
        }
        
        
        
    }
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    
    


}

