//
//  EMChatViewController.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EMRefreshTableViewController.h"

#import "EaseMob.h"
#import "IConversationModel.h"
#import "IMessageModel.h"
#import "EMSendMessageCell.h"
#import "EMRecvMessageCell.h"
#import "EMMessageTimeCell.h"
#import "EMCDDeviceManager+Media.h"
#import "UIViewController+HUD.h"

@interface EMChatViewController : EMRefreshTableViewController<IChatManagerDelegate, EMCallManagerCallDelegate, EMMessageCellDelegate>

@property (strong, nonatomic, readonly) EMConversation *conversation;

@property (nonatomic) BOOL deleteConversationIfNull; //default YES;

@property (nonatomic) BOOL scrollToBottomWhenAppear; //default YES;

@property (nonatomic) BOOL showMessageMenuController; //default YES;

@property (nonatomic) BOOL isViewDidAppear;

@property (nonatomic) NSInteger pageCount;

@property (nonatomic) CGFloat timeCellHeight;

@property (strong, nonatomic) UIView *chatToolbar;

@property (strong, nonatomic) UIMenuController *menuController;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
