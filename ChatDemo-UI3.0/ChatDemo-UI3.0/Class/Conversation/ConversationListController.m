//
//  ConversationListController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ConversationListController.h"

#import "EaseMob.h"
#import "ConversationModel.h"
#import "ChatViewController.h"
#import "UIViewController+HUD.h"

@interface ConversationListController ()

@end

@implementation ConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
    EMConversation *conversation = model.conversation;
    if (conversation) {
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversation:conversation];
        chatController.title = model.title;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        ConversationModel *model = [[ConversationModel alloc] initWithConversation:converstion];
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    
    [self hideHud];
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

@end
