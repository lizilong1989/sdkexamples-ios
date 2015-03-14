//
//  ViewController.m
//  demoApp
//
//  Created by Ji Fang on 3/15/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import "ViewController.h"
#import "test/EMTest.h"
#import "IDeviceManager.h"
#import "IEMMessageBody.h"
#import "ViewController+PressBg.h"
#import "EMTest+group.h"

@interface ViewController () <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, IDeviceManagerDelegate,IChatManagerDelegate> {
    EMTest *_emtest;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

- (IBAction)sndTxtPressed:(id)sender;
- (IBAction)sndImgPressed:(id)sender;
- (IBAction)sndLocationPressed:(id)sender;

- (IBAction)doRegisterBtnPressed:(id)sender;
- (IBAction)getAllUserBtnPressed:(id)sender;

- (IBAction)startRecord:(id)sender;
- (IBAction)stopRecord:(id)sender;
- (IBAction)cancelRecord:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)stopPlay:(id)sender;
- (IBAction)playReceiveAudio:(id)sender;
- (IBAction)stopReceiveAudio:(id)sender;

- (IBAction)callAction:(id)sender;
- (IBAction)acceptAction:(id)sender;
- (IBAction)rejectAction:(id)sender;
- (IBAction)hangupAction:(id)sender;
- (IBAction)muteAudioAction:(id)sender;
- (IBAction)unmuteAudioAction:(id)sender;
- (IBAction)muteVideoAction:(id)sender;
- (IBAction)unmuteVideoAction:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *groupTextField;

