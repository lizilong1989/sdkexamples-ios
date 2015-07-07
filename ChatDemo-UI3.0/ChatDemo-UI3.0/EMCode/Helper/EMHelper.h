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
#define KNOTIFICATION_CALL @"call"

@interface EMHelper : NSObject

@property (nonatomic) BOOL isShowingimagePicker;

+ (instancetype)shareHelper;

#pragma mark - send message

+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(EMMessageType)messageType
             requireEncryption:(BOOL)requireEncryption
                    messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMMessageType)messageType
                             requireEncryption:(BOOL)requireEncryption
                                    messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMMessageType)messageType
                       requireEncryption:(BOOL)requireEncryption
                              messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                           messageType:(EMMessageType)messageType
                     requireEncryption:(BOOL)requireEncryption
                            messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMMessageType)messageType
                     requireEncryption:(BOOL)requireEncryption
                            messageExt:(NSDictionary *)messageExt;

#pragma mark - call

@end
