//
//  CallViewController.m
//  ChatDemo-UI2.0
//
//  Created by dhc on 15/3/24.
//  Copyright (c) 2015年 dhc. All rights reserved.
//

#import "CallViewController.h"

static CallViewController *shareCallController = nil;

@interface CallViewController ()
{
    UILabel *_statusLabel;//显示call的状态
    UILabel *_chatterLabel;//显示通话者username
    UILabel *_timeLabel;//显示通话时间
    
    UIButton *_rejectButton;//拒接按钮
    UIButton *_answerButton;//接听按钮
    UIButton *_hangupButton;//挂断按钮
    
    UIButton *_silenceButton;//静音按钮
    UILabel *_silenceLabel;
    UIButton *_speakerOutButton;//外放按钮
    UILabel *_speakerOutLabel;
}

@property (nonatomic) int callTime;

@property (strong, nonatomic) EMCallSession *callSession; //通话实例

@property (strong, nonatomic) UIView *audioCallView;

@property (strong, nonatomic) UIView *videoCallView;

@end

@implementation CallViewController

@synthesize callTime = _callTime;

@synthesize callSession = _callSession;

@synthesize audioCallView = _audioCallView;

@synthesize videoCallView = _videoCallView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _callTime = 0;
        
        [[EMSDKFull sharedInstance].callManager addDelegate:self delegateQueue:nil];
    }
    
    return self;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCallController = [[CallViewController alloc] init];
    });
    
    return shareCallController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[EMSDKFull sharedInstance].callManager removeDelegate:self];
    
//    [_timer invalidate];
//    _timer = nil;
}

#pragma mark - private subviews

- (void)setupSubviews
{
    if(_statusLabel){
        return;
    }
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageNamed:@"callBg.png"];
    [self.view addSubview:bgImageView];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 50)];
    _statusLabel.font = [UIFont systemFontOfSize:15.0];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_statusLabel];
    
    _chatterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_statusLabel.frame), self.view.frame.size.width, 20)];
    _chatterLabel.font = [UIFont systemFontOfSize:14.0];
    _chatterLabel.backgroundColor = [UIColor clearColor];
    _chatterLabel.textColor = [UIColor whiteColor];
    _chatterLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_chatterLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_chatterLabel.frame) + 10, self.view.frame.size.width, 15)];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    
    _audioCallView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLabel.frame) + 10, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_timeLabel.frame) - 20)];
    
    CGFloat tmpWidth = _audioCallView.frame.size.width / 2;
    _silenceButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 40) / 2, _audioCallView.frame.size.height - 230, 40, 40)];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence"] forState:UIControlStateNormal];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence_h"] forState:UIControlStateSelected];
    [_silenceButton addTarget:self action:@selector(silenceAction:) forControlEvents:UIControlEventTouchUpInside];
    [_audioCallView addSubview:_silenceButton];
    
    _silenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_silenceButton.frame), CGRectGetMaxY(_silenceButton.frame) + 5, 40, 20)];
    _silenceLabel.backgroundColor = [UIColor clearColor];
    _silenceLabel.textColor = [UIColor whiteColor];
    _silenceLabel.font = [UIFont systemFontOfSize:13.0];
    _silenceLabel.textAlignment = NSTextAlignmentCenter;
    _silenceLabel.text = @"静音";
    [_audioCallView addSubview:_silenceLabel];
    
    _speakerOutButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 40) / 2, —_audioCallView.frame.size.height - 230, 40, 40)];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out"] forState:UIControlStateNormal];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out_h"] forState:UIControlStateSelected];
    [_speakerOutButton addTarget:self action:@selector(speakerOutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_audioCallView addSubview:_speakerOutButton];
    
    _speakerOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_speakerOutButton.frame), CGRectGetMaxY(_speakerOutButton.frame) + 5, 40, 20)];
    _speakerOutLabel.backgroundColor = [UIColor clearColor];
    _speakerOutLabel.textColor = [UIColor whiteColor];
    _speakerOutLabel.font = [UIFont systemFontOfSize:13.0];
    _speakerOutLabel.textAlignment = NSTextAlignmentCenter;
    _speakerOutLabel.text = @"免提";
    [_audioCallView addSubview:_speakerOutLabel];
    
    _rejectButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 100) / 2, _audioCallView.frame.size.height - 120, 100, 40)];
    _rejectButton.tag = 0;
    [_rejectButton setTitle:@"拒接" forState:UIControlStateNormal];
    [_rejectButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_rejectButton addTarget:self action:@selector(hangupAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _answerButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 100) / 2, _audioCallView.frame.size.height - 120, 100, 40)];
    [_answerButton setTitle:@"接听" forState:UIControlStateNormal];
    [_answerButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_answerButton addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _hangupButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, _audioCallView.frame.size.height - 120, 200, 40)];
    _hangupButton.tag = 1;
    [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
    [_hangupButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_hangupButton addTarget:self action:@selector(hangupAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshSubviewsWithChatter:(NSString *)chatter
                         ifCallOut:(BOOL)isCallOut
                              type:(EMCallSessionType)callType
{
    [self setupSubviews];
    
    _chatterLabel.text = _chatter;
    _timeLabel.text = @"";
    _callLength = 0;
    
    if(callType == eCallSessionTypeVideo)
    {
        [_videoCallView removeFromSuperview];
    }
    else if (callType == eCallSessionTypeVideo){
        
    }
    
    if (!isCallOut) {
        _statusLabel.text = @"等待接听...";
       
        CGFloat tmpWidth = self.view.frame.size.width / 2;
        _hangupButton.frame = CGRectMake((tmpWidth - 100) / 2, self.view.frame.size.height - 120, 100, 40);
        [self.view addSubview:_answerButton];
        _silenceButton.hidden = YES;
        _silenceLabel.hidden = YES;
        _speakerOutButton.hidden = YES;
        _outLabel.hidden = YES;
    }
    else if (_callType == CallOut)
    {
        _statusLabel.text = @"正在建立连接...";
        
        [_answerButton removeFromSuperview];
        _hangupButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2, self.view.frame.size.height - 120, 200, 40);
        _silenceButton.hidden = NO;
        _silenceLabel.hidden = NO;
        _speakerOutButton.hidden = NO;
        _outLabel.hidden = NO;
    }

}

#pragma mark - private action



#pragma mark - public

//向外拨打实时通话
- (EMError *)makeCallWithChatter:(NSString *)chatter
                            type:(EMCallSessionType)callType
{
    EMError *error = nil;
    if(_callSession)
    {
        error = [EMError errorWithCode:EMErrorServerTooManyOperations andDescription:@"正在进行通话，请稍后再试"];
    }
    
    [self refreshSubviewsWithChatter:chatter ifCallOut:YES type:callType];
    
    return error;
}

//接收到实时通话
- (EMError *)receiveCall:(EMCallSession *)callSession
{
    EMError *error = nil;
    if(_callSession)
    {
        error = [EMError errorWithCode:EMErrorServerTooManyOperations andDescription:@"正在进行通话，请稍后再试"];
    }

    [self refreshSubviewsWithChatter:callSession.sessionChatter ifCallOut:NO type:callSession.type];
    
    return error;
}

@end
