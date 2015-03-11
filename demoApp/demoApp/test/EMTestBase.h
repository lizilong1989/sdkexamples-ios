//
//  EMTest.h
//  EaseMobClientSDK
//
//  Created by jifang on 1/19/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IChatManager;
@protocol IUserManager;

@interface EMTest : NSObject {
    id<IChatManager> chatMan;
    id<IUserManager> userMan;
    NSDictionary *_loginInfo;
}

@end
