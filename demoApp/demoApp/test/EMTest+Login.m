//
//  EMTest+Login.m
//  demoApp
//
//  Created by dujiepeng on 14-5-7.
//  Copyright (c) 2014年 EaseMob. All rights reserved.
//

#import "EMTest+Login.h"
#import "UIViewController+HUD.h"
#import "EMError.h"

@implementation EMTest (Login)
// 登陆
- (NSDictionary *)login{
    NSDictionary *ret = nil;
    ret =  [[EaseMob sharedInstance].chatManager loginWithUsername:kLOGIN_ACCOUNT
                                                          password:kPassword
                                                             error:nil];

    return ret;
}

- (void)logout{
    [[EaseMob sharedInstance].chatManager asyncLogoff];
}

@end
