//
//  CallViewController.m
//  ChatDemo-UI2.0
//
//  Created by dhc on 15/4/13.
//  Copyright (c) 2015年 dhc. All rights reserved.
//

#import "CallViewController.h"

#define kAlertViewTag_Close 100

@implementation CallViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[EMSDKFull sharedInstance].callManager addDelegate:self delegateQueue:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self _setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[EMSDKFull sharedInstance].callManager removeDelegate:self];
    
    [_ringPlayer stop];
    _ringPlayer = nil;
    
    [_timeTimer invalidate];
    _timeTimer = nil;
    
    [_session stopRunning];
    _session = nil;
}

#pragma makr - property 

- (void)setChatter:(NSString *)chatter
{
    _chatter = chatter;
    _nameLabel.text = _chatter;
}

- (UILabel *)statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 20)];
        _statusLabel.font = [UIFont systemFontOfSize:15.0];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _statusLabel;
}

#pragma mark - subviews

- (void)_setupSubviews
{
    if (_isSetupSubviews) {
        return;
    }
    
    _isSetupSubviews = YES;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageNamed:@"callBg.png"];
    [self.view addSubview:bgImageView];
    
    [self.view addSubview:self.statusLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_statusLabel.frame), self.view.frame.size.width, 15)];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) / 2, CGRectGetMaxY(_statusLabel.frame) + 20, 50, 50)];
    _headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
    [self.view addSubview:_headerImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerImageView.frame) + 5, self.view.frame.size.width, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = _chatter;
    [self.view addSubview:_nameLabel];
    
    _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];
    _actionView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.view addSubview:_actionView];
    
    CGFloat tmpWidth = _actionView.frame.size.width / 2;
    _silenceButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 40) / 2, 20, 40, 40)];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence"] forState:UIControlStateNormal];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence_h"] forState:UIControlStateSelected];
    [_silenceButton addTarget:self action:@selector(silenceAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_silenceButton];
    
    _silenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_silenceButton.frame), CGRectGetMaxY(_silenceButton.frame) + 5, 40, 20)];
    _silenceLabel.backgroundColor = [UIColor clearColor];
    _silenceLabel.textColor = [UIColor whiteColor];
    _silenceLabel.font = [UIFont systemFontOfSize:13.0];
    _silenceLabel.textAlignment = NSTextAlignmentCenter;
    _silenceLabel.text = @"静音";
    [_actionView addSubview:_silenceLabel];
    
    _speakerOutButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 40) / 2, _silenceButton.frame.origin.y, 40, 40)];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out"] forState:UIControlStateNormal];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out_h"] forState:UIControlStateSelected];
    [_speakerOutButton addTarget:self action:@selector(speakerOutAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_speakerOutButton];
    
    _speakerOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_speakerOutButton.frame), CGRectGetMaxY(_speakerOutButton.frame) + 5, 40, 20)];
    _speakerOutLabel.backgroundColor = [UIColor clearColor];
    _speakerOutLabel.textColor = [UIColor whiteColor];
    _speakerOutLabel.font = [UIFont systemFontOfSize:13.0];
    _speakerOutLabel.textAlignment = NSTextAlignmentCenter;
    _speakerOutLabel.text = @"免提";
    [_actionView addSubview:_speakerOutLabel];
    
    _rejectButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 100) / 2, CGRectGetMaxY(_speakerOutLabel.frame) + 30, 100, 40)];
    [_rejectButton setTitle:@"拒接" forState:UIControlStateNormal];
    [_rejectButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_rejectButton addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    
    _answerButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 100) / 2, _rejectButton.frame.origin.y, 100, 40)];
    [_answerButton setTitle:@"接听" forState:UIControlStateNormal];
    [_answerButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    
    _hangupButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, _rejectButton.frame.origin.y, 200, 40)];
    [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
    [_hangupButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_hangupButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initializeCamera
{
    if (_smallView == nil) {
        CGFloat width = 100;
        CGFloat height = 100;
        _smallView = [[UIView alloc] initWithFrame:CGRectMake(200, 50, width, height)];
        _smallView.backgroundColor = [UIColor redColor];
        
        //1.创建会话层
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPreset352x288];
        
        //2.创建、配置输入设备
        AVCaptureDevice *device;
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *tmp in devices)
        {
            if (tmp.position == AVCaptureDevicePositionFront)
            {
                device = tmp;
                break;
            }
        }
        
        AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [_session beginConfiguration];
        [_session addInput:captureInput];
        
        //3.创建、配置输出
        AVCaptureStillImageOutput *captureOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        [captureOutput setOutputSettings:outputSettings];
        [_session addOutput:captureOutput];
        [_session commitConfiguration];
        
        //4.小窗口显示层
        _smallCaptureLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _smallCaptureLayer.frame = CGRectMake(0, 0, width, height);
        _smallCaptureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_smallView.layer addSublayer:_smallCaptureLayer];
        
        //5.大窗口显示层
    }
}

