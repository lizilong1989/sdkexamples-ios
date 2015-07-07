//
//  EMHelper.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMHelper.h"

#import "ConvertToCommonEmoticonsHelper.h"

@interface EMChatImageOptions : NSObject<IChatImageOptions>

@property (assign, nonatomic) CGFloat compressionQuality;

@end

static EMHelper *helper = nil;

@implementation EMHelper

@synthesize isShowingimagePicker = _isShowingimagePicker;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

+(instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[EMHelper alloc] init];
    });
    
    return helper;
}

#pragma mark - private

- (void)commonInit
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:30 / 255.0 green:167 / 255.0 blue:252 / 255.0 alpha:1.0]];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0], NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
}

#pragma mark - public

+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)toUser
                   messageType:(EMMessageType)messageType
             requireEncryption:(BOOL)requireEncryption
                    messageExt:(NSDictionary *)messageExt

{
    // 表情映射。
    NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
    EMChatText *textChat = [[EMChatText alloc] initWithText:willSendText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:textChat];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:toUser bodies:[NSArray arrayWithObject:body]];
    message.requireEncryption = requireEncryption;
    message.messageType = messageType;
    message.ext = messageExt;
    EMMessage *retMessage = [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
    
    return retMessage;
}

+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMMessageType)messageType
                             requireEncryption:(BOOL)requireEncryption
                                    messageExt:(NSDictionary *)messageExt
{
    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude longitude:longitude address:address];
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:to bodies:[NSArray arrayWithObject:body]];
    message.requireEncryption = requireEncryption;
    message.messageType = messageType;
    message.ext = messageExt;
    EMMessage *retMessage = [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
    
    return retMessage;
}

+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMMessageType)messageType
                       requireEncryption:(BOOL)requireEncryption
                              messageExt:(NSDictionary *)messageExt
{
    id<IChatImageOptions> options = [[EMChatImageOptions alloc] init];
    [options setCompressionQuality:0.6];
    
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image.jpg"];
    [chatImage setImageOptions:options];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:to bodies:[NSArray arrayWithObject:body]];
    message.requireEncryption = requireEncryption;
    message.messageType = messageType;
    message.ext = messageExt;
    EMMessage *retMessage = [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
    
    return retMessage;
}

+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(EMMessageType)messageType
                           requireEncryption:(BOOL)requireEncryption
                                  messageExt:(NSDictionary *)messageExt
{
    EMChatVoice *chatVoice = [[EMChatVoice alloc] initWithFile:localPath displayName:@"audio"];
    chatVoice.duration = duration;
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:chatVoice];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:to bodies:[NSArray arrayWithObject:body]];
    message.requireEncryption = requireEncryption;
    message.messageType = messageType;
    message.ext = messageExt;
    EMMessage *retMessage = [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
    
    return retMessage;
}

+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMMessageType)messageType
                     requireEncryption:(BOOL)requireEncryption
                            messageExt:(NSDictionary *)messageExt
{
    EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[url relativePath] displayName:@"video.mp4"];
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithChatObject:chatVideo];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:to bodies:[NSArray arrayWithObject:body]];
    message.requireEncryption = requireEncryption;
    message.messageType = messageType;
    message.ext = messageExt;
    EMMessage *retMessage = [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
    
    return retMessage;
}

@end
