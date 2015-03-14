//
//  EMTest.m
//  EaseMobClientSDK
//
//  Created by jifang on 1/19/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import "EMTestBase.h"
#import "EMTest+Private.h"
#import "SMTChatCryptor.h"
#import "EaseMob.h"

@interface EMTest()<EMChatManagerDelegate> {
}

- (void)registerNotifications;
- (void)unregisterNotifications;

@end

@implementation EMTest

- (void)registerNotifications {
    [self unregisterNotifications];
    [chatMan addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)unregisterNotifications {
    [chatMan removeDelegate:self];
}

- (id)init {
    if(self=[super init]) {
        chatMan = [EaseMob sharedInstance].chatManager;
        //userMan = [EaseMob sharedInstance].userManager;
        //SMTChatCryptor *cryptor = [SMTChatCryptor sharedInstance];
        // todo: uncomment this line will use smt chat cryptor. 
        //[chatMan setChatCryptor:cryptor];
        
        [self registerNotifications];
    }
    
    return self;
}

- (void)dealloc {
    [self unregisterNotifications];
}

@end
