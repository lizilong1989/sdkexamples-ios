//
//  EMTest+group.m
//  demoApp
//
//  Created by dujiepeng on 14-5-31.
//  Copyright (c) 2014年 EaseMob. All rights reserved.
//

#import "EMTest+group.h"
#import "IChatManager.h"
#import "EMGroup.h"

static EMGroup *g_group = nil;

@implementation EMTest (group)

/**
 *  申请加入群组
 *
 *  @param name 群组名称
 */
-(void)applyJoinGroupWithGroupName:(NSString *)name{
    //[chatMan fetchMyJoinedChatrooms];
    
}

/**
 *  拒绝申请
 *
 *  @param username 申请人
 */
-(void)rejectJoinGroupForUsername:(NSString *)username{
    NSLog(@"rejectJoinGroupForUsername");
}

/**
 *  同意申请
 *
 *  @param username 申请人
 */
-(void)agreeJoinGroupForUsername:(NSString *)username{
    NSLog(@"agreeJoinGroupForUsername");
}

/**
 *  创建群组
 *
 *  @param username 群组名
 */
-(void)createGroupWithGroupName:(NSString *)username{
    /*
    NSLog(@"createGroupWithGroupName");
    EMGroup *group = nil;
    EMError *error = nil;
    group = [chatMan createPrivateGroupWithSubject:@"testsubject"
                                  description:@"testdesc"
                                     invitees:[NSArray arrayWithObject:@"20001"]
                        initialWelcomeMessage:nil
                                        error:&error];
    g_group = group;
     */
}

/**
 *  解散群组
 *
 *  @param groupName 群组名
 */
-(void)dissolveGroup:(NSString *)groupName{
    NSLog(@"dissolveGroup");
}


/**
 *  离开群组
 *
 *  @param name 群组名
 */
-(void)leaveGroupWithGroupName:(NSString *)name{
    NSLog(@"leaveGroupWithGroupName");
    EMError *error = nil;
    [chatMan leaveGroup:g_group.groupId error:&error];
}

/**
 *  邀请加入群组
 *
 *  @param name 被邀请人
 */
-(void)inviteContactByUsername:(NSString *)name{
    NSLog(@"inviteContactByUsername");
    [chatMan addOccupants:[NSArray arrayWithObject:@"20001"] toGroup:g_group.groupId welcomeMessage:@"hi from test" error:nil];
}

/**
 *  拒绝邀请
 *
 *  @param groupName 群组名
 */
-(void)rejectInvite:(NSString *)groupName{
    NSLog(@"rejectInvite");
}
@end
