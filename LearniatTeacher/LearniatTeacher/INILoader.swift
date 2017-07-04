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
let OneString             = "Word map"
let TextAuto              = "One string"
let SoreFinger            = "Sore finger"
let Polling               = "Poll"


/* These values are hardcoded for collaboration and not used in current project */
let KCorretValue            = "4"

let kWrongvalue             = "5"

let kMissedValue            = "6"

/*-----*/


let kOptionTagMain              = "OptionContainer"
let kQuestionType               = "Type"//"QuestionType"
let kOptionTag                  = "Option"




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


let kTeacherName = "TeacherName"
let kTeacherId   = "TeacherId"
let kClassId     = "ClassId"
let kSubjectName = "SubjectName"
let kSubjectId   = "SubjectId"
let kSeatsConfigured = "SeatsConfigured"
let kStudentsRegistered = "StudentsRegistered"
let kPreallocatedSeats  = "PreallocatedSeats"
let kExisting_state     = "existing_state"




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

let standard_Button_Disabled     : UIColor = UIColor.lightGray

let lightGrayColor      : UIColor = UIColor.lightGray

let lightGrayTopBar     : UIColor = UIColor(red: 238/255.0, green:238/255.0, blue:238/255.0, alpha: 1) //EEEEEE

let LineGrayColor       : UIColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1) //999999

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


let whiteColor          = UIColor.white

enum folderType
{
    case proFilePics
    case studentAnswer
    case questionImage
    case badgesImages
}


class INILoader: NSObject
{
    internal  static let sharediniLoader = INILoader()
    
