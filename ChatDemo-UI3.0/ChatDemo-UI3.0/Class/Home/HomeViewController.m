//
//  HomeViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "HomeViewController.h"

#import "ConversationListController.h"
#import "ContactListViewController.h"
#import "SettingViewController.h"

@interface HomeViewController ()<IChatManagerDelegate, EMCallManagerDelegate>

@property (strong, nonatomic) ConversationListController *conversationController;
@property (strong, nonatomic) ContactListViewController *contactController;
@property (strong, nonatomic) SettingViewController *settingController;

@property (nonatomic) NSInteger selectedControllerIndex;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
#warning 把self注册为SDK的delegate
    [self _registerEasemobDelegate];
    
    self.selectedControllerIndex = 0;
    [self _setupChildController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _settingController = nil;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self  _unregisterEasemobDelegate];
}

#pragma mark - private

- (void)_registerEasemobDelegate
{
    [self _unregisterEasemobDelegate];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)_unregisterEasemobDelegate
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

#pragma mark - private layout subviews

-(void)_unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
}

-(void)_selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],
                                        UITextAttributeFont, [UIColor colorWithRed:0 green:172 / 255.0 blue:255 / 255.0 alpha:1.0], UITextAttributeTextColor,
                                        nil] forState:UIControlStateSelected];
}

- (void)_setupChildController
{
    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbarBackground"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    
    //conversation controller
    self.conversationController = [[ConversationListController alloc] init];
    self.conversationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.conversation", @"Conversations")
                                                           image:nil
                                                             tag:0];
    [self.conversationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_chatsHL"]
                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_chats"]];
    [self _unSelectedTapTabBarItems:self.conversationController.tabBarItem];
    [self _selectedTapTabBarItems:self.conversationController.tabBarItem];
    
    //contact controller
    self.contactController = [[ContactListViewController alloc] init];
    self.contactController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.addressbook", @"AddressBook") image:nil tag:1];
    [self.contactController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_contactsHL"]
                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_contacts"]];
    [self _unSelectedTapTabBarItems:self.contactController.tabBarItem];
    [self _selectedTapTabBarItems:self.contactController.tabBarItem];
    
    //setting controller
    self.settingController = [[SettingViewController alloc] init];
    self.settingController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"title.setting", @"Setting") image:nil tag:2];
    [self.settingController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_settingHL"]
                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_setting"]];
    self.settingController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self _unSelectedTapTabBarItems:self.settingController.tabBarItem];
    [self _selectedTapTabBarItems:self.settingController.tabBarItem];
    
    self.viewControllers = @[self.conversationController, self.contactController, self.settingController];
    
    [self tabBar:self.tabBar didSelectItem:self.conversationController.tabBarItem];
//    [self _selectedTapTabBarItems:self.conversationController.tabBarItem];
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0)
    {
        self.title = NSLocalizedString(@"title.conversation", @"Conversations");
        self.navigationItem.rightBarButtonItems = nil;
    }
    else if (item.tag == 1){
        self.title = NSLocalizedString(@"title.addressbook", @"AddressBook");
        self.navigationItem.rightBarButtonItems = self.contactController.rightItems;
    }
    else if (item.tag == 2){
        self.title = NSLocalizedString(@"title.setting", @"Setting");
        self.navigationItem.rightBarButtonItems = nil;
        
        [self.settingController refreshSetting];
    }
}

#pragma mark - public

- (void)networkChanged:(EMConnectionState)connectionState
{
    
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

@end
