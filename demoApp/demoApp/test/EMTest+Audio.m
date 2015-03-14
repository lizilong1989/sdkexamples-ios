//
//  EMTest+Audio.m
//  demoApp
//
//  Created by Ji Fang on 4/2/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import "EMTest+Audio.h"
#import "EMTest+Private.h"
#import "IEMMessageBody.h"

#import "EaseMob.h"

@implementation EMTest (Audio)

static EMChatVoice *_sendChatVoice = nil;
static EMChatVoice *_receiveChatVoice = nil;

- (void)startRecord {
    NSError *error = nil;
    [chatMan startRecordingAudioWithError:&error];
}

- (void)stopRecord {
    [chatMan asyncStopRecordingAudioWithCompletion:^(EMChatVoice *aChatVoice, NSError *error) {
        NSLog(@"finally it works.");
        _sendChatVoice = aChatVoice;
        EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:aChatVoice];
        NSArray *bodies = [[NSArray alloc] initWithObjects:body, nil];
        EMMessage *message = [[EMMessage alloc] initWithReceiver:kRECEIVER
                                                          bodies:bodies];
        [chatMan asyncSendMessage:message progress:nil];
    } onQueue:nil];
}

- (void)cancelRecord {
    [chatMan asyncCancelRecordingAudioWithCompletion:^(EMChatVoice *aChatVoice, EMError *error) {
        NSLog(@"cancelled.");
    } onQueue:nil];
}

- (void)playSendAudio {
    if(_sendChatVoice) {
        [chatMan asyncPlayAudio:_sendChatVoice
                     completion:^(EMError *error) {
                         NSLog(@"did played audio.");
                     } onQueue:nil];
    }
}

- (void)stopPlayAudio {
    [chatMan stopPlayingAudio];
}

-(void)playReceiverVoice{
    
    if(_receiveChatVoice) {
        [chatMan asyncPlayAudio:_receiveChatVoice
                     completion:^(EMError *error) {
                         NSLog(@"did played audio.");
                     } onQueue:nil];
    }
}

-(void)setupReceiveVoice:(id<IEMMessageBody>)body{
    _receiveChatVoice = (EMChatVoice *)body.chatObject;
}

@end
