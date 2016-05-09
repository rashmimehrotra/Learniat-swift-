//
//  INILoader.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit


let onlyMainTopics        = "Only MainTopics"
let onlySubTopics         = "Only SubTopics"
let onlyQuestions         = "Only Questions"

let kOverlayScribble      = "Overlay Scribble"
let kFreshScribble        = "Fresh Scribble"
let kText                 = "Text"
let kMCQ                  = "Multiple Choice"
let kMRQ                  = "Multiple Response"
let kMatchColumn          = "Match Columns"



let KCorretValue            = "4"
let kWrongvalue             = "5"
let kMissedValue            = "6"

let helveticaRegular      = "HelveticaNeue"

let helveticaMedium       = "HelveticaNeue-Medium"

let helveticaBold         = "HelveticaNeue-Bold"

let HelveticaNeueThin     = "HelveticaNeue-Thin"


let kClassName      = "ClassName"

let kEndTime        = "EndTime"

let kSessionState   = "SessionState"

let kStartTime      = "StartTime"

let kRoomId         = "RoomId"

let kRoomName       = "RoomName"


let kSessionId      = "SessionId"

let kScheduledString      =  "Scheduled"

let kopenedString         =  "Opened"

let kLiveString           =  "Live"

let kCanClledString       =  "Cancelled"

let kEndedString          =  "Ended"


let kScheduled      =  "4"

let kopened         =  "2"

let kLive           =  "1"

let kCanClled       =  "6"

let kEnded          =  "5"




let kServerID                     = "http://54.251.104.13"

let kUplodingServer               = "http://54.251.104.13/Jupiter/upload_photos.php"

let kINIPath                      = "http://54.251.104.13/learniat/learniat.ini"

let k_INI_BaseXMPPURL             =  "XMPP_server_IP"

let k_INI_UserProfileImageURL     =  "user_profile_images"

let k_INI_SCRIBBLE_IMAGE_URL      =  "mobile_app_scribbles"

let k_INI_QuestionsImageUrl       =  "question_images"

let k_INI_Badges                  =  "badges"

let k_INI_OverLayImageWidth       =  "min_overlay_question_image_width"

let k_INI_DemoPathUrl             =  "demo_path"

let kProFIlePics                  =  "/ProFilePics"

let kStudentAnswerImages          =  "/StudentAnswer"

let kQuestionImage                =  "/questionImage"

let kBadgesImage                  =  "/badges"



let whiteBackgroundColor: UIColor = UIColor(red: 246/255.0, green:246/255.0, blue:246/255.0, alpha: 1)

let darkBackgroundColor: UIColor = UIColor(red: 36/255.0, green:68/255.0, blue:99/255.0, alpha: 1) // 244463

let lightBackgroundColor: UIColor = UIColor(red: 31/255.0, green:61/255.0, blue:89/255.0, alpha: 1) // 1F3D59

let topbarColor         : UIColor = UIColor(red: 46/255.0, green:88/255.0, blue:128/255.0, alpha: 1)

let standard_Green      : UIColor = UIColor(red: 76/255.0, green:217/255.0, blue:100/255.0, alpha: 1)

let standard_Red        : UIColor = UIColor(red: 255/255.0, green:59/255.0, blue:48/255.0, alpha: 1)

let standard_Yellow     : UIColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1)  

let standard_TextGrey   : UIColor = UIColor(red: 170/255.0, green:170/255.0, blue:170/255.0, alpha: 1) //AAAAAA

let standard_Button     : UIColor = UIColor(red: 0/255.0, green:174/255.0, blue:239/255.0, alpha: 1)

let standard_Button_Disabled     : UIColor = UIColor.lightGrayColor()

let lightGrayColor      : UIColor = UIColor.lightGrayColor()

let lightGrayTopBar     : UIColor = UIColor(red: 238/255.0, green:238/255.0, blue:238/255.0, alpha: 1) //EEEEEE

let LineGrayColor       : UIColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 0.8) //999999

let blackTextColor      : UIColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)   //333333

let topicsLineColor     : UIColor = UIColor(red: 236.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)

