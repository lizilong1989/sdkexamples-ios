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

#import "EMBubbleView.h"

#define kEMMessageMaxImageSize 120
#define kEMMessageLocationHeight 95
#define kEMMessageVoiceHeight 23

extern CGFloat const EMMessageCellPadding;

@protocol EMMessageCellDelegate;
@interface EMMessageCell : UITableViewCell<IModelCell>
{
    UIButton *_statusButton;
    EMBubbleView *_bubbleView;
    
    NSLayoutConstraint *_statusWidthConstraint;
}

@property (weak, nonatomic) id<EMMessageCellDelegate> delegate;

@property (strong, nonatomic) UIImageView *avatarView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIButton *statusButton;

@property (strong, nonatomic) EMBubbleView *bubbleView;

@property (strong, nonatomic) id<IMessageModel> model;

@property (nonatomic) CGFloat statusSize UI_APPEARANCE_SELECTOR; //default 20;

@property (nonatomic) CGFloat bubbleMaxWidth UI_APPEARANCE_SELECTOR; //default 230;

@property (nonatomic) UIEdgeInsets bubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 15, 8, 10);

@property (strong, nonatomic) UIImage *bubbleBackgroundImage UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIFont *messageTextFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:15];

@property (nonatomic) UIColor *messageTextColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

@property (nonatomic) UIFont *messageLocationFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12];

@property (nonatomic) UIColor *messageLocationColor UI_APPEARANCE_SELECTOR; //default [UIColor whiteColor];

@property (nonatomic) NSArray *messageVoiceAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *messageVoiceDurationColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];

@property (nonatomic) UIFont *messageVoiceDurationFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12];

@property (nonatomic) UIFont *messageFileNameFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:13];

@property (nonatomic) UIColor *messageFileNameColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

@property (nonatomic) UIFont *messageFileSizeFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:11];

@property (nonatomic) UIColor *messageFileSizeColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<IMessageModel>)model;

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model;

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model;

@end

@protocol EMMessageCellDelegate <NSObject>

@optional

- (void)imageMessageCellSelcted:(id<IMessageModel>)model;

- (void)locationMessageCellSelcted:(id<IMessageModel>)model;

- (void)voiceMessageCellSelcted:(id<IMessageModel>)model;

- (void)videoMessageCellSelcted:(id<IMessageModel>)model;

- (void)fileMessageCellSelcted:(id<IMessageModel>)model;

@end

