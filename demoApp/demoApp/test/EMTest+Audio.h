//
//  EMTest+Audio.h
//  demoApp
//
//  Created by Ji Fang on 4/2/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import "EMTestBase.h"
@protocol IEMMessageBody;
@interface EMTest (Audio)

- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;
- (void)playSendAudio;
- (void)stopPlayAudio;
-(void)setupReceiveVoice:(id<IEMMessageBody>)body;
-(void)playReceiverVoice;
@end
