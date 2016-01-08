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

#import <Foundation/Foundation.h>
#import "EMMessage.h"

@interface ChatSendHelper : NSObject

/**
 *  发送文字消息（包括系统表情）
 *
 *  @param str               发送的文字
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+ (EMMessage *)sendTextMessage:(NSString *)str
                            to:(NSString *)username
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)ext;

/**
 *  发送图片消息
 *
 *  @param image             发送的图片
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)username
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)ext;

/**
 *  发送音频消息
 *
 *  @param localPath         发送的音频地址
 *  @param duration          时长
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)username
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)ext;

/**
 *  发送视频
 *
 *  @param url               发送的视频
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)username
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)ext;
/**
 *  发送位置消息（定位）
 *
 *  @param latitude          经度
 *  @param longitude         纬度
 *  @param address           位置描述信息
 *  @param username          接收方
 *  @param messageType       消息类型
 *  @param ext               扩展信息
 *  @return 封装的消息体
 */
+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)username
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)ext;
@end
