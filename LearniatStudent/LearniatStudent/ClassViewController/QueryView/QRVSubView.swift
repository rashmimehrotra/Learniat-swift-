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
    
    var currentSelectionState = ""
    
    
    let underStoodButton = UIButton()
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        queryTextLabel.frame = CGRect(x: 50, y: 5, width: self.frame.size.width - 60 , height: 30)
        self.addSubview(queryTextLabel)
        queryTextLabel.numberOfLines = 4
        queryTextLabel.lineBreakMode = .byTruncatingMiddle
        queryTextLabel.textAlignment = .left
        queryTextLabel.textColor = textColor
        queryTextLabel.font =  UIFont (name: helveticaRegular, size: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    func addAllSUbQuerySubViewWithDetails(_ AllowVolunteer:String, withQueryId queryId:String, withQueryText queryText:String, withQuerySize height:CGFloat, withCount count:String , withMyQuery isMyQuery:Bool)
    {
        
        self.tag = Int(queryId)!
        var positionXofButtons :CGFloat = 50
        
       
        
        
       let countLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 30 , height: 30))
        self.addSubview(countLabel)
        countLabel.textAlignment = .center
        countLabel.textColor = UIColor.white
        countLabel.font =  UIFont (name: helveticaRegular, size: 14)
        countLabel.text = count
        countLabel.backgroundColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1)
        countLabel.layer.cornerRadius = countLabel.frame.size.width/2
        countLabel.layer.masksToBounds = true
        
        
        
        
        queryTextLabel.frame = CGRect(x: 50, y: 5, width: self.frame.size.width - 60 , height: height)
        queryTextLabel.text = queryText
        
        
        
        
        let lineView = UIImageView(frame: CGRect(x: 50, y: queryTextLabel.frame.origin.y + queryTextLabel.frame.size.height + 5, width: (self.frame.size.width-50), height: 1))
        lineView.backgroundColor = topicsLineColor
        self.addSubview(lineView)

        
        
        
        
       
        
        
        
        if AllowVolunteer == "1" && isMyQuery == false
        {
            VolunteerButton.frame = CGRect(x: positionXofButtons,y: lineView.frame.origin.y + lineView.frame.size.height + 5 ,width: 120, height: 30)
            VolunteerButton.setTitle("I VOLUNTEER", for: UIControlState())
            VolunteerButton.contentHorizontalAlignment = .left
            self.addSubview(VolunteerButton)
            VolunteerButton.setTitleColor(standard_Button, for: UIControlState())
            VolunteerButton.addTarget(self, action: #selector(QRVSubView.onVolunteerButton), for: UIControlEvents.touchUpInside)
            VolunteerButton.titleLabel?.font = UIFont (name: helveticaRegular, size: 16)
            positionXofButtons = positionXofButtons + VolunteerButton.frame.size.width + 20

        }
        
        
        
        meeTooButton.frame = CGRect(x: positionXofButtons,y: lineView.frame.origin.y + lineView.frame.size.height + 5 ,width: 70, height: 30)
        meeTooButton.setTitle("ME TOO", for: UIControlState())
        meeTooButton.contentHorizontalAlignment = .left
        self.addSubview(meeTooButton)
        meeTooButton.setTitleColor(standard_Button, for: UIControlState())
        meeTooButton.titleLabel?.font = UIFont (name: helveticaRegular, size: 16)
        meeTooButton.addTarget(self, action: #selector(QRVSubView.onMeeTooButton), for: UIControlEvents.touchUpInside)
        meeTooButton.isHidden = true
        
        
        
        myQuerylabel.frame = CGRect(x: positionXofButtons,y: meeTooButton.frame.origin.y ,width: 200, height: meeTooButton.frame.size.height)
        myQuerylabel.text = "My query"
        myQuerylabel.font =  UIFont (name: HelveticaNeueThin, size: 16)
        self.addSubview(myQuerylabel)
        myQuerylabel.textColor = lightGrayColor
        myQuerylabel.isHidden = true
        
        
        if isMyQuery == false
        {
            

            meeTooButton.isHidden = false
            
        }
        else
        {
            underStoodButton.frame = CGRect(x: meeTooButton.frame.origin.x + meeTooButton.frame.size.width + 20 ,y: meeTooButton.frame.origin.y ,width: meeTooButton.frame.size.width * 2 ,height: meeTooButton.frame.size.height)
            underStoodButton.setTitle("UNDERSTOOD", for: UIControlState())
            underStoodButton.contentHorizontalAlignment = .left
            self.addSubview(underStoodButton)
            underStoodButton.setTitleColor(standard_Button, for: UIControlState())
            underStoodButton.titleLabel?.font = UIFont (name: helveticaRegular, size: 16)
            underStoodButton.addTarget(self, action: #selector(QRVSubView.onUnderStoodButton(_:)), for: UIControlEvents.touchUpInside)
            meeTooButton.isHidden = true
            
            myQuerylabel.isHidden = false
        }
       
        
    }
    
    func getQueryTextSizeWithText(_ query:String) -> CGFloat
    {
        queryTextLabel.text = query
        var height :CGFloat = 50
        
        height = heightForView(query, font: queryTextLabel.font, width: queryTextLabel.frame.size.width)
        height = height + 65
        
        return height
        
    }
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    func onVolunteerButton()
    {
        UIView.animate(withDuration: 0.5, animations:
            {
                self.meeTooButton.isHidden = true
                self.VolunteerButton.setTitleColor(lightGrayColor, for: UIControlState())
                self.VolunteerButton.isEnabled = false
        })
      
        
        SSStudentDataSource.sharedDataSource.volunteerRegisterwithQueryId((String(self.tag)), withDelegate: self)
        
    }
    
    func onMeeTooButton()
    {
        
        currentSelectionState = "Me-Too Selected"
        
        
        UIView.animate(withDuration: 0.5, animations:
            {
                self.VolunteerButton.isHidden = true
                self.meeTooButton.setTitleColor(lightGrayColor, for: UIControlState())
                self.meeTooButton.isEnabled = false
                self.meeTooButton.frame = CGRect(x: 50,y: self.meeTooButton.frame.origin.y,width: self.meeTooButton.frame.size.width,height: self.meeTooButton.frame.size.height)
        })
        
        
        
        
        
        underStoodButton.frame = CGRect(x: meeTooButton.frame.origin.x + meeTooButton.frame.size.width + 20 ,y: meeTooButton.frame.origin.y ,width: meeTooButton.frame.size.width * 2 ,height: meeTooButton.frame.size.height)
        underStoodButton.setTitle("UNDERSTOOD", for: UIControlState())
        underStoodButton.contentHorizontalAlignment = .left
        self.addSubview(underStoodButton)
        underStoodButton.setTitleColor(standard_Button, for: UIControlState())
        underStoodButton.titleLabel?.font = UIFont (name: helveticaRegular, size: 16)
        underStoodButton.addTarget(self, action: #selector(QRVSubView.onUnderStoodButton(_:)), for: UIControlEvents.touchUpInside)
        
        SSStudentMessageHandler.sharedMessageHandler.sendMeTooMessageToTeacherWithQueryId(String(self.tag))
        
    }
    
    func onUnderStoodButton(_ sender:UIButton)
    {
        
        
        UIView.animate(withDuration: 0.5, animations:
            {
                self.meeTooButton.isHidden = true
                sender.isEnabled = false
                sender.setTitleColor(lightGrayColor, for: UIControlState())
//                sender.frame = CGRect(x: 50,y: sender.frame.origin.y,width: sender.frame.size.width,height: sender.frame.size.height)
        })
        
        
        SSStudentMessageHandler.sharedMessageHandler.sendQueryUnderstoodMessageWithQueryID(String(self.tag))
    }
    
    func didGetvolunteerRegisteredWithDetails(_ details: AnyObject)
    {
        print(details)
       
        if let Status = details.object(forKey: "Status") as? String
        {
            if Status == kSuccessString
            {
                if let volunteeerId = details.object(forKey: "VolunteerId") as? String
                {
                    currentVolunteerId = volunteeerId
                    
                    SSStudentMessageHandler.sharedMessageHandler.sendIVolunteerMessageToTeacher(String(self.tag), withvolunteerId: currentVolunteerId)
                }
            }
            else
            {
                self.VolunteerButton.isHidden = false
                VolunteerButton.setTitleColor(standard_Button, for: UIControlState())
                VolunteerButton.isEnabled = true
                
                
                self.meeTooButton.isHidden = false
                meeTooButton.setTitleColor(standard_Button, for: UIControlState())
                meeTooButton.isEnabled = true
            }
        }
        
        
     
    }
    
    func addVolunteerDetailsDotWithStudentid(_ studentId:String, WithDecreasingValue value:CGFloat)
    {
        
        
        
        if volunteerView == nil
        {
            volunteerView = UIView(frame: CGRect(x: queryTextLabel.frame.origin.x, y: meeTooButton.frame.origin.y +  meeTooButton.frame.size.height + 5, width: queryTextLabel.frame.size.width ,height: 55))
            self.addSubview(volunteerView);
            volunteerView.backgroundColor = UIColor.clear
            
            
            let lineView = UIImageView(frame: CGRect(x: 0,y: 1, width: volunteerView.frame.size.width, height: 1))
            lineView.backgroundColor = topicsLineColor
            volunteerView.addSubview(lineView)
            
            
            let volunteerLable = UILabel(frame: CGRect(x: 0,y: 5, width: volunteerView.frame.size.width, height: 20))
            volunteerLable.textColor = UIColor.lightGray
            volunteerView.addSubview(volunteerLable)
            volunteerLable.font = UIFont (name:helveticaMedium, size: 16)
            volunteerLable.text = "Volunteer responses:"
            
            
            
            volunteerScrollView = UIScrollView(frame: CGRect(x: 0,y: 30, width: volunteerView.frame.size.width,height: 25))
            volunteerView.addSubview(volunteerScrollView)
            
            
//            if currentSelectionState ==  "Me-Too Selected"
//            {
//                let underStoodButton = UIButton()
//                
//                underStoodButton.frame = CGRectMake(meeTooButton.frame.origin.x + meeTooButton.frame.size.width + 20 ,meeTooButton.frame.origin.y ,meeTooButton.frame.size.width * 2 ,meeTooButton.frame.size.height)
//                underStoodButton.setTitle("UNDERSTOOD", forState: .Normal)
//                underStoodButton.contentHorizontalAlignment = .Left
//                self.addSubview(underStoodButton)
//                underStoodButton.setTitleColor(standard_Button, forState: .Normal)
//                underStoodButton.titleLabel?.font = UIFont (name: helveticaRegular, size: 16)
//                underStoodButton.addTarget(self, action: #selector(QRVSubView.onUnderStoodButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            }
            
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
        
        
        
        
        let dotImage = QRVVolunteerView(frame: CGRect(x: volunteerDotPosition, y: 0, width: 25,height: 25))
        numberOfVolunteerResponse = numberOfVolunteerResponse + 1
        dotImage.setStudentImageWithId(studentId, withColor: dotColor)
        volunteerScrollView.addSubview(dotImage);
        
        volunteerDotPosition = volunteerDotPosition + dotImage.frame.size.width + 5
        
        volunteerScrollView.contentSize = CGSize(width: volunteerDotPosition, height: 0)
        
    }
    

}
