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
        
        
        self.view.backgroundColor = darkBackgroundColor
        
        let appLogo = UIImageView(frame: CGRectMake((self.view.frame.size.width - 80 )/2, 80, 80, 80))
        appLogo.image = UIImage(named:"Student_app_icon.png")
        self.view.addSubview(appLogo)
        
        mContainerView = UIView(frame: CGRectMake((self.view.frame.size.width - 300 )/2, 200, 300,200))
        mContainerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(mContainerView)
        
        
        mUserName = UITextField(frame: CGRectMake(10,10,280,40))
        mUserName.placeholder = "Username"
        mContainerView.addSubview(mUserName)
        mUserName.borderStyle = .RoundedRect
        mUserName.delegate  = self
        mUserName.autocapitalizationType = .None
        mUserName.autocorrectionType = .No
        
        mPassword = UITextField(frame: CGRectMake(10,mUserName.frame.origin.y + mUserName.frame.size.height + 20,280,40))
        mPassword.placeholder = "Password"
        mContainerView.addSubview(mPassword)
        mPassword.borderStyle = .RoundedRect
        mPassword.delegate  = self
        mPassword.autocapitalizationType = .None
        mPassword.autocorrectionType = .No
        mPassword.secureTextEntry = true
        
        
        mSignUpButton =  UIButton(frame: CGRectMake(10, mPassword.frame.origin.y + mPassword.frame.size.height + 20, 120,40))
        mContainerView.addSubview(mSignUpButton)
        mSignUpButton.setTitleColor(standard_Green, forState: .Normal)
        mSignUpButton.layer.borderColor = standard_Green.CGColor
        mSignUpButton.layer.borderWidth = 1
        mSignUpButton.layer.masksToBounds = true
        mSignUpButton.layer.cornerRadius = 5
        mSignUpButton.setTitle("Sign Up", forState: .Normal)
        mSignUpButton.titleLabel?.font = UIFont(name:helveticaMedium, size: 20)
        mSignUpButton.addTarget(self, action: #selector(LoginViewController.onSignUpButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        mLoginButton =  UIButton(frame: CGRectMake(mContainerView.frame.size.width - 130, mPassword.frame.origin.y + mPassword.frame.size.height + 20, 120,40))
        mContainerView.addSubview(mLoginButton)
        mLoginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mLoginButton.layer.borderColor = UIColor.whiteColor().CGColor
        mLoginButton.layer.borderWidth = 1
        mLoginButton.layer.masksToBounds = true
        mLoginButton.layer.cornerRadius = 5
        mLoginButton.setTitle("Login", forState: .Normal)
        mLoginButton.titleLabel?.font = UIFont(name:helveticaMedium, size: 20)
        mLoginButton.addTarget(self, action: #selector(LoginViewController.onLoginButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        mActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        mActivityIndicator.frame = CGRectMake(mContainerView.frame.size.width - 40, mPassword.frame.origin.y + mPassword.frame.size.height + 30, 20,20)
        mContainerView.addSubview(mActivityIndicator)
        mActivityIndicator.hidden = true
        
        
        
        
        
        mActivityIndicator.hidden = true
        
        
        
        
        if let password  =  NSUserDefaults.standardUserDefaults().objectForKey(kPassword) as? String
        {
            if  let userName = NSUserDefaults.standardUserDefaults().objectForKey(kUserName) as? String
            {
                mUserName.text = userName
                mPassword.text  = password
                
                if let userId = NSUserDefaults.standardUserDefaults().objectForKey(kUserId) as? String
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
        
        
        INILoader.sharediniLoader.loadNewFileFromServer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func onLoginButton(sender: UIButton)
    {
        if mUserName.text!.isEmpty || mPassword.text!.isEmpty
        {
            loginButtonPressed(false)
        }
        else
        {
            loginButtonPressed(true)
            SSStudentDataSource.sharedDataSource.LoginWithUserId(mUserName.text!, andPassword: mPassword.text!, withDelegate: self)
        }
    }
    
    
    func onSignUpButton(sender: UIButton)
    {
        
    }
    
    
    
    func loginButtonPressed(state:Bool)
    {
        if state == true
        {
            mUserName.enabled = false
            mPassword.enabled = false
            mLoginButton.enabled = false
            mSignUpButton.enabled = false
            mActivityIndicator.hidden = false
            mActivityIndicator.startAnimating()
            
            mSignUpButton.setTitleColor(lightGrayColor, forState: .Normal)
            mSignUpButton.layer.borderColor = lightGrayColor.CGColor
            
            mLoginButton.setTitleColor(lightGrayColor, forState: .Normal)
            mLoginButton.layer.borderColor = lightGrayColor.CGColor
            
        }
        else
        {
            
            mUserName.enabled = true
            mPassword.enabled = true
            mLoginButton.enabled = true
            mSignUpButton.enabled = true
            mActivityIndicator.hidden = true
            mActivityIndicator.stopAnimating()
            
            mSignUpButton.setTitleColor(standard_Green, forState: .Normal)
            mSignUpButton.layer.borderColor = standard_Green.CGColor
            
            mLoginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            mLoginButton.layer.borderColor = UIColor.whiteColor().CGColor
            
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
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
    
    
    func didGetloginWithDetails(details: AnyObject)
    {
        if let status = details.objectForKey("Status") as? String
        {
            if status == kSuccessString
            {
                if let currentUserid = details.objectForKey("UserId") as? String
                {
                    SSStudentDataSource.sharedDataSource.currentUserId = currentUserid
                    NSUserDefaults.standardUserDefaults().setObject(currentUserid, forKey: kUserId)
                    SSStudentMessageHandler.sharedMessageHandler.connectWithUserId(currentUserid, andWithPassword: mPassword.text!, withDelegate: self)
                }
                if let currentSchoolId = details.objectForKey("SchoolId") as? String
                {
                    SSStudentDataSource.sharedDataSource.currentSchoolId = currentSchoolId
                }
            }
            else
            {
                self.view.makeToast(status, duration: 2.0, position: .Bottom)
                loginButtonPressed(false)
            }
        }
        else
        {
            self.view.makeToast("User name or password is incorrect, please try again. ", duration: 2.0, position: .Bottom)
            loginButtonPressed(false)
        }
        
        
        
    }
    
    func didGetUserStateWithDetails(details: AnyObject) {
        
        if let userState = details.objectForKey("UserState") as? String
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
    func didgetErrorMessage(message: String, WithServiceName serviceName: String)
    {
        self.view.makeToast(message, duration: 2.0, position: .Bottom)
        loginButtonPressed(false)
        
    }
    
    func smhDidRecieveStreamConnectionsState(state: Bool)
    {
        if state == false
        {
            self.view.makeToast("Stream disconnected ", duration: 2.0, position: .Bottom)
            loginButtonPressed(false)
            
        }
        
    }
    
    func smhDidReciveAuthenticationState(state: Bool, WithName userName: String)
    {
        if state == true
        {
            SSStudentDataSource.sharedDataSource.currentUserName = mUserName.text!
            SSStudentDataSource.sharedDataSource.currentPassword = mPassword.text!
            NSUserDefaults.standardUserDefaults().setObject(mUserName.text!, forKey: kUserName)
            NSUserDefaults.standardUserDefaults().setObject(mPassword.text!, forKey: kPassword)
            
            SSStudentDataSource.sharedDataSource.updateStudentStatus(kUserStateFree, ofSession: "", withDelegate: self)
            
            performSegueWithIdentifier("LoginSuccessSegue", sender: nil)
        }
        else
        {
            self.view.makeToast("User id or password is incorrect, please try again. ", duration: 2.0, position: .Bottom)
            loginButtonPressed(false)
        }
    }
    
    
    
}

