//
//  RealmConfigManager.swift
//  anITa
//
//  Created by Vinayak on 6/13/17.
//  Copyright © 2017 MBRDI. All rights reserved.
//

import Foundation
import RealmSwift


/// RealmConfigManager class provides AES-256+SHA2 encryption for Realm DB
class RealmConfigManager: NSObject {
    private let defaults = UserDefaults.standard
    
    static let shared : RealmConfigManager =  {
        let instance = RealmConfigManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    
    /// Realm.Configuration can be used for encrypting the database file on disk with AES-256+SHA2, by supplying a 64-byte
    /// encryption key when creating a Realm.
    ///
    /// Use: let realm = try Realm(configuration: config)
    ///
    /// - Returns: Realm.Configuration which can be used to specify Realm config while doing database operations
    func getEncryptionConfig() -> Realm.Configuration? {
        guard let key = getEncryptionKeyData() else {
            return nil
        }
        var config = Realm.Configuration()
        config.encryptionKey = key
        
        return config
    }
    
    private func getEncryptionKeyData() -> Data? {
        var keyData = defaults.data(forKey: "RealmDBEncryptionKey")
        
        if keyData == nil {
            keyData = generateRandomBytes(lengthOfData: 64)
            defaults.set(keyData, forKey: "RealmDBEncryptionKey")
        }
        return keyData
    }
    
    //To be used one time only
    private func generateRandomBytes(lengthOfData: Int) -> Data? {
        var keyData = Data(count: lengthOfData)
        let result = keyData.withUnsafeMutableBytes {
            (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
            SecRandomCopyBytes(kSecRandomDefault, keyData.count, mutableBytes)
        }
        if result == errSecSuccess {
            return keyData
        } else {
            return nil
        }
    }
}



