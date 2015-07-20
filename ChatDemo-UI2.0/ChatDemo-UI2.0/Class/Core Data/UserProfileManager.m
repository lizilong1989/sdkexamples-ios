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

#import "UserProfileManager.h"
#import <Parse/Parse.h>

static UserProfileManager *sharedInstance = nil;
@interface UserProfileManager ()

@property (nonatomic, strong) NSMutableDictionary *users;

@end

@implementation UserProfileManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _users = [NSMutableDictionary dictionary];
        [self initData];
    }
    return self;
}

- (void)initData
{
    PFQuery *query = [PFUser query];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (objects && [objects count] > 0) {
            for (id user in objects) {
                if ([user isKindOfClass:[PFObject class]]) {
                    UserProfileEntity *entity = [UserProfileEntity initWithPFObject:user];
                    if (entity.username.length > 0) {
                        [self.users setObject:entity forKey:entity.username];
                    }
                }
            }
        }
        
    }];
}

- (void)uploadUserHeadImageProfileInBackground:(UIImage*)image
                           completion:(void (^)(BOOL success, NSError *error))completion
{
    PFUser *user = [PFUser currentUser];
    if (user) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        user[@"imageFile"] = imageFile;
        
        __weak typeof(self) weakSelf = self;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (completion) {
                PFUser *user = [PFUser currentUser];
                UserProfileEntity *entity = [UserProfileEntity initWithPFObject:user];
                [weakSelf.users setObject:entity forKey:entity.username];
                completion(succeeded,error);
            }
        }];
    } else {
        [self loginParseWithCompletion:completion];
    }
}

- (void)updateUserProfileInBackground:(NSDictionary*)param
                           completion:(void (^)(BOOL success, NSError *error))completion
{
    PFUser *user = [PFUser currentUser];
    if (user) {
        if( param!=nil && [[param allKeys] count] > 0) {
            for (NSString *key in param) {
                [user setObject:[param objectForKey:key] forKey:key];
            }
        }
        __weak typeof(self) weakSelf = self;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (completion) {
                PFUser *user = [PFUser currentUser];
                UserProfileEntity *entity = [UserProfileEntity initWithPFObject:user];
                [weakSelf.users setObject:entity forKey:entity.username];
                completion(succeeded,error);
            }
        }];
    } else {
        [self loginParseWithCompletion:completion];
    }
}

- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
                                saveToLoacal:(BOOL)save
                                  completion:(void (^)(BOOL success, NSError *error))completion
{
    NSMutableArray *usernames = [NSMutableArray array];
    for (EMBuddy *buddy in buddyList)
    {
        if ([buddy.username length])
        {
            [usernames addObject:buddy.username];
        }
    }
    [[UserProfileManager sharedInstance] loadUserProfileInBackground:usernames saveToLoacal:save completion:completion];
}

- (void)loadUserProfileInBackground:(NSArray*)usernames
                       saveToLoacal:(BOOL)save
                         completion:(void (^)(BOOL success, NSError *error))completion
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containedIn:usernames];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (id user in objects) {
                if ([user isKindOfClass:[PFObject class]]) {
                    PFObject *pfuser = (PFObject*)user;
                    if (save) {
                        [self savePFUserInDisk:pfuser];
                    } else {
                        [self savePFUserInMemory:pfuser];
                    }
                }
            }
            if (completion) {
                completion(YES, nil);
            }
        } else {
            if (completion) {
                completion(NO, error);
            }
        }
    }];
}

- (UserProfileEntity*)getUserProfileByUsername:(NSString*)username
{
    if ([_users objectForKey:username]) {
        return [_users objectForKey:username];
    }
    
    return nil;
}

- (UserProfileEntity*)getCurUserProfile
{
    PFUser *user = [PFUser currentUser];
    if (user && [_users objectForKey:user.username]) {
        return [_users objectForKey:user.username];
    }
    
    return nil;
}

- (void)savePFUserInDisk:(PFObject*)object
{
    [object pinInBackground];
    [self savePFUserInMemory:object];
}

- (void)savePFUserInMemory:(PFObject*)object
{
    UserProfileEntity *entity = [UserProfileEntity initWithPFObject:object];
    [_users setObject:entity forKey:entity.username];
}

- (void)loginParseWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    PFUser *user = [PFUser user];
    user.username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    user.password = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKPassword];
    [PFUser logOut];
    [PFUser logInWithUsernameInBackground:user.username password:user.password
                                    block:^(PFUser *user, NSError *error) {
                                        if (error && error.code == 101) {
                                        }
                                        if (completion) {
                                            completion(NO, nil);
                                        }
                                    }];
}

@end

@implementation UserProfileEntity

+ (instancetype) initWithPFObject:(PFObject *)object
{
    UserProfileEntity *entity = [[UserProfileEntity alloc] init];
    entity.username = object[@"username"];
    entity.nickname = object[@"nickname"];
    PFFile *userImageFile = object[@"imageFile"];
    if (userImageFile) {
        entity.imageUrl = userImageFile.url;
    }
    return entity;
}

@end
