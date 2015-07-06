//
//  EMMessageModel.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMessageModel.h"
#import "EMMessage.h"

@interface EMMessageModel : NSObject<IMessageModel>

@property (nonatomic) CGFloat cellHeight;
@property (strong, nonatomic, readonly) EMMessage *message;
@property (strong, nonatomic, readonly) id<IEMMessageBody> firstMessageBody;

@property (strong, nonatomic, readonly) NSString *messageId;
@property (nonatomic, readonly) MessageBodyType bodyType;
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

//image message
@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGSize thumbnailImageSize;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumbnailImage;

//media message
@property (nonatomic) BOOL isMediaPlaying;
@property (nonatomic) BOOL isMediaPlayed;
@property (nonatomic) CGFloat mediaDuration;

//file message
@property (strong, nonatomic) NSString *fileIconName;
@property (strong, nonatomic) NSString *fileName;
@property (nonatomic) CGFloat fileSize;
@property (strong, nonatomic) NSString *fileSizeDes;

//消息：附件本地地址
@property (strong, nonatomic) NSString *fileLocalPath;
//消息：压缩附件本地地址
@property (strong, nonatomic) NSString *thumbnailFileLocalPath;
//消息：附件下载地址
@property (strong, nonatomic) NSString *fileURLPath;
//消息：压缩附件下载地址
@property (strong, nonatomic) NSString *thumbnailFileURLPath;

- (instancetype)initWithMessage:(EMMessage *)message;

@end
