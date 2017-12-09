//
//  AppDelegate.swift
//  LearniatStudent
//
//  Created by Deepak MK on 22/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //declare this property where it won't go out of scope relative to your listener
    let reachability = Reachability()!

    
    //Testing code
    internal  static let sharedDataSource = AppDelegate()
    
    var interntDownImageView : InternetConnection!
    static var appState:String = "Active"  //Active/TakenOver
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        addNotifiersForReachability()
        
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
            let eraseWidth = UserDefaults.standard.float(forKey: "selectedEraserSize")
            if eraseWidth < 25 {
                UserDefaults.standard.set(25, forKey: "selectedEraserSize")
            }
            
            let brushWith = UserDefaults.standard.float(forKey: "selectedBrushsize")
            if brushWith < 8 {
                UserDefaults.standard.set(8, forKey: "selectedBrushsize")
            }
        }
        
        SSStudentMessageHandler.sharedMessageHandler.Error_NotConnectedToInternetSignal.subscribe(on: self)   { (isSuccess) in
            if(isSuccess == true) {
               self.hideReconnecting()
            } else {
                if (UserDefaults.standard.object(forKey: kPassword) as? String) != nil {
                    if AppDelegate.appState == "Active"{
//                        self.showReconnecting()
                    }
                    else if AppDelegate.appState == "TakenOver"{
                        let alertController = UIAlertController(title: "Disconnected", message: "Logged in from other device detected ", preferredStyle: UIAlertControllerStyle.alert)
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
        URLPrefix = Config.sharedInstance.getPhpUrl()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentsPath)
      
        return true
    }
    
    private func addNotifiersForReachability() {
        reachability.whenReachable = { reachability in
            self.hideReconnecting()
            self.handleReconnect()
        }
        
        reachability.whenUnreachable = { _ in
            self.showReconnecting()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    func handleReconnect(){
        SSStudentMessageHandler.sharedMessageHandler.performReconnet(connectType: "Reconnect")
        AppDelegate.appState = "Active"

    }
    
    
    func handleLogout(){
        if UserDefaults.standard.object(forKey: kPassword) != nil
        {
            UserDefaults.standard.removeObject(forKey: kPassword)
        }
        
        
        SSStudentMessageHandler.sharedMessageHandler.goOffline()
        
        if let uiViewController = AppDelegate.getTopViewController() as? SSStudentScheduleViewController {
            uiViewController.performSegue(withIdentifier: "ScheduleToLogin", sender: nil)
        }
        else if let uiViewController = AppDelegate.getTopViewController() as? StudentClassViewController {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController : LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            uiViewController.present(loginViewController, animated: true, completion: nil)
        }
        else if let uiViewController = AppDelegate.getTopViewController() as? StudentSeatViewController {
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
        
        SSStudentDataSource.sharedDataSource.isBackgroundSignal.fire(true)
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
      
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        SSStudentDataSource.sharedDataSource.isBackgroundSignal.fire(false)
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if SSStudentDataSource.sharedDataSource.currentUserId != nil {
            RealmDatasourceManager.saveScreenStateOfUser(screenState: .LoginScreen, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
        }
    }
    
    var blueScreenStatus = 0

    
    func showReconnecting(){
        if blueScreenStatus == 2{
            hideReconnecting()
            blueScreenStatus = 0
        }

        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            blueScreenStatus = 1

            if interntDownImageView == nil{
                interntDownImageView = InternetConnection.fromNib(nibName:"InternetDisconnected") as! InternetConnection
                interntDownImageView.frame = CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height)
                window.addSubview(interntDownImageView)
            }
            window.bringSubview(toFront: interntDownImageView)
        }
        
        if interntDownImageView != nil {
            interntDownImageView.isHidden = false
            interntDownImageView.stopLoading()
        }
    }
    
    func showReconnectingStream(){
        if blueScreenStatus == 0{

        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            blueScreenStatus = 2

            if interntDownImageView == nil{
                interntDownImageView = InternetConnection.fromNib(nibName:"InternetDisconnected") as! InternetConnection
                interntDownImageView.frame = CGRect(x: 0, y: 0, width: window.frame.size.width/2, height: window.frame.size.height/2)
                window.addSubview(interntDownImageView)
            }
            window.bringSubview(toFront: interntDownImageView)
        }
        
        if interntDownImageView != nil {
            interntDownImageView.isHidden = false
            interntDownImageView.stopLoading()
        }
    }
    }
    
    func showTakenOver() {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            if interntDownImageView == nil{
                interntDownImageView = InternetConnection.fromNib(nibName:"InternetDisconnected") as! InternetConnection
                interntDownImageView.frame = CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height)
            }
            interntDownImageView.mRetryButton.setTitle("Reconnect", for : .normal)
            window.addSubview(interntDownImageView)
            window.bringSubview(toFront: interntDownImageView)
        }
        
        if interntDownImageView != nil{
            interntDownImageView.isHidden = false
            interntDownImageView.stopLoading()
        }
    }
    
    func hideReconnecting() {
        if interntDownImageView != nil {
            interntDownImageView.stopLoading()
            interntDownImageView.isHidden = true
        }
        blueScreenStatus = 0

    }
    
    
    
    
}

