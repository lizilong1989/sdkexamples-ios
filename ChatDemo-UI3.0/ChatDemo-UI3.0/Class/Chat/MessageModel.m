//
//  MessageModel.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "MessageModel.h"

#import "EaseMob.h"
#import "ConvertToCommonEmoticonsHelper.h"

@implementation MessageModel

- (instancetype)initWithMessage:(EMMessage *)message
{
    self = [super init];
    if (self) {
        _message = message;
        _firstMessageBody = [message.messageBodies firstObject];
        _isMediaPlaying = NO;
        
        NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
        NSString *login = [userInfo objectForKey:kSDKUsername];
        _nickname = (message.messageType == eMessageTypeChat) ? message.from : message.groupSenderName;
        _isSender = [login isEqualToString:_nickname] ? YES : NO;
        
        switch (_firstMessageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                EMTextMessageBody *textBody = (EMTextMessageBody *)_firstMessageBody;
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:textBody.text];
                self.text = didReceiveText;
            }
                break;
            case eMessageBodyType_Image:
            {
                EMImageMessageBody *imgMessageBody = (EMImageMessageBody *)_firstMessageBody;
                self.size = imgMessageBody.size;
                self.thumbnailSize = imgMessageBody.thumbnailSize;
                self.fileLocalPath = imgMessageBody.localPath;
                self.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
                if (self.isSender)
                {
                    self.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
                }else {
                    self.fileURLPath = imgMessageBody.remotePath;
                }
            }
                break;
            case eMessageBodyType_Location:
            {
                EMLocationMessageBody *locationBody = (EMLocationMessageBody *)_firstMessageBody;
                self.text = locationBody.address;
                self.latitude = locationBody.latitude;
                self.longitude = locationBody.longitude;
            }
                break;
            case eMessageBodyType_Voice:
            {
                EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)_firstMessageBody;
                self.fileSize = voiceBody.duration;
                self.chatVoice = (EMChatVoice *)voiceBody.chatObject;
                if (message.ext) {
                    NSDictionary *dict = message.ext;
                    BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
                    self.isMediaPlayed = isPlayed;
                }else {
                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
                    message.ext = dict;
                    [message updateMessageExtToDB];
                }
                // 本地音频路径
                self.fileLocalPath = voiceBody.localPath;
                self.fileURLPath = voiceBody.remotePath;
            }
                break;
            case eMessageBodyType_Video:{
                EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody *)_firstMessageBody;
                self.size = videoMessageBody.size;
                self.thumbnailSize = videoMessageBody.size;
                self.fileLocalPath = videoMessageBody.thumbnailLocalPath;
                self.thumbnailImage = [UIImage imageWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
                self.image = self.thumbnailImage;
            }
                break;
            default:
                break;
        }
    }
    
    return self;
}

- (NSString *)messageId
{
    return _message.messageId;
}

- (MessageDeliveryState)messageStatus
{
    return _message.deliveryState;
}

- (EMMessageType)messageType
{
    return _message.messageType;
}

- (MessageBodyType)contentType
{
    return self.firstMessageBody.messageBodyType;
}

@end
