//
//  EMTest+Register.m
//  demoApp
//
//  Created by dujiepeng on 14-5-7.
//  Copyright (c) 2014年 EaseMob. All rights reserved.
//

#import "EMTest+Register.h"

@implementation EMTest (Register)
- (BOOL)registerNewAccount{
    BOOL ret = NO;
    ret = [[EaseMob sharedInstance].chatManager
     registerNewAccount:kREGISTER_ACCOUNT
     password:kPassword error:nil];
    return ret;
}
@end
