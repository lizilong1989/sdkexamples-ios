//
//  RobotChatViewController.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 15/7/27.
//  Copyright (c) 2015年 dujiepeng. All rights reserved.
//

#import "RobotChatViewController.h"
#import "RobotManager.h"
#import "ChatSendHelper.h"
@implementation RobotChatViewController

-(void)sendImageMessage:(UIImage *)image{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image
                                                            toUsername:self.conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:NO
                                                                   ext:ext];
    [self addMessage:tempMessage];
}

-(void)sendTextMessage:(NSString *)textMessage{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage
                                                            toUsername:self.conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:NO
                                                                   ext:ext];
    [self addMessage:tempMessage];
}
-(void)sendAudioMessage:(EMChatVoice *)voice{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice
                                            toUsername:self.conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:ext];
    [self addMessage:tempMessage];
}

-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *locationMessage = [ChatSendHelper sendLocationLatitude:latitude
                                                            longitude:longitude
                                                              address:address
                                                           toUsername:self.conversation.chatter
                                                          messageType:[self messageType]
                                                    requireEncryption:NO
                                                                  ext:ext];
    [self addMessage:locationMessage];
}

-(void)sendVideoMessage:(EMChatVideo *)video{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *tempMessage = [ChatSendHelper sendVideo:video
                                            toUsername:self.conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO
                                                   ext:ext];
    [self addMessage:tempMessage];
}
@end
