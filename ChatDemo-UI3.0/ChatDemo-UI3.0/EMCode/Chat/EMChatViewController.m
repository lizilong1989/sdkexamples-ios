//
//  EMChatViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMChatViewController.h"

#import "NSObject+EaseMob.h"

@interface EMChatViewController ()

@end

@implementation EMChatViewController

@synthesize conversationModel = _conversationModel;
@synthesize deleteConversationIfNull = _deleteConversationIfNull;
@synthesize pageCount = _pageCount;
@synthesize timeCellHeight = _timeCellHeight;

- (instancetype)initWithConversationModel:(id<IConversationModel>)conversationModel
{
    if (!conversationModel) {
        return nil;
    }
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _conversationModel = conversationModel;
        [_conversationModel.conversation markAllMessagesAsRead:YES];
        
        _pageCount = 50;
        _timeCellHeight = 30;
        _deleteConversationIfNull = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.conversationModel.title;
    
    [self registerEaseMobNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self unregisterEaseMobNotification];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EMMessageTimeCell cellIdentifier];
        EMMessageTimeCell *timeCell = (EMMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EMMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return timeCell;
    }
    else{
        id<IMessageModel> model = object;
        NSString *CellIdentifier = [EMMessageCell cellIdentifierWithModel:model];
        EMMessageCell *cell = (EMMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[EMMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.model = model;
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        return self.timeCellHeight;
    }
    else{
        id<IMessageModel> model = object;
        return [EMMessageCell cellHeightWithModel:model];
    }
}

@end
