//
//  EMBubbleView.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/29.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const EMMessageCellIdentifierSendText;
extern NSString *const EMMessageCellIdentifierSendLocation;
extern NSString *const EMMessageCellIdentifierSendVoice;
extern NSString *const EMMessageCellIdentifierSendVideo;
extern NSString *const EMMessageCellIdentifierSendImage;
extern NSString *const EMMessageCellIdentifierSendFile;

extern NSString *const EMMessageCellIdentifierRecvText;
extern NSString *const EMMessageCellIdentifierRecvLocation;
extern NSString *const EMMessageCellIdentifierRecvVoice;
extern NSString *const EMMessageCellIdentifierRecvVideo;
extern NSString *const EMMessageCellIdentifierRecvImage;
extern NSString *const EMMessageCellIdentifierRecvFile;

@interface EMBubbleView : UIView

@property (strong, nonatomic) NSString *identifier;

@property (strong, nonatomic) UIImage *backgroundImage;

@property (nonatomic) UIEdgeInsets margin;

@property (strong, nonatomic) UILabel *textLabel;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImageView *locationImageView;

@property (strong, nonatomic) UILabel *locationLabel;

- (instancetype)initWithIdentifier:(NSString *)identifier
                            margin:(UIEdgeInsets)margin;

@end
