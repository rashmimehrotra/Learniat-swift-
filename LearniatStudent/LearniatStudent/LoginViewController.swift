//
//  ViewController.swift
//  LearniatStudent
//
//  Created by Deepak MK on 22/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate,SSStudentDataSourceDelegate,SSStudentMessageHandlerDelegate
{
    
    
    var mUserName: UITextField!
    var mPassword: UITextField!
    var mSignUpButton: UIButton!
    var mLoginButton: UIButton!
    var mContainerView: UIView!
    var mActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SSStudentDataSource.sharedDataSource.currentScreen = .LoginScreen
        self.view.backgroundColor = darkBackgroundColor
        
        let appLogo = UIImageView(frame: CGRect(x: (self.view.frame.size.width - 80 )/2, y: 80, width: 80, height: 80))
        appLogo.image = UIImage(named:"Student_app_icon.png")
        self.view.addSubview(appLogo)
        
        mContainerView = UIView(frame: CGRect(x: (self.view.frame.size.width - 300 )/2, y: 200, width: 300,height: 200))
        mContainerView.backgroundColor = UIColor.clear
        self.view.addSubview(mContainerView)
        
        
        mUserName = UITextField(frame: CGRect(x: 10,y: 10,width: 280,height: 40))
        mUserName.placeholder = "Username"
        mContainerView.addSubview(mUserName)
        mUserName.borderStyle = .roundedRect
        mUserName.delegate  = self
        mUserName.autocapitalizationType = .none
        mUserName.autocorrectionType = .no
        
        mPassword = UITextField(frame: CGRect(x: 10,y: mUserName.frame.origin.y + mUserName.frame.size.height + 20,width: 280,height: 40))
        mPassword.placeholder = "Password"
        mContainerView.addSubview(mPassword)
        mPassword.borderStyle = .roundedRect
        mPassword.delegate  = self
        mPassword.autocapitalizationType = .none
        mPassword.autocorrectionType = .no
        mPassword.isSecureTextEntry = true
        
        
        mSignUpButton =  UIButton(frame: CGRect(x: 10, y: mPassword.frame.origin.y + mPassword.frame.size.height + 20, width: 120,height: 40))
        mContainerView.addSubview(mSignUpButton)
        mSignUpButton.setTitleColor(standard_Green, for: UIControlState())
        mSignUpButton.layer.borderColor = standard_Green.cgColor
        mSignUpButton.layer.borderWidth = 1
        mSignUpButton.layer.masksToBounds = true
        mSignUpButton.layer.cornerRadius = 5
        mSignUpButton.setTitle("Sign Up", for: UIControlState())
        mSignUpButton.titleLabel?.font = UIFont(name:helveticaMedium, size: 20)
        mSignUpButton.addTarget(self, action: #selector(LoginViewController.onSignUpButton(_:)), for: UIControlEvents.touchUpInside)
        
        
        
        mLoginButton =  UIButton(frame: CGRect(x: mContainerView.frame.size.width - 130, y: mPassword.frame.origin.y + mPassword.frame.size.height + 20, width: 120,height: 40))
        mContainerView.addSubview(mLoginButton)
        mLoginButton.setTitleColor(UIColor.white, for: UIControlState())
        mLoginButton.layer.borderColor = UIColor.white.cgColor
        mLoginButton.layer.borderWidth = 1
        mLoginButton.layer.masksToBounds = true
        mLoginButton.layer.cornerRadius = 5
        mLoginButton.setTitle("Login", for: UIControlState())
        mLoginButton.titleLabel?.font = UIFont(name:helveticaMedium, size: 20)
        mLoginButton.addTarget(self, action: #selector(LoginViewController.onLoginButton(_:)), for: UIControlEvents.touchUpInside)
        
        mActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        mActivityIndicator.frame = CGRect(x: mContainerView.frame.size.width - 40, y: mPassword.frame.origin.y + mPassword.frame.size.height + 30, width: 20,height: 20)
        mContainerView.addSubview(mActivityIndicator)
        mActivityIndicator.isHidden = true
        
        
        
        
        mActivityIndicator.isHidden = true
        
        
        
        if let password  =  UserDefaults.standard.object(forKey: kPassword) as? String
        {
            if  let userName = UserDefaults.standard.object(forKey: kUserName) as? String
            {
                mUserName.text = userName
                mPassword.text  = password
                
                if let userId = UserDefaults.standard.object(forKey: kUserId) as? String
                {
                    SSStudentDataSource.sharedDataSource.getUserState(userId, withDelegate: self)
                    loginButtonPressed(true)
                    
                }
                
            }
        }
        else
        {
            loginButtonPressed(false)
        }
        
        
//        let mAppVersionNumber = UILabel(frame: CGRect(x: appLogo.frame.origin.x + appLogo.frame.size.width , y: appLogo.frame.origin.y,width: 300,height: 60))
//        
//        self.view.addSubview(mAppVersionNumber)
//        mAppVersionNumber.textAlignment = .right
        
        // By Ujjval
        // ==========================================
        
        let mAppVersionNumber = UILabel(frame: CGRect(x: (self.view.frame.size.width - 80)/2 , y: 170,width: 80,height: 30))
        
        self.view.addSubview(mAppVersionNumber)
        mAppVersionNumber.textAlignment = .center
        
        // ==========================================
        
        
        mAppVersionNumber.textColor = UIColor.white
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        {
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            
            
            mAppVersionNumber.text = "V = \(version).".appending(buildNumber)
        }
        
        
        INILoader.sharediniLoader.loadNewFileFromServer()
        
        RealmDatasourceManager.saveScreenStateOfUser(screenState: .LoginScreen, withUserId: "0")

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func onLoginButton(_ sender: UIButton)
    {
        if mUserName.text!.isEmpty || mPassword.text!.isEmpty
        {
            loginButtonPressed(false)
        }
        else
        {
            loginButtonPressed(true)
            
            SSStudentDataSource.sharedDataSource.LoginWithUserId(mUserName.text!, andPassword: mPassword.text!, withSuccessHandle: { (details) in
                
                if let status = details.object(forKey: kStatus) as? String
                {
                    if status == kSuccessString
                    {
                        if let currentUserid = details.object(forKey: kUserId) as? Int
                        {
                            SSStudentDataSource.sharedDataSource.currentUserId = "\(currentUserid)"
                            UserDefaults.standard.set("\(currentUserid)", forKey: kUserId)
                            SSStudentMessageHandler.sharedMessageHandler.connectWithUserId("\(currentUserid)", andWithPassword: self.mPassword.text!, withDelegate: self)
                        }
                        if let currentSchoolId = details.object(forKey: kSchoolId) as? String
                        {
                            SSStudentDataSource.sharedDataSource.currentSchoolId = currentSchoolId
                        }
                    }
                    else
                    {
                        if let error_message = details.object(forKey: kErrorMessage) as? String
                        {
                            self.view.makeToast(error_message, duration: 2.0, position: .bottom)
                        }
                        else
                        {
                            self.view.makeToast(status, duration: 2.0, position: .bottom)
                        }
                        
                        
                        self.loginButtonPressed(false)
                    }
                }
                else
                {
                    self.view.makeToast("User name or password is incorrect, please try again. ", duration: 2.0, position: .bottom)
                    self.loginButtonPressed(false)
                }

                
            }, withfailurehandler: { (error) in
                
                self.view.makeToast("Error\((error.code))-\((error.localizedDescription))", duration: 5.0, position: .bottom)
                self.loginButtonPressed(false)
            })
        }
    }
    
    
    @objc func onSignUpButton(_ sender: UIButton)
    {
        
    }
    
    
    
    func loginButtonPressed(_ state:Bool)
    {
        if state == true
        {
            mUserName.isEnabled = false
            mPassword.isEnabled = false
            mLoginButton.isEnabled = false
            mSignUpButton.isEnabled = false
            mActivityIndicator.isHidden = false
            mActivityIndicator.startAnimating()
            
            mSignUpButton.setTitleColor(lightGrayColor, for: UIControlState())
            mSignUpButton.layer.borderColor = lightGrayColor.cgColor
            
            mLoginButton.setTitleColor(lightGrayColor, for: UIControlState())
            mLoginButton.layer.borderColor = lightGrayColor.cgColor
            
        }
        else
        {
            
            mUserName.isEnabled = true
            mPassword.isEnabled = true
            mLoginButton.isEnabled = true
            mSignUpButton.isEnabled = true
            mActivityIndicator.isHidden = true
            mActivityIndicator.stopAnimating()
            
            mSignUpButton.setTitleColor(standard_Green, for: UIControlState())
            mSignUpButton.layer.borderColor = standard_Green.cgColor
            
            mLoginButton.setTitleColor(UIColor.white, for: UIControlState())
            mLoginButton.layer.borderColor = UIColor.white.cgColor
            
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
            
            
            
            onLoginButton(mLoginButton)
            
            
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    // MARK: - Teacher datasource Delegate
    
    func didGetUserStateWithDetails(_ details: AnyObject) {
        
        if let userState = details.object(forKey: "UserState") as? String
        {
            if userState == "Signedout"
            {
                loginButtonPressed(false)
            }
            else
            {
                onLoginButton(mLoginButton)
            }
        }
        else
        {
            onLoginButton(mLoginButton)
        }
        
    }
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String)
    {
        self.view.makeToast(message, duration: 2.0, position: .bottom)
        loginButtonPressed(false)
        
    }
    
    func smhDidRecieveStreamConnectionsState(_ state: Bool)
    {
        if state == false
        {
            self.view.makeToast("Stream disconnected ", duration: 2.0, position: .bottom)
            loginButtonPressed(false)
            
        }
        
    }
    
    func smhDidReciveAuthenticationState(_ state: Bool, WithName userName: String)
    {
        if state == true
        {
            
            
            SSStudentDataSource.sharedDataSource.updatUserState(state: UserStateInt.Free.rawValue, success: { (reslut) in
                
                SSStudentDataSource.sharedDataSource.currentUserName = self.mUserName.text!
                SSStudentDataSource.sharedDataSource.currentPassword = self.mPassword.text!
                UserDefaults.standard.set(self.mUserName.text!, forKey: kUserName)
                UserDefaults.standard.set(self.mPassword.text!, forKey: kPassword)
                self.performSegue(withIdentifier: "LoginSuccessSegue", sender: nil)
                
            }, withfailurehandler: { (error) in
                
                self.view.makeToast(error.description, duration: 2.0, position: .bottom)
                self.loginButtonPressed(false)
            })
        }
        else
        {
            self.view.makeToast("User id or password is incorrect in Xmpp server, please try again. ", duration: 2.0, position: .bottom)
            loginButtonPressed(false)
        }
    }
    
    
    
}

