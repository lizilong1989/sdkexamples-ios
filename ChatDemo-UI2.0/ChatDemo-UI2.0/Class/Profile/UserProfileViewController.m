/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "UserProfileViewController.h"

#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "UIImageView+HeadImage.h"

@interface UserProfileViewController ()

@property (strong, nonatomic) UserProfileEntity *user;

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;

@end

@implementation UserProfileViewController

- (instancetype)initWithUsername:(NSString *)username
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _username = username;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"详细资料";
    
    [self setupBarButtonItem];
    [self setupHeaderView];
    [self setupFooterView];
    
    [self loadUserProfile];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)loadUserProfile
{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak typeof(self) weakself = self;
    [[UserProfileManager sharedInstance] loadUserProfileInBackground:@[_username] saveToLoacal:YES completion:^(BOOL success, NSError *error) {
        [weakself hideHud];
        if (success) {
            weakself.user = [[UserProfileManager sharedInstance] getUserProfileByUsername:weakself.username];
            [weakself.headImageView imageWithUsername:weakself.username placeholderImage:nil];
            if (weakself.user.nickname && weakself.user.nickname.length > 0) {
                weakself.nicknameLabel.text = weakself.user.nickname;
            }
            [weakself.tableView reloadData];
        }
    }];
}

- (void)setupHeaderView
{
    self.user = [[UserProfileManager sharedInstance] getUserProfileByUsername:_username];
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 150.f);
    self.tableView.tableHeaderView = headView;
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.frame = CGRectMake(25, 25, 75, 75);
    _headImageView.contentMode = UIViewContentModeScaleToFill;
    [_headImageView imageWithUsername:self.username placeholderImage:nil];
    [headView addSubview:_headImageView];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.frame = CGRectMake(120, 25, 120, 50);
    _nicknameLabel.text = self.user.nickname;
    if (_nicknameLabel.text.length == 0) {
        _nicknameLabel.text = self.username;
    }
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:_nicknameLabel];
}

- (void)setupFooterView
{
    /*
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (![self.username isEqualToString:loginUsername]) {
        UIView *footView = [[UIView alloc] init];
        footView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 200.f);
        self.tableView.tableFooterView = footView;
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(20, 0, CGRectGetWidth(self.tableView.frame)-40, 50.f);
        [sendBtn setBackgroundColor:RGBACOLOR(30, 167, 252, 1)];
        [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:sendBtn];
    } else {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    */
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send
{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:self.username isGroup:NO];
    if (self.user && self.user.nickname.length > 0) {
        chatVC.title = self.user.nickname;
    } else {
        chatVC.title = self.username;
    }
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
