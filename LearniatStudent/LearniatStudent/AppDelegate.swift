//
//  AppDelegate.swift
//  LearniatStudent
//
//  Created by Deepak MK on 22/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    
    internal  static let sharedDataSource = AppDelegate()
    
    var interntDownImageView : InternetConnection!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
      
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
            
            
            
            BITHockeyManager.shared().configure(withIdentifier: "ce977544acdf4b57a1ae4cf70b06dd2c")
            // Do some additional configuration if needed here
            BITHockeyManager.shared().start()
            BITHockeyManager.shared().authenticator.authenticateInstallation()
            BITHockeyManager.shared().isCrashManagerDisabled = true
            
            
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
        }
        
        
        SSStudentMessageHandler.sharedMessageHandler.Error_NotConnectedToInternetSignal.subscribe(on: self) { (isSuccess) in
            if(isSuccess == true)
            {
               self.hideReconnecting()
            }
            else
            {
                if (UserDefaults.standard.object(forKey: kPassword) as? String) != nil
                {
                    self.showReconnecting()
                }
            }
            
        }
      
       
        URLPrefix = Config.sharedInstance.getPhpUrl()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentsPath)
      
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        SSStudentDataSource.sharedDataSource.isBackgroundSignal.fire(true)
        
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
        
        
        SSStudentDataSource.sharedDataSource.isBackgroundSignal.fire(false)
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        if SSStudentDataSource.sharedDataSource.currentUserId != nil {
            RealmDatasourceManager.saveScreenStateOfUser(screenState: .LoginScreen, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
        }
        
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
    
    
    
    
}