    func loadNewFileFromServer()
    {
        
        let defaults = UserDefaults.standard
        
        
        
        
        
        
        if let url = URL(string: kINIPath)
        {
            do {
                let contents = try NSString(contentsOf: url, usedEncoding: nil)
                
                
                let datavalue = contents.components(separatedBy: "\n")
                
                
                for index in 0 ..< datavalue.count
                {
                    let string = datavalue[index]
                    let fullValueDetails = string.components(separatedBy: " ")
                    defaults.set(fullValueDetails.last!, forKey: fullValueDetails.first!)
                    
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
        
        var pngPath = NSTemporaryDirectory() + kQuestionImage
        
        
        // Check if the directory already exists
        var isDir :ObjCBool = false
        var exists :Bool = FileManager.default.fileExists(atPath: pngPath, isDirectory: &isDir)
        
        if (!exists)
        {
            // Directory does not exist so create it
            
            do {
                try FileManager.default.createDirectory(atPath: pngPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
            
        }
        
        
        
        pngPath = NSTemporaryDirectory() + kStudentAnswerImages
        
        exists = FileManager.default.fileExists(atPath: pngPath, isDirectory: &isDir)
        // Check if the directory already exists
        
        if (!exists)
        {
            // Directory does not exist so create it
            
            do {
                try FileManager.default.createDirectory(atPath: pngPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
        }
        
        
        
        pngPath = NSTemporaryDirectory() + kProFIlePics
        
        exists = FileManager.default.fileExists(atPath: pngPath, isDirectory: &isDir)
        // Check if the directory already exists
        
        if (!exists)
        {
            // Directory does not exist so create it
            
            do {
                try FileManager.default.createDirectory(atPath: pngPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
        }
        
        
        
        
        pngPath = NSTemporaryDirectory() + kBadgesImage
        
        exists = FileManager.default.fileExists(atPath: pngPath, isDirectory: &isDir)
        // Check if the directory already exists
        
        if (!exists)
        {
            // Directory does not exist so create it
            
            do {
                try FileManager.default.createDirectory(atPath: pngPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
        }
        
        
        for i in 1 ..< 11
        {
            
            
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_Badges) as! String
            
            let str = String("\(urlString)/\(i).png")
            
            
            
            
            
            
            
            if let checkedUrl = URL(string: str!)
            {
                
                let data = try? Data(contentsOf: checkedUrl) //make sure your image in this url does exist, otherwise unwrap in a if let
                
                if let imageData = data as Data? {
                    
                    let imagePathString = String("/badges/\(i).png");
                    let imagePath =  NSTemporaryDirectory() + imagePathString!
                    try? imageData.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
                }
            }
        }
    }
    
}



 // MARK: - FUNC001	Download Image from Url In Async Mode

extension CustomProgressImageView
{
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            completion(data,response,error)
//        }.resume()
        
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            completion(data, response, error)
//            }) .resume()
    }
    
    
   
    
    
    func downloadImage(_ url: URL, withFolderType type:folderType)
    {
        
        
        
        
        var pngPath = NSTemporaryDirectory() + kQuestionImage
        switch type
        {
        case .proFilePics:
            pngPath = NSTemporaryDirectory() + kProFIlePics
            break
            
        case .studentAnswer:
            pngPath = NSTemporaryDirectory() + kStudentAnswerImages
            break
            
        case .questionImage:
            pngPath = NSTemporaryDirectory() + kQuestionImage
            break
        case .badgesImages:
            pngPath = NSTemporaryDirectory() + kBadgesImage
            break
        }
        
        pngPath = pngPath + "/\(url.lastPathComponent )"
       
        var isDir :ObjCBool = false
        let exists :Bool = FileManager.default.fileExists(atPath: pngPath, isDirectory: &isDir)
        if !exists
        {
            setImageWith(url, withSavingPath: pngPath, withPlaceHolderName: "", withBorderRequired: false, with: UIColor.clear)
        }
        else
        {
            self.image = UIImage(contentsOfFile: pngPath)
            self.layer.masksToBounds = true
        }
        
//        setImageWithUrl(url, withSavingPath: pngPath, withPlaceHolderName: "", withBorderRequired: false, withColor: UIColor.clearColor())
        
        
        
    }
    
    
    func downloadImage(_ url: URL, withFolderType type:folderType, withResizeValue newSize:CGSize)
    {
        
        
        
        
        var pngPath = NSTemporaryDirectory() + kQuestionImage
        switch type
        {
        case .proFilePics:
            pngPath = NSTemporaryDirectory() + kProFIlePics
            break
            
        case .studentAnswer:
            pngPath = NSTemporaryDirectory() + kStudentAnswerImages
            break
            
        case .questionImage:
            pngPath = NSTemporaryDirectory() + kQuestionImage
            break
        case .badgesImages:
            pngPath = NSTemporaryDirectory() + kBadgesImage
            break
        }
        pngPath = pngPath + "/\(url.lastPathComponent )"
        
        
        var isDir :ObjCBool = false
        let exists :Bool = FileManager.default.fileExists(atPath: pngPath, isDirectory: &isDir)
        if !exists
        {
            setImageWith(url, withSavingPath: pngPath, withPlaceHolderName: "", withBorderRequired: false, with: UIColor.clear)
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
    
    func resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    
}

// MARK: - FUNC003	Lable text Vertical allignment

class UIVerticalAlignLabel: UILabel {
    
    enum VerticalAlignment : Int {
        case verticalAlignmentTop = 0
        case verticalAlignmentMiddle = 1
        case verticalAlignmentBottom = 2
    }
    
    enum horizontalAlignment : Int {
        case left = 0
        case middle = 1
        case right = 2
    }

    
    var verticalAlignment : VerticalAlignment = .verticalAlignmentTop {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    var _horizontalAlignment : horizontalAlignment = .middle
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
    
    
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        switch(verticalAlignment)
        {
        case .verticalAlignmentTop:
            
            
            return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            
        
        case .verticalAlignmentMiddle:
            
            return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
       
        case .verticalAlignmentBottom:
            return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
      
        }
    }
    
    override func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        
        
        super.drawText(in: r)
    }
    
    
}

// MARK: - View Extension
extension UIView {
    
    
    // MARK: - FUNC004	Dashed Borders
    
    func addDashedBorder() {
        let _border = CAShapeLayer();
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:3).cgPath;
        _border.frame = self.bounds;
        _border.strokeColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1).cgColor;
        _border.fillColor = nil;
        _border.lineDashPattern = [5, 10];
        self.layer.addSublayer(_border)
    }
    
    
    
    
    func addToCurrentTimewithHours(_ position: CGFloat)
    {
        UIView.animate(withDuration: 0.5, animations:
            {
            self.frame = CGRect(x: self.frame.origin.x, y: position - 2.5, width: self.frame.size.width, height: self.frame.size.height)
        })

        
        
    }
    
    // MARK: - FUNC005	Add Shadow to view
    func addShadowToView()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
    }
}

// MARK: - date Extension
extension Date
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.hour, from: self)
        let hour = components.hour
        
        //Return Hour
        return hour!
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.minute, from: self)
        let minute = components.minute
        
        //Return Minute
        return minute!
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
    func totalMinutes () -> Int{
        
        return (hour()*60)
    }
    
    
    func dateDiff()
    {
        let currentDate = Date()
        
        //Test Extensions in Log
        NSLog("(Current Hour = \(currentDate.hour())) (Current Minute = \(currentDate.minute())) (Current Short Time String = \(currentDate.toShortTimeString()))")
    }
    
    // MARK: - FUNC006	Get days between two dates
    
    func daysBetweenDate(_ startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])
        
        return components.day!
    }
    
    
    // MARK: - FUNC007	Minutes and seconds difference betweeen two dates
    func minutesAndSecondsDiffernceBetweenDates(_ startDate: Date, endDate: Date) -> (minutes:Int, second:Int)
    {
        let calendar = Calendar.current
        
        let minutesComponents = (calendar as NSCalendar).components([.minute], from: startDate, to: endDate, options: [])
        
        let secondComponents = (calendar as NSCalendar).components([.second], from: startDate, to: endDate, options: [])
        
        return (minutesComponents.minute! ,secondComponents.second!)
    }
    
    // MARK: - FUNC008	Minutes difference betweeen two dates
    func minutesDiffernceBetweenDates(_ startDate: Date, endDate: Date) -> (Int)
    {
        let calendar = Calendar.current
        
        let minutesComponents = (calendar as NSCalendar).components([.minute], from: startDate, to: endDate, options: [])
        
        
        return (minutesComponents.minute )!
    }
    
    // MARK: - FUNC008	Minutes difference betweeen two dates
    func secondsDiffernceBetweenDates(_ startDate: Date, endDate: Date) -> (Int)
    {
        let calendar = Calendar.current
        
        let minutesComponents = (calendar as NSCalendar).components([.second], from: startDate, to: endDate, options: [])
        
        
        return (minutesComponents.second )!
    }

    
    
    
    
    
    
    // MARK: - FUNC009	Greater than given date
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    // MARK: - FUNC010	Lesser than given date
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    // MARK: - FUNC011	Equal to given date
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    // MARK: - FUNC012	Add seconds to date
    func addSeconds(_ seconds: Int , withDate _toDate:Date) -> Date!
    {
        var comps = DateComponents()
        
        comps.second = seconds
        
        let cal = Calendar.current
        
        let r = (cal as NSCalendar).date(byAdding: comps, to: _toDate, options: [])

        return r
    }
    
}
extension String
{
    
    
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String
    {
        return self.replace(" ", replacement: "")
    }
    
    func removeSpecialCharsFromString() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }
    
    
    // MARK - FUNC013	Get hour value from string
    func hourValue() -> Int
    {
        let mainString  = self.components(separatedBy: " ")
        
        let timeString = mainString.last
        
        
        let hourValue :String = ((timeString as AnyObject).components(separatedBy: ":") as NSArray).firstObject! as! String
        
        return Int(hourValue)!
        
    }
    // MARK: - FUNC014	Get minute value from string
    func minuteValue()->Int
    {
        let mainString  = self.components(separatedBy: " ")
        
        let timeString = mainString.last
        
        
        let hourValue :String = ((timeString as AnyObject).components(separatedBy: ":") as NSArray).object(at: 1) as! String
        
        return Int(hourValue)!
    }
    
    // MARK: - FUNC015	Get second value from string
    func secondValue()->Int
    {
        let mainString  = self.components(separatedBy: " ")
        
        let timeString = mainString.last!
        
        
        let hourValue :String = ((timeString as AnyObject).components(separatedBy: ":") as NSArray).lastObject! as! String
        
        return Int(hourValue)!
    }
    
    func stringFromTimeInterval(_ interval: TimeInterval) -> (hour: Int, minutes: Int, seconds: Int , fullString: String) {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        
        return ( hours, minutes, seconds,String(format: "%02d:%02d:%02d", hours, minutes, seconds))
    }
    
    // MARK: - FUNC016	Get height of view of given String
    
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
    
    func widthForView(_ text:String, font:UIFont, height:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height:height ))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.width
    }

    
    
}
extension Int
{
    static func random(_ range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

// MARK: - Feature  OneWord

extension String
{
    
    
    // MARK: - FUNC017	Get attributed Text
    func getAttributeText(_ fullString:String, withSubString searchstring :String) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: fullString as String)
        let str = NSString(string: fullString)
        let theRange = str.range(of: searchstring)
        if theRange.location != NSNotFound
        {
            attributedString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: theRange)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: theRange)
        }
        
        return attributedString
       
    }
    
    
    // MARK: - FUNC018	Is Given string found in Full string
    func isAttributeFound(_ fullString:String, withSubString searchstring :String) -> Bool
    {
        var isFound = false
        
        let str = NSString(string: fullString)
        let theRange = str.range(of: searchstring)
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
    func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIButton?
    {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIButton
    }
}

// MARK: - IMAGE VIEW FUNCTIONS
extension UIImage
{
   // MARK: - FUNC019	Render View to image
    
    class func imageWithView(_ view: UIView) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    
    class func renderUIViewToImage(_ viewToBeRendered:UIView?) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions((viewToBeRendered?.bounds.size)!, false, 0.0)
        viewToBeRendered!.drawHierarchy(in: viewToBeRendered!.bounds, afterScreenUpdates: true)
        viewToBeRendered!.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
}
