//
//  WRCConfiguration.m
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import CloudKit;

#import "WRCConfiguration.h"

@implementation WRCConfiguration

+ (instancetype)configurationFromRecord: (CKRecord *)record
{
    WRCConfiguration *configuration = [[WRCConfiguration alloc] init];
    configuration.accountURLString = record[@"account_url"];
    configuration.usernameFieldElementName = record[@"username_key"];
    configuration.passwordFieldElementName = record[@"password_key"];
    return configuration;
}

@end
