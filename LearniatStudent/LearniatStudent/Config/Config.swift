//
//  Config.swift
//  anITa
//
//  Created by administrator on 6/13/17.
//  Copyright © 2017 MBRDI. All rights reserved.
//

import Foundation
import UIKit

enum Schemes: String {
    case Development = "Development"
    case Production = "Production"
}

class Config: NSObject {
    // Singleton instance
    static let sharedInstance = Config()
    
    var configs: NSDictionary!
    
    override init() {
        // Take current configuration value from the `Info.plist`. `Config` is the name of the Info plist key (fig. 7).
        //`currentConfiguration` Can be `Debug`, `Staging`, or whatever you created in previous steps.
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Config")!
        
        // Loads `Config.plist` and stores it to dictionary. The configuration names are the keys of the `configs` dictionary.
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")!
        configs = NSDictionary(contentsOfFile: path)!.object(forKey: currentConfiguration) as! NSDictionary
    }
}

extension Config {
    func baseUrl() -> String {
        return configs.object(forKey: "BaseUrl") as! String
    }
    
    func getPhpUrl()->String{
        return configs.object(forKey: "PHPURL") as! String
    }

    func getCurrentScheme() -> Schemes {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Config")!
        return Schemes(rawValue: currentConfiguration as! String)!
    }
}
