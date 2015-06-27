//
//  WRCKeychainManager.swift
//  WrightCycle
//
//  Created by Rob Timpone on 6/27/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

import Valet
import UIKit

@objc class WRCKeychainManager {
   
    ///An enum describing a type of information stored in the keychain
    @objc enum WRCKeychainItemType: Int {
        
        case Username
        case Password
        
        //need to do this because enums exposed to objective-c cannot have a String raw type
        func identifier() -> String {
            switch self {
                case Username: return "wrc_username"
                case Password: return "wrc_password"
            }
        }
    }
    
    ///A shared instance intended to be used as a singleton
    static let sharedInstance = WRCKeychainManager()
    
    ///An abstraction layer that handles iOS keychain reads, writes, and deletes
    private let valet = VALValet(identifier: "com.self.wrightcycle", accessibility: .WhenUnlocked)
    
    /** 
        Save a string in the iOS keychain for a certain data type
    
        :param:     string      The string to save in the keychain
        :param:     itemType    The type of information being saved
    */
    func saveStringToKeychain(string: String, ofItemType itemType: WRCKeychainItemType) {
        valet.setString(string, forKey: itemType.identifier())
    }
    
    /**
        Retrieve a string from the iOS keychain for a certain data type
    
        :param:     itemType    The type of item to retrieve
        :returns:               A string from the keychain for the item type
    */
    func retrieveStringFromKeychainOfType(itemType: WRCKeychainItemType) -> String? {
        return valet.stringForKey(itemType.identifier())
    }
    
    ///Resets any app-specific strings saved in the keychain. Useful for resetting the keychain when the app is first run.
    func resetItemsSavedInKeychain() {
        valet.removeAllObjects()
    }
    
}
