//
//  EMChatViewController.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EMRefreshTableViewController.h"

#import "EMMessageModel.h"
#import "IConversationModel.h"
#import "IMessageModel.h"
#import "EMSendMessageCell.h"
#import "EMRecvMessageCell.h"
#import "EMMessageTimeCell.h"
#import "EMChatToolbar.h"
#import "EMLocationViewController.h"
#import "EMCDDeviceManager+Media.h"
#import "EMCDDeviceManager+ProximitySensor.h"
#import "UIViewController+HUD.h"
#import "EMHelper.h"

@interface EMChatViewController : EMRefreshTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, IChatManagerDelegate, EMCallManagerCallDelegate, EMMessageCellDelegate, EMCDDeviceManagerDelegate, EMChatToolbarDelegate, DXChatBarMoreViewDelegate, EMLocationViewDelegate>

@property (strong, nonatomic, readonly) EMConversation *conversation;

@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

@property (nonatomic) BOOL deleteConversationIfNull; //default YES;

@property (nonatomic) BOOL scrollToBottomWhenAppear; //default YES;

@property (nonatomic) BOOL showMessageMenuController; //default YES;

@property (nonatomic) BOOL isViewDidAppear;

@property (nonatomic) NSInteger pageCount;

@property (nonatomic) CGFloat timeCellHeight;

@property (strong, nonatomic) NSMutableArray *messsagesSource;

@property (strong, nonatomic) UIView *chatToolbar;

@property (strong, nonatomic) UIMenuController *menuController;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType;

/**
 *  获取消息，返回EMMessage类型的数据，可重写
 */
- (void)loadMessagesFrom:(long long)timestamp
                   count:(NSInteger)count
                  append:(BOOL)append;

/**
 *  格式化指定的消息列表，可重写
 *  messages中是EMMessage类型的数据
 *  返回的数据必须是id<IMessageModel>类型的数据
 */
- (NSArray *)formatMessages:(NSArray *)messages;

/**
 *  将制定消息插入数据源的最后，并且刷新页面，可重写
 */
-(void)addMessageToDataSource:(EMMessage *)message;

/**
 *  是否发送已读回执，可重写
 *  message 要发送已读回执的message
 *  read    message是否已读
 */
- (BOOL)shouldSendHasReadAckForMessage:(EMMessage *)message
                                  read:(BOOL)read;

/**
 *  指定消息列表发送已读回执， 消息列表中是EMMessage类型数据。可重写
 */
- (void)sendHasReadResponseForMessages:(NSArray*)messages;

@end