let progressviewBackground    : UIColor = UIColor(red:213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1)





let scheduledColor : UIColor = UIColor(red: 58.0/255.0, green:114.0/255.0, blue:168.0/255.0, alpha: 1)

let scheduledBorderColor : UIColor = UIColor(red: 58.0/255.0, green:114.0/255.0, blue:168.0/255.0, alpha: 1)

let OpenedColor : UIColor = UIColor(red: 0.0/255.0, green:174.0/255.0, blue:239/255.0, alpha: 1)

let OpenedBorderColor : UIColor = UIColor(red: 0.0/255.0, green:174.0/255.0, blue:239/255.0, alpha: 1)



let CancelledBorderColor : UIColor = UIColor(red: 255/255.0, green:59/255.0, blue:48/255.0, alpha: 1)



let LiveColor : UIColor = UIColor(red: 8.0/255.0, green:198.0/255.0, blue:246.0/255.0, alpha: 1)

let EndedColor : UIColor = UIColor(red:152.0/255.0, green:180.0/255.0, blue:207.0/255.0, alpha: 1)



enum folderType
{
    case ProFilePics
    case StudentAnswer
    case questionImage
    case badgesImages
}


class INILoader: NSObject
{
    internal  static let sharediniLoader = INILoader()
    
    func loadNewFileFromServer()
    {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        
        
        
        
        if let url = NSURL(string: kINIPath)
        {
            do {
                let contents = try NSString(contentsOfURL: url, usedEncoding: nil)
                
                
                let datavalue = contents.componentsSeparatedByString("\n")
                
                
                for index in 0 ..< datavalue.count
                {
                    let string = datavalue[index]
                    let fullValueDetails = string.componentsSeparatedByString(" ")
                    defaults.setObject(fullValueDetails.last!, forKey: fullValueDetails.first!)
                    
                }
                createFolderStracture()
            }
            catch
            {
                // contents could not be loaded
            }
        }
        else
        {
            // the URL was bad!
        }
    }
    
    
    func createFolderStracture()
    {
        
        var pngPath = NSTemporaryDirectory().stringByAppendingString(kQuestionImage)
        
        
        // Check if the directory already exists
        var isDir :ObjCBool = false
        var exists :Bool = NSFileManager.defaultManager().fileExistsAtPath(pngPath, isDirectory: &isDir)
        
        if (!exists)
        {
            // Directory does not exist so create it
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(pngPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
            
        }
        
        
        
        pngPath = NSTemporaryDirectory().stringByAppendingString(kStudentAnswerImages)
        
        exists = NSFileManager.defaultManager().fileExistsAtPath(pngPath, isDirectory: &isDir)
        // Check if the directory already exists
        
        if (!exists)
        {
            // Directory does not exist so create it
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(pngPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
        }
        
        
        
        pngPath = NSTemporaryDirectory().stringByAppendingString(kProFIlePics)
        
        exists = NSFileManager.defaultManager().fileExistsAtPath(pngPath, isDirectory: &isDir)
        // Check if the directory already exists
        
        if (!exists)
        {
            // Directory does not exist so create it
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(pngPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
        }
        
        
        
        
        pngPath = NSTemporaryDirectory().stringByAppendingString(kBadgesImage)
        
        exists = NSFileManager.defaultManager().fileExistsAtPath(pngPath, isDirectory: &isDir)
        // Check if the directory already exists
        
        if (!exists)
        {
            // Directory does not exist so create it
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(pngPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
        }
        
        
        for i in 1 ..< 11
        {
            
            
            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_Badges) as! String
            
            let str = String("\(urlString)/\(i).png")
            
            
            
            
            
            
            
            if let checkedUrl = NSURL(string: str)
            {
                
                let data = NSData(contentsOfURL: checkedUrl) //make sure your image in this url does exist, otherwise unwrap in a if let
                
                if let imageData = data as NSData? {
                    
                    let imagePathString = String("/badges/\(i).png");
                    let imagePath =  NSTemporaryDirectory().stringByAppendingString(imagePathString)
                    imageData.writeToFile(imagePath, atomically: true)
                }
            }
        }
    }
    
}



// MARK: - ImageView Extension

extension UIImageView
{
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, withFolderType type:folderType)
    {
        
        
        
        
        var pngPath = NSTemporaryDirectory().stringByAppendingString(kQuestionImage)
        switch type
        {
        case .ProFilePics:
            pngPath = NSTemporaryDirectory().stringByAppendingString(kProFIlePics)
            break
            
        case .StudentAnswer:
            pngPath = NSTemporaryDirectory().stringByAppendingString(kStudentAnswerImages)
            break
            
        case .questionImage:
            pngPath = NSTemporaryDirectory().stringByAppendingString(kQuestionImage)
            break
        case .badgesImages:
            pngPath = NSTemporaryDirectory().stringByAppendingString(kBadgesImage)
            break
        }
        
        pngPath = pngPath.stringByAppendingString("/\(url.lastPathComponent ?? "")")
        var isDir :ObjCBool = false
        let exists :Bool = NSFileManager.defaultManager().fileExistsAtPath(pngPath, isDirectory: &isDir)
        if !exists
        {
            
            getDataFromUrl(url) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue())
                    { () -> Void in
                        guard let data = data where error == nil else { return }
                        
                        
                        self.image = UIImage(data: data)
                        self.layer.masksToBounds = true
                        data.writeToFile(pngPath, atomically: true)
                }
            }
        }
        else
        {
            self.image = UIImage(contentsOfFile: pngPath)
            self.layer.masksToBounds = true
        }
        
        
        
        
    }
    
    
    func downloadImage(url: NSURL, withFolderType type:folderType, withResizeValue newSize:CGSize)
    {
        
        
        
        
        var pngPath = NSTemporaryDirectory().stringByAppendingString(kQuestionImage)
        switch type
        {
        case .ProFilePics:
            pngPath = NSTemporaryDirectory().stringByAppendingString(kProFIlePics)
            break
            
        case .StudentAnswer:
            pngPath = NSTemporaryDirectory().stringByAppendingString(kStudentAnswerImages)
            break
            
        case .questionImage:
            pngPath = NSTemporaryDirectory().stringByAppendingString(kQuestionImage)
            break
        case .badgesImages:
            pngPath = NSTemporaryDirectory().stringByAppendingString(kBadgesImage)
            break
        }
        pngPath = pngPath.stringByAppendingString("/\(url.lastPathComponent ?? "")")
        var isDir :ObjCBool = false
        let exists :Bool = NSFileManager.defaultManager().fileExistsAtPath(pngPath, isDirectory: &isDir)
        if !exists
        {
            
            getDataFromUrl(url) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue())
                    { () -> Void in
                        guard let data = data where error == nil else { return }
                        
                        
                       
                        data.writeToFile(pngPath, atomically: true)
                        
                        
                        if let image = UIImage(data: data)
                        {
                            self.image = self.resizeImage(image, newSize: newSize)
                        }
                        
                        self.layer.masksToBounds = true
                        
                }
            }
        }
        else
        {
            
            self.image = self.resizeImage(UIImage(contentsOfFile: pngPath)!, newSize: newSize)
            self.layer.masksToBounds = true
        }
        
        
        
        
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
}

