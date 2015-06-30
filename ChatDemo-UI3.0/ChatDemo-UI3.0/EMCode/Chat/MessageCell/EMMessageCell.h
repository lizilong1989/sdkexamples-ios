//
//  EMMessageCell.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IModelCell.h"
#import "IMessageModel.h"

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

@interface EMMessageCell : UITableViewCell<IModelCell>

@property (strong, nonatomic) id<IMessageModel> model;

@property (nonatomic) CGFloat avatarSize UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat avatarCornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIFont *nameLabelFont UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *nameLabelColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat nameLabelHeight UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat statusSize UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) NSString *backgroundImageTheme UI_APPEARANCE_SELECTOR;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     isSender:(BOOL)isSender;

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model;

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model;

@end
