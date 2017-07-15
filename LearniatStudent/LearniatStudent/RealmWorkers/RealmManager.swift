//
//  RealmManager.swift
//  anITa
//
//  Created by administrator on 6/14/17.
//  Copyright © 2017 MBRDI. All rights reserved.
//
import Foundation
import RealmSwift
import ObjectMapper

class RealmManager: NSObject {
    static let shared : RealmManager =  {
        let instance = RealmManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    var realm: Realm {
        get {
            do {
                
                return try Realm()
                
            } catch {
                print ("Error creating realm")
            }
            return try! Realm()
        }
    }
    
    private func realmWithEncryption() -> Realm {
        guard let config = RealmConfigManager.shared.getEncryptionConfig() else {
            return try! Realm()
        }
        return try! Realm(configuration: config)
    }
    
     /// Delete local database
    func deleteDatabase() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    func deleteObjects(objs: [Object?]) throws {
        let flatObjs = objs.filter {$0 != nil}
        do {
            try realm.write({
                for obj in flatObjs {
                    realm.delete(obj!)
                }
            })
        } catch let error {
            print (error.localizedDescription)
            throw error
        }
    }
    
    func deleteObject(obj: Object) {
        try! realm.write({
            realm.delete(obj)
        })
    }
    
     /// Save array of objects to database
    func saveObjects(objs: [Object]) {
        try! realm.write({
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
            realm.add(objs, update: true)
        })
    }
    
     /// Returns an array as Results<object>?
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm.objects(type)
    }
    
    func getDictonaryFromModel(objectValue:Mappable) -> [String: Any] {
        let jsonDict = objectValue.toJSON()
        return jsonDict
    }
}

// MARK: - Extension of Realm List
extension List {
    
    /// Converts Realm List to Swift Array
    ///
    /// - Returns: Swift Array of the Type of List Objects
    func toArray() -> [T] {
        let array = Array(self)
        return array
    }
}
