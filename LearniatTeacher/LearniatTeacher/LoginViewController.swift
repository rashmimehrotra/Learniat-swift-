//
//  LoginViewController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

/* 
 In This class We are trying to connect learniat server as well as Xmpp server
 
	onLoginButton : When button pressed we are disabling all textField and 	fire API “Login”
 
	If the status is success returned from “Login” Api we are trying to connect XMPP with UserId returned from Api and password
 
	If Xmpp is also connected then we are showing schedule screen

*/




import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate,SSTeacherDataSourceDelegate,SSTeacherMessagehandlerDelegate
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
        
        
        self.view.backgroundColor = whiteBackgroundColor
        
        
        let appLogo = UIImageView(frame: CGRect(x: (self.view.frame.size.width - 80 )/2, y: 80, width: 80, height: 80))
        appLogo.image = UIImage(named:"Teacher _app_icon.png")
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
        mLoginButton.setTitleColor(standard_Button, for: UIControlState())
        mLoginButton.layer.borderColor = standard_Button.cgColor
        mLoginButton.layer.borderWidth = 1
        mLoginButton.layer.masksToBounds = true
        mLoginButton.layer.cornerRadius = 5
        mLoginButton.setTitle("Login", for: UIControlState())
        mLoginButton.titleLabel?.font = UIFont(name:helveticaMedium, size: 20)
        mLoginButton.addTarget(self, action: #selector(LoginViewController.onLoginButton(_:)), for: UIControlEvents.touchUpInside)
        
        mActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        mActivityIndicator.frame = CGRect(x: mContainerView.frame.size.width - 40, y: mPassword.frame.origin.y + mPassword.frame.size.height + 30, width: 20,height: 20)
        mContainerView.addSubview(mActivityIndicator)
        mActivityIndicator.isHidden = true
        
        
        
        

        mActivityIndicator.isHidden = true
        
        
        
        if  let userName = UserDefaults.standard.object(forKey: kUserName) as? String
        {
             mUserName.text = userName
            
            
           if let password  =  UserDefaults.standard.object(forKey: kPassword) as? String
           {
            
                mPassword.text  = password
            
               if let userId = UserDefaults.standard.object(forKey: kUserId) as? String
               {
                SSTeacherDataSource.sharedDataSource.setdelegate(self)
                SSTeacherDataSource.sharedDataSource.getUserState(userId, withDelegate: self)
                loginButtonPressed(true)
                
            }
            
            }
        }
        else
        {
            loginButtonPressed(false)
        }
        
        
        
       let mAppVersionNumber = UILabel(frame: CGRect(x: appLogo.frame.origin.x + appLogo.frame.size.width , y: appLogo.frame.origin.y,width: 300,height: 60))
        
        self.view.addSubview(mAppVersionNumber)
        mAppVersionNumber.textAlignment = .right
        mAppVersionNumber.textColor = UIColor.black
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        {
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            
            
            mAppVersionNumber.text = "V = \(version).".appending(buildNumber)
        }
        
        
        INILoader.sharediniLoader.loadNewFileFromServer()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func onLoginButton(_ sender: UIButton)
    {
        if mUserName.text!.isEmpty || mPassword.text!.isEmpty
        {
             loginButtonPressed(false)
        }
        else
        {
           loginButtonPressed(true)
           SSTeacherDataSource.sharedDataSource.LoginWithUserId(mUserName.text!, andPassword: mPassword.text!, withDelegate: self)
        }
    }
   
    
    func onSignUpButton(_ sender: UIButton)
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
           
            mLoginButton.setTitleColor(standard_Button, for: UIControlState())
            mLoginButton.layer.borderColor = standard_Button.cgColor

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
    
    
    func didGetloginWithDetails(_ details: AnyObject)
    {
        
        print(details)
        if let status = details.object(forKey: "Status") as? String
        {
            if status == kSuccessString
            {
               if let currentUserid = details.object(forKey: "UserId") as? Int
               {
                    SSTeacherDataSource.sharedDataSource.currentUserId = "\(currentUserid)"
                    UserDefaults.standard.set(currentUserid, forKey: kUserId)
                    SSTeacherMessageHandler.sharedMessageHandler.connectWithUserId("\(currentUserid)", andWithPassword: mPassword.text!, withDelegate: self)
                }
                if let currentSchoolId = details.object(forKey: "SchoolId") as? String
                {
                    SSTeacherDataSource.sharedDataSource.currentSchoolId = currentSchoolId
                }
            }
            else
            {
               self.view.makeToast(status, duration: 5.0, position: .bottom)
                 loginButtonPressed(false)
            }
        }
        else
        {
            self.view.makeToast("User name or password is incorrect, please try again. ", duration: 5.0, position: .bottom)
             loginButtonPressed(false)
        }
        
       
        
    }
    
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
        self.view.makeToast(message, duration: 5.0, position: .bottom)
        loginButtonPressed(false)
        
    }
    
    func smhDidRecieveStreamConnectionsState(_ state: Bool)
    {
        if state == false
        {
            self.view.makeToast("Stream disconnected ", duration: 5.0, position: .bottom)
            loginButtonPressed(false)

        }
        
    }
    
    func smhDidReciveAuthenticationState(_ state: Bool, WithName userName: String)
    {
        if state == true
        {
            SSTeacherDataSource.sharedDataSource.currentUserName = mUserName.text!
            SSTeacherDataSource.sharedDataSource.currentPassword = mPassword.text!
            UserDefaults.standard.set(mUserName.text!, forKey: kUserName)
            UserDefaults.standard.set(mPassword.text!, forKey: kPassword)
            
            performSegue(withIdentifier: "LoginSuccessSegue", sender: nil)
        }
       else
        {
            self.view.makeToast("User id or password is incorrect in Xmpp server, please try again. ", duration: 5.0, position: .bottom)
            loginButtonPressed(false)
        }
    }
    
    
    
}