@property (weak, nonatomic) IBOutlet UITextField *sndTxtField;
@property (weak, nonatomic) IBOutlet UITextView *consoleField;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self=[super initWithCoder:aDecoder]) {
        _emtest = [[EMTest alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[EaseMob sharedInstance] deviceManager];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
         [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    [self addTapBgEvent];
    self.scrollV.contentSize = CGSizeMake(0, 1000);
//    _consoleField.userInteractionEnabled = NO;
//    _consoleField.font = [UIFont systemFontOfSize:14];
//    _consoleField.backgroundColor = [UIColor blackColor];
//    _consoleField.textColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.8];

    [self.progress setProgress:0];
    self.consoleField.text = @"";
    _consoleField.layer.borderColor = [UIColor blackColor].CGColor;
    _consoleField.layer.borderWidth = 0.5;
    _consoleField.clipsToBounds = YES;
    
    self.sndTxtField.text = @"";

    
    [[EaseMob sharedInstance].deviceManager addDelegate:self
                                                onQueue:nil];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self
                                        delegateQueue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sndTxtPressed:(id)sender {
    NSLog(@"发送文字按中");
    [_emtest testChat:_sndTxtField.text];
    _sndTxtField.text = @"";
}

- (IBAction)logoffAction:(id)sender{
    id <IChatManager>chatMan = [[EaseMob sharedInstance] chatManager];
    [chatMan asyncLogoff];
}

- (IBAction)sndImgPressed:(id)sender {
    NSLog(@"发送图片按中");
    UIButton *button = (UIButton *)sender;
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
	if(button.tag == 100) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else if(button.tag == 102) {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
    
	[self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)sndLocationPressed:(id)sender{
    [_emtest testSendLocation];
}


- (IBAction)doRegisterBtnPressed:(id)sender {
    NSLog(@"注册用户按中");
    BOOL isRegister = [_emtest registerNewAccount];
    if(isRegister) {
        NSLog(@"注册成功");
    }else {
        NSLog(@"注册失败");
    }
}

- (IBAction)doLogin:(id)sender{
    NSLog(@"用户登陆按中");
    NSDictionary *loginInfo = [_emtest login];
    if (loginInfo) {
        NSLog(@"登陆成功");
    }else{
        NSLog(@"登陆失败");
    }
}

- (IBAction)getAllUserBtnPressed:(id)sender {
    NSLog(@"发送图片按中");
    //    NSArray *users = [_emtest allUser];
    //    NSLog(@"user count:%d", users.count);
}

- (IBAction)startRecord:(id)sender {
    NSLog(@"陆音开始按中");
    [_emtest startRecord];
}

- (IBAction)stopRecord:(id)sender {
    NSLog(@"陆音结束按中");
    [_emtest stopRecord];
}

- (IBAction)cancelRecord:(id)sender {
    NSLog(@"陆音取消按中");
    [_emtest cancelRecord];
}

- (IBAction)play:(id)sender {
    NSLog(@"开始播放按中");
    [_emtest stopPlayAudio];
}

- (IBAction)stopPlay:(id)sender {
    NSLog(@"停止播放按中");
    [_emtest stopPlayAudio];
}

#pragma mark - test
- (IBAction)takeImagePressed:(id)sender {
    
}

- (IBAction)locationAction:(UIButton *)sender{
    NSLog(@"开始定位按中");
    if ([sender.titleLabel.text isEqualToString:@"定位"]) {
        [[EaseMob sharedInstance].deviceManager startUpdatingLocation];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    }else{
        [[EaseMob sharedInstance].deviceManager stopUpdatingLocation];
        [sender setTitle:@"定位" forState:UIControlStateNormal];
    }
    
    [[EaseMob sharedInstance].deviceManager asyncDecodeAddressFromLatitude:39.983577
                                                              andLongitude:116.307146
                                                                completion:^(NSString *address,
                                                                             EMError *error) {
                                                                    NSLog(@"%@", address);
                                                                } onQueue:nil];
}

- (IBAction)locationStop:(id)sender{
    NSLog(@"停止定位按中");
}

- (IBAction)addBuddy:(id)sender{
    NSLog(@"添加好友按中");
}

- (void)didStopLocation{
    
}

- (void)didUpdateLocation:(CLLocation *)updatedLocation{
    NSLog(@"GPS定位坐标:%@", updatedLocation);
    CLLocationCoordinate2D location = [[EaseMob sharedInstance].deviceManager wgs84ToGcj02:updatedLocation.coordinate];
    NSLog(@"转换后的火星坐标:%f,%f", location.latitude, location.longitude);
}

- (void)didFailToLocateUserWithError:(EMError *)error{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSArray *keys = info.allKeys;
    NSLog(@"%@", keys);
    [_emtest testSendImage:image];
}

- (void)didReceiveMessage:(EMMessage *)message{
    EMMessage *msg = nil;
    msg = message;
    id<IEMMessageBody> body = msg.messageBodies.lastObject;
    if (body.messageBodyType == eMessageBodyType_Text) {
        if (!_consoleField.text || _consoleField.text.length == 0) {
            _consoleField.text = ((EMTextMessageBody *)body).text;
        }else{
            _consoleField.text = [NSString stringWithFormat:@"%@\n%@",_consoleField.text,((EMTextMessageBody *)body).text];
        }
    }else if(body.messageBodyType == eMessageBodyType_Location){
       NSString *address = ((EMLocationMessageBody *)body).address;
        double latitude = ((EMLocationMessageBody *)body).latitude;
        double longitude = ((EMLocationMessageBody *)body).longitude;
        NSLog(@"address--%@ \n latitude -- %f \n longotude -- %f \n",address,latitude,longitude);
    }else if (body.messageBodyType == eMessageBodyType_Image){
        NSLog(@"path -- %@",((EMImageMessageBody *)body).remotePath);
    }else if (body.messageBodyType == eMessageBodyType_Voice){
        [_emtest setupReceiveVoice:body];
    }
}

- (IBAction)playReceiveAudio:(id)sender{
    [_emtest playReceiverVoice];
}

- (IBAction)stopReceiveAudio:(id)sender{
    [_emtest stopPlayAudio];
}


 //------------------group---------------------//

- (IBAction)applyJoin:(id)sender {
    [_emtest applyJoinGroupWithGroupName:_groupTextField.text];
}

- (IBAction)rejectJoin:(id)sender {
    [_emtest rejectJoinGroupForUsername:@"username"];
}

- (IBAction)agreeJoin:(id)sender {
    [_emtest agreeJoinGroupForUsername:@"username"];
}

- (IBAction)createGroup:(id)sender {
    [_emtest createGroupWithGroupName:_groupTextField.text];
}

- (IBAction)dissolveGroup:(id)sender {
    [_emtest dissolveGroup:_groupTextField.text];
}

- (IBAction)leaveGroup:(id)sender {
    [_emtest leaveGroupWithGroupName:_groupTextField.text];
}

- (IBAction)inviteJoin:(id)sender {
    [_emtest inviteContactByUsername:@"username"];
}

- (IBAction)rejectInvite:(id)sender {
    [_emtest rejectInvite:_groupTextField.text];
}

- (IBAction)callAction:(id)sender{
#if TARGET_IPHONE_SIMULATOR
    [[EaseMob sharedInstance].chatManager test];
#endif
}
- (IBAction)acceptAction:(id)sender{
}
- (IBAction)rejectAction:(id)sender{
}
- (IBAction)hangupAction:(id)sender{
}
- (IBAction)muteAudioAction:(id)sender{
}
- (IBAction)unmuteAudioAction:(id)sender{
}
- (IBAction)muteVideoAction:(id)sender{
}
- (IBAction)unmuteVideoAction:(id)sender{
}
@end
