//
//  WRCConfiguration.h
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CKRecord;

@interface WRCConfiguration : NSObject

///The URL used to log in to an account on the Divvy website
@property (strong, nonatomic) NSString *accountURLString;

///The element name used to find and autofill the username field
@property (strong, nonatomic) NSString *usernameFieldElementName;

///The element name used to find and autofill the password field
@property (strong, nonatomic) NSString *passwordFieldElementName;

///Create a configuration object from a CKRecord
+ (instancetype)configurationFromRecord: (CKRecord *)record;

///Whether the object's properties match the properties of another configuration
- (BOOL)isEqualToConfiguration: (WRCConfiguration *)configuration;

@end
