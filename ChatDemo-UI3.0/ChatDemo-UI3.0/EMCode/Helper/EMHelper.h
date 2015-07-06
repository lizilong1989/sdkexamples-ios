//
//  EMHelper.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "EaseMob.h"

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

@interface EMHelper : NSObject

+ (instancetype)shareHelper;

+ (EMMessage *)sendTextMessage:(NSString *)text
                        toUser:(NSString *)toUser
                   messageType:(EMMessageType)messageType
             requireEncryption:(BOOL)requireEncryption
                    messageExt:(NSDictionary *)messageExt;

@end
