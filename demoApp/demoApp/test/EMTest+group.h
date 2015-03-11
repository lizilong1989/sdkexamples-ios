//
//  EMTest+group.h
//  demoApp
//
//  Created by dujiepeng on 14-5-31.
//  Copyright (c) 2014年 EaseMob. All rights reserved.
//

#import "EMTestBase.h"

@interface EMTest (group)

/**
 *  申请加入群组
 *
 *  @param name 群组名称
 */
-(void)applyJoinGroupWithGroupName:(NSString *)name;

/**
 *  拒绝申请
 *
 *  @param username 申请人
 */
-(void)rejectJoinGroupForUsername:(NSString *)username;

/**
 *  同意申请
 *
 *  @param username 申请人
 */
-(void)agreeJoinGroupForUsername:(NSString *)username;

/**
 *  创建群组
 *
 *  @param username 群组名
 */
-(void)createGroupWithGroupName:(NSString *)username;

/**
 *  解散群组
 *
 *  @param groupName 群组名
 */
-(void)dissolveGroup:(NSString *)groupName;


/**
 *  离开群组
 *
 *  @param name 群组名
 */
-(void)leaveGroupWithGroupName:(NSString *)name;

/**
 *  邀请加入群组
 *
 *  @param name 被邀请人
 */
-(void)inviteContactByUsername:(NSString *)name;

/**
 *  拒绝邀请
 *
 *  @param groupName 群组名
 */
-(void)rejectInvite:(NSString *)groupName;


@end
