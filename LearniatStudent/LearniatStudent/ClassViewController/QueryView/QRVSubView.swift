//
//  QRVSubView.swift
//  Learniat_Student_Iphone
//
//  Created by mindshift_Deepak on 12/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation


@objc protocol QRVSubViewDelegate
{
    
    
//    optional func delegateVonteerPressedWithQueryId(queryId:String)
//    optional func delegateMeeTooPressedWithQueryId(queryId:String)
    
}



class QRVSubView: UIView,SSStudentDataSourceDelegate
{
    var _delgate: AnyObject!
    
    var volunteerView : UIView!
    var volunteerScrollView : UIScrollView!
    
    var VolunteerButton = UIButton()
    
    var meeTooButton    = UIButton()
    
    var currentVolunteerId = ""
    
    var queryTextLabel           = UILabel()
    
    var volunteerDotPosition :CGFloat   = 10
    
    var myQuerylabel = UILabel()

    var numberOfVolunteerResponse = 0
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        queryTextLabel.frame = CGRectMake(50, 5, self.frame.size.width - 60 , 30)
        self.addSubview(queryTextLabel)
        queryTextLabel.numberOfLines = 4
        queryTextLabel.lineBreakMode = .ByTruncatingMiddle
        queryTextLabel.textAlignment = .Left
        queryTextLabel.textColor = textColor
        queryTextLabel.font =  UIFont (name: helveticaRegular, size: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    func addAllSUbQuerySubViewWithDetails(AllowVolunteer:String, withQueryId queryId:String, withQueryText queryText:String, withQuerySize height:CGFloat, withCount count:String)
    {
        
        self.tag = Int(queryId)!
        var positionXofButtons :CGFloat = 50
        
        
        myQuerylabel.frame = CGRectMake(positionXofButtons,5,200, 30)
        myQuerylabel.text = "My query"
        myQuerylabel.font =  UIFont (name: HelveticaNeueThin, size: 16)
        self.addSubview(myQuerylabel)
        myQuerylabel.hidden = true
        myQuerylabel.textColor = lightGrayColor
        
        
        
       let countLabel = UILabel(frame: CGRectMake(10, 5, 30 , 30))
        self.addSubview(countLabel)
        countLabel.textAlignment = .Center
        countLabel.textColor = UIColor.whiteColor()
        countLabel.font =  UIFont (name: helveticaRegular, size: 14)
        countLabel.text = count
        countLabel.backgroundColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1)
        countLabel.layer.cornerRadius = countLabel.frame.size.width/2
        countLabel.layer.masksToBounds = true
        
        
        if AllowVolunteer == "1"
        {
            VolunteerButton.frame = CGRectMake(positionXofButtons,5,120, 30)
            VolunteerButton.setTitle("I VOLUNTEER", forState: .Normal)
            VolunteerButton.contentHorizontalAlignment = .Left
            self.addSubview(VolunteerButton)
            VolunteerButton.setTitleColor(standard_Button, forState: .Normal)
            VolunteerButton.addTarget(self, action: #selector(QRVSubView.onVolunteerButton), forControlEvents: UIControlEvents.TouchUpInside)
            VolunteerButton.titleLabel?.font = UIFont (name: helveticaRegular, size: 16)
            positionXofButtons = positionXofButtons + VolunteerButton.frame.size.width + 20

        }
        
        
        
        meeTooButton.frame = CGRectMake(positionXofButtons,5,70, 30)
        meeTooButton.setTitle("ME TOO", forState: .Normal)
        meeTooButton.contentHorizontalAlignment = .Left
        self.addSubview(meeTooButton)
        meeTooButton.setTitleColor(standard_Button, forState: .Normal)
        meeTooButton.titleLabel?.font = UIFont (name: helveticaRegular, size: 16)
        meeTooButton.addTarget(self, action: #selector(QRVSubView.onMeeTooButton), forControlEvents: UIControlEvents.TouchUpInside)
        

        let lineView = UIImageView(frame: CGRectMake(50, meeTooButton.frame.origin.y + meeTooButton.frame.size.height + 5, (self.frame.size.width-50), 1))
        lineView.backgroundColor = topicsLineColor
        self.addSubview(lineView)
        
        
        
        
        
        
        
        
        queryTextLabel.frame = CGRectMake(50, lineView.frame.origin.y + lineView.frame.size.height + 5, self.frame.size.width - 60 , height)
        queryTextLabel.text = queryText
    }
    
    func getQueryTextSizeWithText(query:String) -> CGFloat
    {
        queryTextLabel.text = query
        var height :CGFloat = 50
        
        height = heightForView(query, font: queryTextLabel.font, width: queryTextLabel.frame.size.width)
        height = height + 65
        
        return height
        
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    func onVolunteerButton()
    {
        UIView.animateWithDuration(0.5, animations:
            {
                self.meeTooButton.hidden = true
                self.VolunteerButton.setTitleColor(lightGrayColor, forState: .Normal)
                self.VolunteerButton.enabled = false
        })
      
        
        SSStudentDataSource.sharedDataSource.volunteerRegisterwithQueryId((String(self.tag)), withDelegate: self)
        
//        delegate().delegateVonteerPressedWithQueryId!(String(self.tag))
    }
    
    func onMeeTooButton()
    {
        
        UIView.animateWithDuration(0.5, animations:
            {
                self.VolunteerButton.hidden = true
                self.meeTooButton.setTitleColor(lightGrayColor, forState: .Normal)
                self.meeTooButton.enabled = false
                self.meeTooButton.frame = CGRectMake(50,5,70, 30)
        })
        SSStudentMessageHandler.sharedMessageHandler.sendMeTooMessageToTeacherWithQueryId(String(self.tag))
        
       
        
//        delegate().delegateMeeTooPressedWithQueryId!(String(self.tag))
        
    }
    
    func didGetvolunteerRegisteredWithDetails(details: AnyObject)
    {
        if let volunteeerId = details.objectForKey("VolunteerId") as? String
        {
            currentVolunteerId = volunteeerId
            
            SSStudentMessageHandler.sharedMessageHandler.sendIVolunteerMessageToTeacher(String(self.tag), withvolunteerId: currentVolunteerId)
        }
     
    }
    
    func addVolunteerDetailsDotWithStudentid(studentId:String, WithDecreasingValue value:CGFloat)
    {
        
        
        
        if volunteerView == nil
        {
            volunteerView = UIView(frame: CGRectMake(queryTextLabel.frame.origin.x, queryTextLabel.frame.origin.y +  queryTextLabel.frame.size.height + 5, queryTextLabel.frame.size.width ,55))
            self.addSubview(volunteerView);
            volunteerView.backgroundColor = UIColor.clearColor()
            
            
            let lineView = UIImageView(frame: CGRectMake(0,1, volunteerView.frame.size.width, 1))
            lineView.backgroundColor = topicsLineColor
            volunteerView.addSubview(lineView)
            
            
            let volunteerLable = UILabel(frame: CGRectMake(0,5, volunteerView.frame.size.width, 20))
            volunteerLable.textColor = UIColor.lightGrayColor()
            volunteerView.addSubview(volunteerLable)
            volunteerLable.font = UIFont (name:helveticaMedium, size: 16)
            volunteerLable.text = "Volunteer responses:"
            
            
            
            volunteerScrollView = UIScrollView(frame: CGRectMake(0,30, volunteerView.frame.size.width,25))
            volunteerView.addSubview(volunteerScrollView)
            

        }
        
        
        
        
        var dotColor =  UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
        
        if (value<=33)
        {
             dotColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
            
            
           
        }
        else if (value>33 && value<=66)
        {
            
           dotColor =  UIColor(red: 255/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
            
            
        }
        else
        {
            dotColor =  UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
           
        }
        
        
        
        
        let dotImage = QRVVolunteerView(frame: CGRectMake(volunteerDotPosition, 0, 25,25))
        numberOfVolunteerResponse = numberOfVolunteerResponse + 1
        dotImage.setStudentImageWithId(studentId, withColor: dotColor)
        volunteerScrollView.addSubview(dotImage);
        
        volunteerDotPosition = volunteerDotPosition + dotImage.frame.size.width + 5
        
        volunteerScrollView.contentSize = CGSizeMake(volunteerDotPosition, 0)
        
    }
    

}