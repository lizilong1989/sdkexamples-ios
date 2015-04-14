//
//  CallViewController.h
//  ChatDemo-UI2.0
//
//  Created by dhc on 15/4/13.
//  Copyright (c) 2015年 dhc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallViewController : UIViewController<UIAlertViewDelegate, EMCallManagerDelegate>
{
    BOOL _isSetupSubviews;
    NSTimer *_timeTimer;
    AVAudioPlayer *_ringPlayer;
    
    UILabel *_statusLabel;
    UILabel *_timeLabel;
    UILabel *_nameLabel;
    UIImageView *_headerImageView;
    
    UIView *_smallView;
    AVCaptureVideoPreviewLayer *_smallCaptureLayer;
    AVCaptureSession *_session;
    
    UIView *_actionView;
    UIButton *_silenceButton;
    UILabel *_silenceLabel;
    UIButton *_speakerOutButton;
    UILabel *_speakerOutLabel;
    
    UIButton *_rejectButton;
    UIButton *_answerButton;
    
    UIButton *_hangupButton;
    
    BOOL _isIncoming;
    int _timeLength;
    EMCallSession *_callSession;
}

@property (strong, nonatomic) NSString *chatter;
@property (strong, nonatomic) UILabel *statusLabel;

- (void)showWithSession:(EMCallSession *)session
             isIncoming:(BOOL)isIncoming;

@end
