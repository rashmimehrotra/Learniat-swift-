//
//  ScribbleQuestionInfoScreen.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class ScribbleQuestionInfoScreen : UIViewController
{
    
    var _delgate: AnyObject!
    
    var questionDetails :AnyObject!
    
    var  ScribbleImageView = CustomProgressImageView()
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        
        let headerView = UIView(frame: CGRectMake(0, 0, 400, 50))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
       
        
        let seperatorView = UIView(frame: CGRectMake(0, headerView.frame.size.height-1, 400, 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
        let headerlabel = UILabel(frame: CGRectMake(10, 0, 200, 50))
        headerlabel.text = kOverlayScribble
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .Left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(headerView.frame.size.width - 210, 0, 200, 50))
        mDoneButton.addTarget(self, action: #selector(ScribbleQuestionInfoScreen.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        ScribbleImageView.frame = CGRectMake(0,50, 400, 267)
        self.view.addSubview(ScribbleImageView)

        if let scribble = questionDetails.objectForKey("Scribble") as? String
        {
            showScribbleWithDetails(scribble)
        }
        
    }
    
    
    
    
    var _Popover:AnyObject!
   
    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }
    func onDoneButton()
    {
        popover().dismissPopoverAnimated(true)
        
    }
    
    
    
    func setScribbleInfoDetails(details:AnyObject)
    {
        questionDetails = details
    }
    func showScribbleWithDetails(Url:String)
    {
       
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(Url)")
        {
            ScribbleImageView.contentMode = .ScaleAspectFit
            ScribbleImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }

        
        
    }
    
}