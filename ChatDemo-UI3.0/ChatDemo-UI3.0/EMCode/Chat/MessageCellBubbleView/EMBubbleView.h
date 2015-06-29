//
//  EMBubbleView.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/29.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const EMMessageCellPadding;

extern NSString *const EMMessageCellIdentifierRecvText;
extern NSString *const EMMessageCellIdentifierRecvLocation;
extern NSString *const EMMessageCellIdentifierRecvVoice;
extern NSString *const EMMessageCellIdentifierRecvVideo;
extern NSString *const EMMessageCellIdentifierRecvImage;
extern NSString *const EMMessageCellIdentifierRecvFile;

extern NSString *const EMMessageCellIdentifierSendText;
extern NSString *const EMMessageCellIdentifierSendLocation;
extern NSString *const EMMessageCellIdentifierSendVoice;
extern NSString *const EMMessageCellIdentifierSendVideo;
extern NSString *const EMMessageCellIdentifierSendImage;
extern NSString *const EMMessageCellIdentifierSendFile;

@interface EMBubbleView : UIView

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) NSString *backgroundImageName;

- (instancetype)initWithIdentifier:(NSString *)identifier;

@end
