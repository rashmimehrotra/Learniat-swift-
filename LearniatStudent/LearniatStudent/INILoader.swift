//
//  INILoader.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit


let MultipleChoice      :String         = "Multiple Choice"
let MultipleResponse    :String         = "Multiple Response"
let MatchColumns        :String         = "Match Columns"
let OverlayScribble     :String         = "Overlay Scribble"
let FreshScribble       :String         = "Fresh Scribble"
let text                :String         = "Text"
let Polling             :String         = "Poll"   // Development Over Api Pending
let SoreFinger          :String         = "Sore finger"     // Pending
let Sequencing          :String         = "Sequencing"      //Pending
let OneString           :String         = "Word map"        //Design Pending APi Pending
let TextAuto            :String         = "One string"      // Pending



let kQuestionTag                = "Question"
let kQuestionName               = "Name"
let kQuestionType               = "QuestionType"
let kScribble                   = "Scribble"
let kOptionTagMain              = "Options"

let kOptionTag                  = "Option"




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

let HelveticaNeueItalic     = "HelveticaNeue-Italic"


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


let textColor : UIColor     = UIColor(red: 36/255.0, green: 68/255.0, blue: 99/255.0, alpha: 1)

let whiteBackgroundColor: UIColor = UIColor(red: 246/255.0, green:246/255.0, blue:246/255.0, alpha: 1)

let darkBackgroundColor: UIColor = UIColor(red: 36/255.0, green:68/255.0, blue:99/255.0, alpha: 1) // 244463

let lightBackgroundColor: UIColor = UIColor(red: 31/255.0, green:61/255.0, blue:89/255.0, alpha: 1) // 1F3D59

let topbarColor         : UIColor = UIColor(red: 46/255.0, green:88/255.0, blue:128/255.0, alpha: 1)

let standard_Green      : UIColor = UIColor(red: 76/255.0, green:217/255.0, blue:100/255.0, alpha: 1)

let standard_Red        : UIColor = UIColor(red: 255/255.0, green:59/255.0, blue:48/255.0, alpha: 1)

let standard_Yellow     : UIColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1)

let dark_Yellow     : UIColor = UIColor(red: 248/255.0, green: 156/255.0, blue: 31/255.0, alpha: 1) //F89C1F

let standard_TextGrey   : UIColor = UIColor(red: 170/255.0, green:170/255.0, blue:170/255.0, alpha: 1) //AAAAAA

let standard_Button     : UIColor = UIColor(red: 0/255.0, green:174/255.0, blue:239/255.0, alpha: 1)

let standard_Button_Disabled     : UIColor = UIColor.lightGray

let lightGrayColor      : UIColor = UIColor.lightGray

let lightGrayTopBar     : UIColor = UIColor(red: 238/255.0, green:238/255.0, blue:238/255.0, alpha: 1) //EEEEEE

let LineGrayColor       : UIColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 0.8) //999999

let blackTextColor      : UIColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)   //333333

let topicsLineColor     : UIColor = UIColor(red: 236.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)

let progressviewBackground    : UIColor = UIColor(red:213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1)

let RedCellBackground    : UIColor = UIColor(red:255.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 0.6)

let whiteColor          = UIColor.white



let scheduledColor : UIColor = UIColor(red: 58.0/255.0, green:114.0/255.0, blue:168.0/255.0, alpha: 1)

let scheduledBorderColor : UIColor = UIColor(red: 58.0/255.0, green:114.0/255.0, blue:168.0/255.0, alpha: 1)

let OpenedColor : UIColor = UIColor(red: 0.0/255.0, green:174.0/255.0, blue:239/255.0, alpha: 1)

let OpenedBorderColor : UIColor = UIColor(red: 0.0/255.0, green:174.0/255.0, blue:239/255.0, alpha: 1)



let CancelledBorderColor : UIColor = UIColor(red: 255/255.0, green:59/255.0, blue:48/255.0, alpha: 1)



let LiveColor : UIColor = UIColor(red: 8.0/255.0, green:198.0/255.0, blue:246.0/255.0, alpha: 1)

let EndedColor : UIColor = UIColor(red:152.0/255.0, green:180.0/255.0, blue:207.0/255.0, alpha: 1)



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



// MARK: - ImageView Extension

extension CustomProgressImageView
{
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
      
        
        
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            completion(data, response, error)
//            })        
//.resume()
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
    
    func resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    
}

// MARK: - UILabel Extension

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
    
    func daysBetweenDate(_ startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])
        
        return components.day!
    }
    
    
    func minutesAndSecondsDiffernceBetweenDates(_ startDate: Date, endDate: Date) -> (minutes:Int, second:Int)
    {
        let calendar = Calendar.current
        
        let minutesComponents = (calendar as NSCalendar).components([.minute], from: startDate, to: endDate, options: [])
        
        let secondComponents = (calendar as NSCalendar).components([.second], from: startDate, to: endDate, options: [])
        
        return (minutesComponents.minute! ,secondComponents.second!)
    }
    
    
    func minutesDiffernceBetweenDates(_ startDate: Date, endDate: Date) -> (Int)
    {
        let calendar = Calendar.current
        
        let minutesComponents = (calendar as NSCalendar).components([.minute], from: startDate, to: endDate, options: [])
        
        
        return (minutesComponents.minute )!
    }
    
    
    
    
    
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
    
    
    
    func hourValue() -> Int
    {
        let mainString = self.components(separatedBy: " ")
        
        let timeString = mainString.last!
        
        
        let hourValue :String = ((timeString as AnyObject).components(separatedBy: ":") as NSArray).firstObject! as! String
        
        return Int(hourValue)!
        
    }
    
    func minuteValue()->Int
    {
        let mainString  = self.components(separatedBy: " ")
        
        let timeString = mainString.last!
        
        
        let hourValue :String = ((timeString as AnyObject).components(separatedBy: ":") as NSArray).object(at: 1) as! String
        
        return Int(hourValue)!
    }
    
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
extension NSMutableArray
{
    func shuffleValue()
    {
        if count < 2
        {
            return
        }
        for i in 0..<(count - 1)
        {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}

extension UIImage
{
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

extension UIButton
{
    func loadingIndicator(show: Bool) {
        let tag = 9876
        if show {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
            indicator.color = standard_TextGrey
        } else {
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}




