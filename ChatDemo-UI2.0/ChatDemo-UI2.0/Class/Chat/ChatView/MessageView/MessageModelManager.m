/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "MessageModelManager.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "MessageModel.h"

@implementation MessageModelManager

+ (id)modelWithMessage:(EMMessage *)message
{
    EMMessageBody *messageBody = message.body;
    BOOL isSender = message.direction == EMMessageDirectionSend ? YES : NO;
    
    MessageModel *model = [[MessageModel alloc] init];
    model.isRead = message.isRead;
    model.messageBody = messageBody;
    model.message = message;
    model.type = messageBody.type;
    model.isSender = isSender;
    model.isPlaying = NO;
    model.messageType = message.chatType;
    if (model.type != EMChatTypeChat) {
        model.username = message.conversationId;
    }
    else{
        model.username = message.from;
    }

    /*
    if (isSender) {
        model.headImageURL = nil;
    }
    else{
        model.headImageURL = nil;
    }
     */
    
    switch (messageBody.type) {
        case EMMessageBodyTypeText:
        {
            // 表情映射。
            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
            model.content = didReceiveText;
        }
            break;
        case EMMessageBodyTypeImage:
        {
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
            model.thumbnailSize = imgMessageBody.thumbnailSize;
            model.size = imgMessageBody.size;
            model.localPath = imgMessageBody.localPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            if (isSender)
            {
                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            }else {
                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
            }
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            model.address = ((EMLocationMessageBody *)messageBody).address;
            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            model.time = ((EMVoiceMessageBody *)messageBody).duration;
            if (message.ext) {
                NSDictionary *dict = message.ext;
                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
                model.isPlayed = isPlayed;
            }else {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
                message.ext = dict;
                [[EMClient shareClient].chatManager updateMessage:message];
            }
            // 本地音频路径
            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
        }
            break;
        case EMMessageBodyTypeVideo:{
            EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody*)messageBody;
            model.thumbnailSize = videoMessageBody.thumbnailSize;
            model.size = videoMessageBody.thumbnailSize;
            model.localPath = videoMessageBody.thumbnailLocalPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
            model.image = model.thumbnailImage;
        }
            break;
        default:
            break;
    }
    
    return model;
}

@end
