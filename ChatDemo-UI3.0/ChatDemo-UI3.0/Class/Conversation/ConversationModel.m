//
//  ConversationModel.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ConversationModel.h"

#import "EMConversation.h"

@implementation ConversationModel

- (instancetype)initWithConversation:(EMConversation *)conversation
{
    self = [super init];
    if (self) {
        _conversation = conversation;
        _title = _conversation.chatter;
        if (conversation.conversationType == eConversationTypeChat) {
            _avatarImage = [UIImage imageNamed:@"user.png"];
        }
        else{
            _avatarImage = [UIImage imageNamed:@"group.png"];
        }
    }
    
    return self;
}

@end