// MARK: - UILabel Extension

class UIVerticalAlignLabel: UILabel {
    
    enum VerticalAlignment : Int {
        case VerticalAlignmentTop = 0
        case VerticalAlignmentMiddle = 1
        case VerticalAlignmentBottom = 2
    }
    
    enum horizontalAlignment : Int {
        case Left = 0
        case Middle = 1
        case Right = 2
    }

    
    var verticalAlignment : VerticalAlignment = .VerticalAlignmentTop {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    var _horizontalAlignment : horizontalAlignment = .Middle
        {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        
        let rect = super.textRectForBounds(bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        switch(verticalAlignment)
        {
        case .VerticalAlignmentTop:
            
            
            return CGRectMake(bounds.origin.x, bounds.origin.y, rect.size.width, rect.size.height)
            
        
        case .VerticalAlignmentMiddle:
            
            return CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height) / 2, rect.size.width, rect.size.height)
       
        case .VerticalAlignmentBottom:
            return CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height), rect.size.width, rect.size.height)
      
        }
    }
    
    override func drawTextInRect(rect: CGRect) {
        let r = self.textRectForBounds(rect, limitedToNumberOfLines: self.numberOfLines)
        
        
        super.drawTextInRect(r)
    }
    
    
}

// MARK: - View Extension
extension UIView {
    
