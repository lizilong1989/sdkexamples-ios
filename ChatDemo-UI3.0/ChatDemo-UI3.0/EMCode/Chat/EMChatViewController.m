//
//  EMChatViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "EMChatViewController.h"

#import "EMChatToolbar.h"
#import "EMLocationViewController.h"
#import "NSObject+EaseMob.h"

@interface EMChatViewController ()

@property (nonatomic) id<IMessageModel> playingVoiceModel;

@property (strong, nonatomic) EMChatToolbar *chatToolbar;

@end

@implementation EMChatViewController

@synthesize conversation = _conversation;
@synthesize deleteConversationIfNull = _deleteConversationIfNull;
@synthesize pageCount = _pageCount;
@synthesize timeCellHeight = _timeCellHeight;

- (instancetype)initWithConversation:(EMConversation *)conversation
{
    if (!conversation) {
        return nil;
    }
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _conversation = conversation;
        [_conversation markAllMessagesAsRead:YES];
        
        _pageCount = 50;
        _timeCellHeight = 30;
        _deleteConversationIfNull = YES;
        _scrollToBottomWhenAppear = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat chatbarHeight = [EMChatToolbar defaultHeight];
    self.chatToolbar = [[EMChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight)];
    [self.view addSubview:self.chatToolbar];
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.view.frame.size.height - chatbarHeight;
    self.tableView.frame = tableFrame;
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isViewDidAppear = YES;
    
    if (self.scrollToBottomWhenAppear) {
        [self _scrollViewToBottom:NO];
    }
    self.scrollToBottomWhenAppear = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.isViewDidAppear = NO;
}

#pragma mark - private

- (void)_scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
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
    
    //时间cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EMMessageTimeCell cellIdentifier];
        EMMessageTimeCell *timeCell = (EMMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EMMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    }
    else{
        id<IMessageModel> model = object;
        NSString *CellIdentifier = [EMMessageCell cellIdentifierWithModel:model];
        
        //发送cell
        if (model.isSender) {
            EMSendMessageCell *sendCell = (EMSendMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (sendCell == nil) {
                sendCell = [[EMSendMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
                sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                sendCell.delegate = self;
            }
            
            sendCell.model = model;
            return sendCell;
        }
        else{//接收cell
            EMRecvMessageCell *recvCell = (EMRecvMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (recvCell == nil) {
                recvCell = [[EMRecvMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
                recvCell.selectionStyle = UITableViewCellSelectionStyleNone;
                recvCell.delegate = self;
            }
            
            recvCell.model = model;
            return recvCell;
        }
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
        if (model.isSender) {
            return [EMSendMessageCell cellHeightWithModel:model];
        }
        else{
            return [EMRecvMessageCell cellHeightWithModel:model];
        }
    }
}

#pragma mark - EMMessageCellDelegate

- (void)imageMessageCellSelcted:(id<IMessageModel>)model
{
    
}

- (void)locationMessageCellSelcted:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
    EMLocationViewController *locationController = [[EMLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)voiceMessageCellSelcted:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
    if (model.isMediaPlaying) {
        self.playingVoiceModel = model;
    }
}

- (void)videoMessageCellSelcted:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
//    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
//    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
//    [moviePlayerController.moviePlayer prepareToPlay];
//    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

- (void)fileMessageCellSelcted:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
}

@end
