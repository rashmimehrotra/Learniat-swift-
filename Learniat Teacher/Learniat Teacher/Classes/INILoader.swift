//
//  INILoader.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit

let kClassName      = "ClassName"

let kEndTime        = "EndTime"

let kSessionState   = "SessionState"

let kStartTime      = "StartTime"

let kRoomId         = "RoomId"

let kRoomName       = "RoomName"


let kSessionId      = "SessionId"

let kScheduled      =  "Scheduled"

let kopened         =  "Opened"

let kLive           =  "Live"

let kCanClled       =  "Cancelled"

let kEnded          =  "Ended"




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

let topbarColor         : UIColor = UIColor(red: 46/255.0, green:88/255.0, blue:128/255.0, alpha: 1)

let standard_Green      : UIColor = UIColor(red: 76/255.0, green:217/255.0, blue:100/255.0, alpha: 1)

let standard_Red        : UIColor = UIColor(red: 255/255.0, green:59/255.0, blue:48/255.0, alpha: 1)

let standard_TextGrey   : UIColor = UIColor(red: 170/255.0, green:170/255.0, blue:170/255.0, alpha: 1)

let standard_Button     : UIColor = UIColor(red: 0/255.0, green:174/255.0, blue:239/255.0, alpha: 1)

let lightGrayColor      : UIColor = UIColor.lightGrayColor()

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
                
                
                for var index = 0; index < datavalue.count; index++
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
        
        
        for var i = 1; i < 11 ; i++
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
}

// MARK: - UILabel Extension

class UIVerticalAlignLabel: UILabel {
    
    enum VerticalAlignment : Int {
        case VerticalAlignmentTop = 0
        case VerticalAlignmentMiddle = 1
        case VerticalAlignmentBottom = 2
    }
    
    var verticalAlignment : VerticalAlignment = .VerticalAlignmentTop {
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
        
        switch(verticalAlignment) {
        case .VerticalAlignmentTop:
            return CGRectMake(bounds.origin.x, bounds.origin.y, rect.size.width, rect.size.height)
        case .VerticalAlignmentMiddle:
            return CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height) / 2, rect.size.width, rect.size.height)
        case .VerticalAlignmentBottom:
            return CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height), rect.size.width, rect.size.height)
        default:
            return bounds
        }
    }
    
    override func drawTextInRect(rect: CGRect) {
        let r = self.textRectForBounds(rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawTextInRect(r)
    }
}
