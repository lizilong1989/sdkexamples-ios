//
//  IMessageModel.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class EMMessage;
@protocol IMessageModel <NSObject>

@property (strong, nonatomic, readonly) EMMessage *message;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;

- (instancetype)initWithMessage:(EMMessage *)message;

@end
