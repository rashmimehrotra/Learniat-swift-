//
//  INILoader.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit




/* 
 
 Feature 
 Functionality
 Linkages
 
 
 
 */

let onlyMainTopics        = "Only MainTopics"
let onlySubTopics         = "Only SubTopics"
let onlyQuestions         = "Only Questions"

let kOverlayScribble      = "Overlay Scribble"
let kFreshScribble        = "Fresh Scribble"
let kText                 = "Text"
let kMCQ                  = "Multiple Choice"
let kMRQ                  = "Multiple Response"
let kMatchColumn          = "Match Columns"
let OneString             = "One_String"
let TextAuto              = "Text_Auto"


/* These values are hardcoded for collaboration and not used in current project */
let KCorretValue            = "4"

let kWrongvalue             = "5"

let kMissedValue            = "6"

/*-----*/



let helveticaRegular      = "HelveticaNeue"

let helveticaMedium       = "HelveticaNeue-Medium"

let helveticaBold         = "HelveticaNeue-Bold"

let HelveticaNeueThin     = "HelveticaNeue-Thin"


let RobotRegular           =  "Roboto-Regular"

let RobotItalic             = "Roboto-Italic"


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

let kDemoPlistUrl                 =  "http://54.251.104.13/Demo"




let whiteBackgroundColor: UIColor = UIColor(red: 248/255.0, green:248/255.0, blue:248/255.0, alpha: 1)

let topbarColor         : UIColor = UIColor(red: 46/255.0, green:88/255.0, blue:128/255.0, alpha: 1)

let standard_Green      : UIColor = UIColor(red: 76/255.0, green:217/255.0, blue:100/255.0, alpha: 1)

let standard_Red        : UIColor = UIColor(red: 255/255.0, green:59/255.0, blue:48/255.0, alpha: 1)

let standard_Yellow     : UIColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1)  

let standard_TextGrey   : UIColor = UIColor(red: 170/255.0, green:170/255.0, blue:170/255.0, alpha: 1) //AAAAAA

let standard_Button     : UIColor = UIColor(red: 0/255.0, green:174/255.0, blue:239/255.0, alpha: 1)

let standard_Button_Disabled     : UIColor = UIColor.lightGrayColor()

let lightGrayColor      : UIColor = UIColor.lightGrayColor()

let lightGrayTopBar     : UIColor = UIColor(red: 238/255.0, green:238/255.0, blue:238/255.0, alpha: 1) //EEEEEE

let LineGrayColor       : UIColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 0.3) //999999

let blackTextColor      : UIColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)   //333333

let topicsLineColor     : UIColor = UIColor(red: 236.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)

let progressviewBackground    : UIColor = UIColor(red:213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1)

let pollCellBackgroundColor     = UIColor(red: 235/255.0, green:235/255.0, blue:235/255.0, alpha: 1)




let scheduledColor : UIColor = UIColor(red: 246/255.0, green:246/255.0, blue:246/255.0, alpha: 1)

let scheduledBorderColor : UIColor = UIColor(red: 153/255.0, green:153/255.0, blue:153/255.0, alpha: 1)

let OpenedColor : UIColor = UIColor(red: 229.0/255.0, green:243.0/255.0, blue:231.0/255.0, alpha: 1)

let OpenedBorderColor : UIColor = UIColor(red: 76/255.0, green:217/255.0, blue:100/255.0, alpha: 1)

let CancelledBorderColor : UIColor = UIColor(red: 255/255.0, green:59/255.0, blue:48/255.0, alpha: 1)

let LiveColor : UIColor = UIColor(red: 0/255.0, green:204/255.0, blue:0/255.0, alpha: 1)

let EndedColor : UIColor = UIColor(red:238.0/255.0, green:238.0/255.0, blue:238.0/255.0, alpha: 1)


let whiteColor          = UIColor.whiteColor()

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



 // MARK: - FUNC001	Download Image from Url In Async Mode

extension CustomProgressImageView
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
            setImageWithUrl(url, withSavingPath: pngPath, withPlaceHolderName: "", withBorderRequired: false, withColor: UIColor.clearColor())
        }
        else
        {
            self.image = UIImage(contentsOfFile: pngPath)
            self.layer.masksToBounds = true
        }
        
