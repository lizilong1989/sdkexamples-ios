/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AppDelegate+Parse.h"
#import <Parse/Parse.h>
#import "UserProfileManager.h"

@implementation AppDelegate (Parse)

- (void)parseApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"cdEUEwVKuT8rYP83SuLIx7MFCvhiz6cnXtQ5DPBv"
                  clientKey:@"LJcGOwqSxHquawLbrb2OSesxtM81rCZSBSXZVvhI"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    // setup ACL
    PFACL *defaultACL = [PFACL ACL];

    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

- (void)initParse
{
    [[UserProfileManager sharedInstance] initParse];
}

- (void)clearParse
{
    [[UserProfileManager sharedInstance] clearParse];
}

@end
