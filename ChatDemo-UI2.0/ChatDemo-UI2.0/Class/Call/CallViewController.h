//
//  CallViewController.h
//  ChatDemo-UI2.0
//
//  Created by dhc on 15/3/24.
//  Copyright (c) 2015年 dhc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallViewController : UIViewController

+ (instancetype)shareController;

//向外拨打实时通话
- (EMError *)makeCallWithChatter:(NSString *)chatter
                            type:(EMCallSessionType)callType;

//接收到实时通话
- (EMError *)receiveCall:(EMCallSession *)callSession;

@end
