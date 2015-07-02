//
//  MessageModel.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMessageModel.h"
#import "EMMessage.h"

@class EMChatVoice;
@interface MessageModel : NSObject<IMessageModel>

@property (strong, nonatomic, readonly) EMMessage *message;
@property (strong, nonatomic, readonly) id<IEMMessageBody> firstMessageBody;

@property (strong, nonatomic, readonly) NSString *messageId;
@property (nonatomic, readonly) MessageBodyType contentType;
@property (nonatomic, readonly) MessageDeliveryState messageStatus;
@property (nonatomic, readonly) EMMessageType messageType;  // 消息类型（单聊，群里，聊天室）

@property (nonatomic) BOOL isSender;    //是否是发送者
@property (nonatomic) BOOL isRead;      //是否已读
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) NSString *failImageName;

//text message
@property (strong, nonatomic) NSString *text;

//location message
@property (strong, nonatomic) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

//file message
@property (strong, nonatomic) NSString *fileIconName;
@property (strong, nonatomic) NSString *fileName;
@property (nonatomic) CGFloat fileSize;
@property (strong, nonatomic) NSString *fileSizeDes;
@property (strong, nonatomic) NSString *fileLocalPath;
@property (strong, nonatomic) NSString *fileURLPath;

//image message
@property (nonatomic) CGSize size;
@property (nonatomic) CGSize thumbnailSize;
@property (strong, nonatomic) NSString *imageURLPath;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *thumbnailImageURLPath;
@property (strong, nonatomic) UIImage *thumbnailImage;

@property (nonatomic) BOOL isMediaPlaying;
@property (nonatomic) BOOL isMediaPlayed;

//audio message
@property (nonatomic, strong) EMChatVoice *chatVoice;

- (instancetype)initWithMessage:(EMMessage *)message;

@end
