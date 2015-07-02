//
//  IMessageModel.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "EMChatManagerDefs.h"

@class EMMessage;
@protocol IMessageModel <NSObject>

@property (strong, nonatomic, readonly) EMMessage *message;

@property (strong, nonatomic, readonly) NSString *messageId;
@property (nonatomic, readonly) MessageBodyType contentType;

@property (nonatomic) BOOL isSender;    //是否是发送者
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) NSString *failImageName;

//text message
@property (strong, nonatomic) NSString *text;

//image message
@property (nonatomic) CGSize thumbnailSize;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumbnailImage;

//location message
@property (strong, nonatomic) NSString *address;

//file message
@property (strong, nonatomic) NSString *fileIconName;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fileSizeDes;

- (instancetype)initWithMessage:(EMMessage *)message;

@end
