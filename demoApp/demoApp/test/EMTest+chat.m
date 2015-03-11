//
//  EMChatManager+chat.m
//  EaseMobClientSDK
//
//  Created by Ji Fang on 2/26/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import "EMTest.h"
#import "EaseMob.h"

@implementation EMTest (chat)

- (void)testChat:(NSString *)message{
    if (![chatMan isLoggedIn]) {
        [chatMan loginWithUsername:kLOGIN_ACCOUNT password:kPassword error:nil];
    }
    EMChatText *text = [[EMChatText alloc] initWithText:message];
    id<IEMMessageBody> body = [[EMTextMessageBody alloc] initWithChatObject:text];
    
    EMMessage *msg = [[EMMessage alloc]
                      initWithReceiver:kRECEIVER
                      bodies:@[body]];
    //[msg setRequireEncryption:YES];
 
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
}

- (void)setProgress:(float)progress forMessage:(EMMessage *)message {
}

-(void)testSendLocation{
    if (![chatMan isLoggedIn]) {
        [chatMan loginWithUsername:kLOGIN_ACCOUNT password:kPassword error:nil];
    }
    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:39.998484 longitude:116.32645 address:@"车库咖啡"];
    
    id<IEMMessageBody> body = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
    
    EMMessage *msg = [[EMMessage alloc]
                      initWithReceiver:kRECEIVER
                      bodies:@[body]];
    [msg setRequireEncryption:YES];
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];

}

- (void)testSendImage:(UIImage *)image {
    if (![chatMan isLoggedIn]) {
        [chatMan loginWithUsername:kLOGIN_ACCOUNT password:kPassword error:nil];
    }
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image
                                                      displayName:@"test image"];
    id<IEMMessageBody> body = [[EMImageMessageBody alloc] initWithImage:chatImage
                                                     thumbnailImage:chatImage];

    
    EMMessage *msg = [[EMMessage alloc] initWithReceiver:kRECEIVER
                                                  bodies:@[body]];
    static BOOL encryption = YES;
    [msg setRequireEncryption:encryption];
    encryption = !encryption;
    
    [chatMan asyncSendMessage:msg progress:self];
}

- (void)setProgress:(float)progress{
    NSLog(@"progress: %f", progress);
}

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error {
    if(!error) {
        EMConversation *conversation = message.conversation;
        //[conversation removeMessage:message.messageId];
        message = [conversation loadMessage:message.messageId];
    }
}

- (void)didReceiveMessage:(EMMessage *)message {
    NSLog(@"did receive message.");
}

- (void)didUpdateConversationList:(NSArray *)conversationList {
    NSLog(@"didUpdateConversationList");
}

@end
