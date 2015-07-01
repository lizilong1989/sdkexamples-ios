//
//  EMChatViewController.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMRefreshTableViewController.h"

#import "EaseMob.h"
#import "IConversationModel.h"
#import "IMessageModel.h"
#import "EMSendMessageCell.h"
#import "EMRecvMessageCell.h"
#import "EMMessageTimeCell.h"

@interface EMChatViewController : EMRefreshTableViewController<IChatManagerDelegate, EMCallManagerCallDelegate>

@property (strong, nonatomic, readonly) EMConversation *conversation;

@property (nonatomic) BOOL deleteConversationIfNull;

@property (nonatomic) NSInteger pageCount;

@property (nonatomic) CGFloat timeCellHeight;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