//        setImageWithUrl(url, withSavingPath: pngPath, withPlaceHolderName: "", withBorderRequired: false, withColor: UIColor.clearColor())
        
        
        
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
            setImageWithUrl(url, withSavingPath: pngPath, withPlaceHolderName: "", withBorderRequired: false, withColor: UIColor.clearColor())
        }
        else
        {
            if newSize.height < 100
            {
                self.image = self.resizeImage( UIImage(contentsOfFile: pngPath)!, newSize: newSize)
            }
            else
            {
                self.image = UIImage(contentsOfFile: pngPath)
            }
            
            self.layer.masksToBounds = true
        }
        
       
        
    }
    
    
    // MARK: - FUNC002	Resize Image
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
}

// MARK: - FUNC003	Lable text Vertical allignment

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
    
    
    // MARK: - FUNC004	Dashed Borders
    
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
    
    // MARK: - FUNC005	Add Shadow to view
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
    
    // MARK: - FUNC006	Get days between two dates
    
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.day
    }
    
    
    // MARK: - FUNC007	Minutes and seconds difference betweeen two dates
    func minutesAndSecondsDiffernceBetweenDates(startDate: NSDate, endDate: NSDate) -> (minutes:Int, second:Int)
    {
        let calendar = NSCalendar.currentCalendar()
        
        let minutesComponents = calendar.components([.Minute], fromDate: startDate, toDate: endDate, options: [])
        
        let secondComponents = calendar.components([.Second], fromDate: startDate, toDate: endDate, options: [])
        
        return (minutesComponents.minute ,secondComponents.second)
    }
    
    // MARK: - FUNC008	Minutes difference betweeen two dates
    func minutesDiffernceBetweenDates(startDate: NSDate, endDate: NSDate) -> (Int)
    {
        let calendar = NSCalendar.currentCalendar()
        
        let minutesComponents = calendar.components([.Minute], fromDate: startDate, toDate: endDate, options: [])
        
        
        return (minutesComponents.minute )
    }
    
    
    
    
    // MARK: - FUNC009	Greater than given date
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
    
    // MARK: - FUNC010	Lesser than given date
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
    
    
    // MARK: - FUNC011	Equal to given date
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
    
    // MARK: - FUNC012	Add seconds to date
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
    
    
    
    // MARK - FUNC013	Get hour value from string
    func hourValue() -> Int
    {
        let mainString :NSArray = self.componentsSeparatedByString(" ")
        
        let timeString = mainString.lastObject!
        
        
        let hourValue :String = (timeString.componentsSeparatedByString(":") as NSArray).firstObject! as! String
        
        return Int(hourValue)!
        
    }
    // MARK: - FUNC014	Get minute value from string
    func minuteValue()->Int
    {
        let mainString :NSArray = self.componentsSeparatedByString(" ")
        
        let timeString = mainString.lastObject!
        
        
        let hourValue :String = (timeString.componentsSeparatedByString(":") as NSArray).objectAtIndex(1) as! String
        
        return Int(hourValue)!
    }
    
    // MARK: - FUNC015	Get second value from string
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
    
    // MARK: - FUNC016	Get height of view of given String
    
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
extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

// MARK: - Feature  OneWord

extension String
{
    
    
    // MARK: - FUNC017	Get attributed Text
    func getAttributeText(fullString:String, withSubString searchstring :String) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: fullString as String)
        let str = NSString(string: fullString)
        let theRange = str.rangeOfString(searchstring)
        if theRange.location != NSNotFound
        {
            attributedString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: theRange)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: theRange)
        }
        
        return attributedString
       
    }
    
    
    // MARK: - FUNC018	Is Given string found in Full string
    func isAttributeFound(fullString:String, withSubString searchstring :String) -> Bool
    {
        var isFound = false
        
        let str = NSString(string: fullString)
        let theRange = str.rangeOfString(searchstring)
        if theRange.location != NSNotFound
        {
           isFound = true
        }
        
        return isFound
        
    }
    
    
    
}





// MARK: -


extension UIButton
{
    func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIButton?
    {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIButton
    }
}

// MARK: - IMAGE VIEW FUNCTIONS
extension UIImage
{
   // MARK: - FUNC019	Render View to image
    
    class func imageWithView(view: UIView) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    
    class func renderUIViewToImage(viewToBeRendered:UIView?) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions((viewToBeRendered?.bounds.size)!, false, 0.0)
        viewToBeRendered!.drawViewHierarchyInRect(viewToBeRendered!.bounds, afterScreenUpdates: true)
        viewToBeRendered!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}