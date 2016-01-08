//
//  EMRotbotChatViewCell.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 15/8/3.
//  Copyright (c) 2015年 dujiepeng. All rights reserved.
//

#import "EMRotbotChatViewCell.h"
#import "EMRobotChatTextBubbleView.h"

@implementation EMRotbotChatViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setMessageModel:(MessageModel *)model
{
    [super setMessageModel:model];
    
    if (model.type != EMChatTypeChat) {
        _nameLabel.text = model.nickName;
        _nameLabel.hidden = model.isSender;
    }
    
    _bubbleView.model = self.messageModel;
    [_bubbleView sizeToFit];
}

- (EMChatBaseBubbleView *)bubbleViewForMessageModel:(MessageModel *)messageModel
{
    switch (messageModel.type) {
        case EMMessageBodyTypeText:
        {
            return [[EMRobotChatTextBubbleView alloc] init];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            return [[EMChatImageBubbleView alloc] init];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            return [[EMChatAudioBubbleView alloc] init];
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            return [[EMChatLocationBubbleView alloc] init];
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            return [[EMChatVideoBubbleView alloc] init];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

+ (CGFloat)bubbleViewHeightForMessageModel:(MessageModel *)messageModel
{
    switch (messageModel.type) {
        case EMMessageBodyTypeText:
        {
            return [EMRobotChatTextBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            return [EMChatImageBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            return [EMChatAudioBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            return [EMChatLocationBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            return [EMChatVideoBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        default:
            break;
    }
    
    return HEAD_SIZE;
}

@end
