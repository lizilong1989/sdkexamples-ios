//
//  ChatViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ChatViewController.h"

#import "EaseMob.h"
#import "MessageModel.h"
#import "UIViewController+HUD.h"
#import "NSDate+Category.h"

@interface ChatViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *messsagesSource;

@property (nonatomic) NSTimeInterval timeIntervalTag;

@end

@implementation ChatViewController

@synthesize timeIntervalTag = _timeIntervalTag;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    
    //通过会话管理者获取已收发消息
    long long timestamp = self.conversationModel.conversation.latestMessage.timestamp + 1;
    [self loadMessagesFrom:timestamp count:self.pageCount append:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup subviews

- (void)_setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //单聊
    if (self.conversationModel.conversation.conversationType == eConversationTypeChat) {
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
    else{//群聊
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.timeIntervalTag = -1;
        [self.conversationModel.conversation removeAllMessages];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - EMCallManagerCallDelegate

#pragma mark - action

- (void)backAction
{
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversationModel.conversation latestMessage];
        if (message == nil) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.conversationModel.conversation.chatter deleteMessages:NO append2Chat:YES];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    if (self.conversationModel.conversation.conversationType == eConversationTypeGroupChat) {
        //        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:_chatter];
        //        [self.navigationController pushViewController:detailController animated:YES];
    }
    else if (self.conversationModel.conversation.conversationType == eConversationTypeChatRoom)
    {
        //        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:_chatter];
        //        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversationModel.conversation.chatter];
        if (self.conversationModel.conversation.conversationType != eConversationTypeChat && isDelete) {
            self.timeIntervalTag = -1;
            [self.conversationModel.conversation removeAllMessages];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}

#pragma mark - data

- (void)_downloadMessageAttachments:(EMMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            //            [weakSelf reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    if ([messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Video)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.attachmentDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载语言
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        }
    }
}

- (NSArray *)_formatMessages:(NSArray *)messages
{
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }
    
    for (EMMessage *message in messages) {
        //计算時間间隔
        CGFloat interval = self.timeIntervalTag - message.timestamp;
        if (self.timeIntervalTag < 0 || interval > 60 || interval < -60) {
            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            [formattedArray addObject:[messageDate formattedTime]];
            self.timeIntervalTag = message.timestamp;
        }
        
        //构建数据模型
        MessageModel *model = [[MessageModel alloc] initWithMessage:message];
        if (model) {
            [formattedArray addObject:model];
        }
    }
    
    return formattedArray;
}

- (void)loadMessagesFrom:(long long)timestamp
                   count:(NSInteger)count
                  append:(BOOL)append
{
    NSArray *moreMessages = [self.conversationModel.conversation loadNumbersOfMessages:count before:timestamp];
    [self.messsagesSource insertObjects:moreMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [moreMessages count])]];
}

@end
