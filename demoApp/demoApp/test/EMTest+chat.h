//
//  EMChatManager+chat.h
//  EaseMobClientSDK
//
//  Created by Ji Fang on 2/26/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import "EMTestBase.h"
#import "EaseMob.h"

@class UIImage;
@interface EMTest (chat)<IChatManagerDelegate, IEMChatProgressDelegate>

- (void)testChat:(NSString *)message;
- (void)testSendImage:(UIImage *)image;
- (void)testSendLocation;
@end