    func addDashedBorder() {
        let _border = CAShapeLayer();
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:3).CGPath;
        _border.frame = self.bounds;
        _border.strokeColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1).CGColor;
        _border.fillColor = nil;
        _border.lineDashPattern = [5, 10];
        self.layer.addSublayer(_border)
    }
    
    
    
    
    func addToCurrentTimewithHours(position: CGFloat)
    {
        UIView.animateWithDuration(0.5, animations:
            {
            self.frame = CGRectMake(self.frame.origin.x, position - 2.5, self.frame.size.width, self.frame.size.height)
        })

        
        
    }
    
    func addShadowToView()
    {
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowRadius = 10
    }
}

// MARK: - date Extension
extension NSDate
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
    func totalMinutes () -> Int{
        
        return (hour()*60)
    }
    
    
    func dateDiff()
    {
        let currentDate = NSDate()
        
        //Test Extensions in Log
        NSLog("(Current Hour = \(currentDate.hour())) (Current Minute = \(currentDate.minute())) (Current Short Time String = \(currentDate.toShortTimeString()))")
    }
    
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.day
    }
    
    
    func minutesAndSecondsDiffernceBetweenDates(startDate: NSDate, endDate: NSDate) -> (minutes:Int, second:Int)
    {
        let calendar = NSCalendar.currentCalendar()
        
        let minutesComponents = calendar.components([.Minute], fromDate: startDate, toDate: endDate, options: [])
        
        let secondComponents = calendar.components([.Second], fromDate: startDate, toDate: endDate, options: [])
        
        return (minutesComponents.minute ,secondComponents.second)
    }
    
    
    func minutesDiffernceBetweenDates(startDate: NSDate, endDate: NSDate) -> (Int)
    {
        let calendar = NSCalendar.currentCalendar()
        
        let minutesComponents = calendar.components([.Minute], fromDate: startDate, toDate: endDate, options: [])
        
        
        return (minutesComponents.minute )
    }
    
    
    
    
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    
    func addSeconds(seconds: Int , withDate _toDate:NSDate) -> NSDate!
    {
        let comps = NSDateComponents()
        
        comps.second = seconds
        
        let cal = NSCalendar.currentCalendar()
        
        let r = cal.dateByAddingComponents(comps, toDate: _toDate, options: [])

        return r
    }
    
}
extension String
{
    
    
    
    
    func hourValue() -> Int
    {
        let mainString :NSArray = self.componentsSeparatedByString(" ")
        
        let timeString = mainString.lastObject!
        
        
        let hourValue :String = (timeString.componentsSeparatedByString(":") as NSArray).firstObject! as! String
        
        return Int(hourValue)!
        
    }
    
    func minuteValue()->Int
    {
        let mainString :NSArray = self.componentsSeparatedByString(" ")
        
        let timeString = mainString.lastObject!
        
        
        let hourValue :String = (timeString.componentsSeparatedByString(":") as NSArray).objectAtIndex(1) as! String
        
        return Int(hourValue)!
    }
    
    func secondValue()->Int
    {
        let mainString :NSArray = self.componentsSeparatedByString(" ")
        
        let timeString = mainString.lastObject!
        
        
        let hourValue :String = (timeString.componentsSeparatedByString(":") as NSArray).lastObject! as! String
        
        return Int(hourValue)!
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> (hour: Int, minutes: Int, seconds: Int , fullString: String) {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        
        return ( hours, minutes, seconds,String(format: "%02d:%02d:%02d", hours, minutes, seconds))
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
    
    
    
}
