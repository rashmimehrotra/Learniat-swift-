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
    func setdelegate(_ delegate:AnyObject)
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
        
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
       
        
        let seperatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height-1, width: 400, height: 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
        let headerlabel = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 50))
        headerlabel.text = kOverlayScribble
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: headerView.frame.size.width - 210, y: 0, width: 200, height: 50))
        mDoneButton.addTarget(self, action: #selector(ScribbleQuestionInfoScreen.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        ScribbleImageView.frame = CGRect(x: 0,y: 50, width: 400, height: 267)
        self.view.addSubview(ScribbleImageView)

        if let scribble = questionDetails.object(forKey: "Scribble") as? String
        {
            showScribbleWithDetails(scribble)
        }
        
    }
    
    
    
    
    var _Popover:UIPopoverController!
    
    func setPopover(_ popover:UIPopoverController)
    {
        _Popover = popover
    }
    
    func popover()-> UIPopoverController
    {
        return _Popover
    }
    
    func onDoneButton()
    {
       popover().dismiss(animated: true)
        
    }
    
    
    
    func setScribbleInfoDetails(_ details:AnyObject)
    {
        questionDetails = details
    }
    func showScribbleWithDetails(_ Url:String)
    {
       
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
        
        if let checkedUrl = URL(string: "\(urlString)/\(Url)")
        {
            ScribbleImageView.contentMode = .scaleAspectFit
            ScribbleImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }

        
        
    }
    
}