#pragma mark - ring

- (void)_beginRing
{
    [_ringPlayer stop];

    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];

    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)_stopRing
{
    [_ringPlayer stop];
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
}

#pragma mark - private

- (void)_insertMessageWithStr:(NSString *)str
{
    EMChatText *chatText = [[EMChatText alloc] initWithText:str];
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:_callSession.sessionChatter bodies:@[textBody]];
    message.isRead = YES;
    message.deliveryState = eMessageDeliveryState_Delivered;
    [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"insertCallMessage" object:message];
}

- (void)_close
{
    [self hideHud];
    [_session stopRunning];
    [_timeTimer invalidate];
    _timeTimer = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callControllerClose" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTag_Close)
    {
        [[EMSDKFull sharedInstance].callManager asyncEndCall:_callSession.sessionId reason:eCallReason_Null];
        [self _close];
    }
}

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession
                    changeReason:(EMCallStatusChangedReason)reason
                           error:(EMError *)error
{
    if(![_callSession.sessionId isEqualToString:callSession.sessionId]){
        return;
    }
    
    [self hideHud];
    [self _stopRing];
    if(error){
        _statusLabel.text = @"连接失败";
        [self _insertMessageWithStr:@"通话失败"];
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:error.description delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        errorAlert.tag = kAlertViewTag_Close;
        [errorAlert show];
        
        return;
    }
    
    if (callSession.status == eCallSessionStatusDisconnected) {
        _statusLabel.text = @"通话已挂断";
        NSString *str = @"通话结束";
        if(_timeLength == 0)
        {
            if (reason == eCallReason_Hangup) {
                str = @"取消通话";
            }
            else if (reason == eCallReason_Reject){
                str = @"对方取消通话";
            }
            else if (reason == eCallReason_Busy){
                str = @"对方正在通话中";
            }
        }
        [self _insertMessageWithStr:str];
        [self _close];
    }
    else if (callSession.status == eCallSessionStatusAccepted)
    {
        _statusLabel.text = @"可以通话了...";
        _timeLength = 0;
        _timeTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];

        if(_isIncoming)
        {
            [_answerButton removeFromSuperview];
            [_rejectButton removeFromSuperview];
            [_actionView addSubview:_hangupButton];
        }
        [_actionView addSubview:_silenceButton];
        [_actionView addSubview:_silenceLabel];
        [_actionView addSubview:_speakerOutButton];
        [_actionView addSubview:_speakerOutLabel];
    }
}

#pragma mark - action

- (void)silenceAction
{
    _silenceButton.selected = !_silenceButton.selected;
}

- (void)speakerOutAction
{
    _speakerOutButton.selected = !_speakerOutButton.selected;
}

- (void)rejectAction
{
    [_timeTimer invalidate];
    [self _stopRing];
    [self showHint:@"拒接通话..."];
    
    [[EMSDKFull sharedInstance].callManager asyncEndCall:_callSession.sessionId reason:eCallReason_Reject];
    [self _close];
}

- (void)answerAction
{
    [self showHint:@"正在初始化通话..."];
    [self _stopRing];
    
    [[EMSDKFull sharedInstance].callManager asyncAnswerCall:_callSession.sessionId];
}

- (void)hangupAction
{
    [_timeTimer invalidate];
    [self _stopRing];
    [self showHint:@"正在结束通话..."];
    
    [[EMSDKFull sharedInstance].callManager asyncEndCall:_callSession.sessionId reason:eCallReason_Hangup];
    [self _close];
}

#pragma mark - public

- (void)showWithSession:(EMCallSession *)session
             isIncoming:(BOOL)isIncoming
{
    [self _setupSubviews];
    _callSession = session;
    _isIncoming = isIncoming;
    _timeLabel.text = @"";
    _timeLength = 0;
    self.chatter = session.sessionChatter;
    
    if (session.type == eCallSessionTypeAudio) {
        [_session stopRunning];
        [_smallView removeFromSuperview];
    }
    else if (session.type == eCallSessionTypeVideo){
        [self initializeCamera];
        [self.view addSubview:_smallView];
        [_session startRunning];
    }
    
    if (_isIncoming) {
        self.statusLabel.text = @"等待接听...";
        [_silenceButton removeFromSuperview];
        [_silenceLabel removeFromSuperview];
        [_speakerOutButton removeFromSuperview];
        [_speakerOutLabel removeFromSuperview];
        [_hangupButton removeFromSuperview];
        [_actionView addSubview:_answerButton];
        [_actionView addSubview:_rejectButton];
    }
    else{
        self.statusLabel.text = @"正在建立连接...";
        [_answerButton removeFromSuperview];
        [_rejectButton removeFromSuperview];
        [_silenceButton removeFromSuperview];
        [_silenceLabel removeFromSuperview];
        [_speakerOutButton removeFromSuperview];
        [_speakerOutLabel removeFromSuperview];
        [_actionView addSubview:_hangupButton];
    }
}

@end
