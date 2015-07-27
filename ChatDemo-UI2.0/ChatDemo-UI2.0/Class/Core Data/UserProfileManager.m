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

#define kCURRENT_USERNAME [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername]

static UserProfileManager *sharedInstance = nil;
@interface UserProfileManager ()

@property (nonatomic, strong) NSMutableDictionary *users;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) PFACL *defaultACL;

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
        
        _defaultACL = [PFACL ACL];
        [_defaultACL setPublicReadAccess:YES];
        [_defaultACL setPublicWriteAccess:YES];
    }
    return self;
}

- (void)initParse
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id objectId = [ud objectForKey:[NSString stringWithFormat:@"%@%@",kPARSE_HXUSER,kCURRENT_USERNAME]];
    if (objectId) {
        self.objectId = objectId;
    }
    [self initData];
}

- (void)clearParse
{
    self.objectId = nil;
    [self.users removeAllObjects];
}

- (void)initData
{
    [self.users removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:kPARSE_HXUSER];
    [query fromPinWithName:kCURRENT_USERNAME];
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
    if (_objectId && _objectId.length > 0) {
        PFObject *object = [PFObject objectWithoutDataWithClassName:kPARSE_HXUSER objectId:_objectId];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        object[kPARSE_HXUSER_AVATAR] = imageFile;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (completion) {
                completion(succeeded,error);
            }
        }];
    } else {
        
        [self queryPFObjectWithCompletion:^(PFObject *object, NSError *error) {
            if (object) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
                PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                object[kPARSE_HXUSER_AVATAR] = imageFile;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (completion) {
                        completion(succeeded,error);
                    }
                }];
            } else {
                if (completion) {
                    completion(NO,error);
                }

            }
        }];
    }
}

- (void)updateUserProfileInBackground:(NSDictionary*)param
                           completion:(void (^)(BOOL success, NSError *error))completion
{
    if (_objectId && _objectId.length > 0) {
        PFObject *object = [PFObject objectWithoutDataWithClassName:kPARSE_HXUSER objectId:_objectId];
        if( param!=nil && [[param allKeys] count] > 0) {
            for (NSString *key in param) {
                [object setObject:[param objectForKey:key] forKey:key];
            }
        }
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (completion) {
                completion(succeeded,error);
            }
        }];
    } else {
        [self queryPFObjectWithCompletion:^(PFObject *object, NSError *error) {
            if (object) {
                if( param!=nil && [[param allKeys] count] > 0) {
                    for (NSString *key in param) {
                        [object setObject:[param objectForKey:key] forKey:key];
                    }
                }
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (completion) {
                        completion(succeeded,error);
                    }
                }];
            } else {
                if (completion) {
                    completion(NO,error);
                }
            }
        }];
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
    PFQuery *query = [PFQuery queryWithClassName:kPARSE_HXUSER];
    [query whereKey:kPARSE_HXUSER_USERNAME containedIn:usernames];
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

#pragma mark - private

- (void)savePFUserInDisk:(PFObject*)object
{
    [object pinInBackgroundWithName:kCURRENT_USERNAME];
    [self savePFUserInMemory:object];
}

- (void)savePFUserInMemory:(PFObject*)object
{
    UserProfileEntity *entity = [UserProfileEntity initWithPFObject:object];
    [_users setObject:entity forKey:entity.username];
}

- (void)queryPFObjectWithCompletion:(void (^)(PFObject *object, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:kPARSE_HXUSER];
    [query whereKey:kPARSE_HXUSER_USERNAME equalTo:kCURRENT_USERNAME];
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            if (objects && [objects count] > 0) {
                PFObject *object = [objects objectAtIndex:0];
                [object setACL:weakSelf.defaultACL];
                weakSelf.objectId = object.objectId;
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:object.objectId forKey:[NSString stringWithFormat:@"%@%@",kPARSE_HXUSER,kCURRENT_USERNAME]];
                [ud synchronize];
                if (completion) {
                    completion (object, error);
                }
            } else {
                PFObject *object = [PFObject objectWithClassName:kPARSE_HXUSER];
                object[kPARSE_HXUSER_USERNAME] = kCURRENT_USERNAME;
                completion (object, error);
            }
        } else {
            if (completion) {
                completion (nil, error);
            }
        }
    }];
}

@end

@implementation UserProfileEntity

+ (instancetype) initWithPFObject:(PFObject *)object
{
    UserProfileEntity *entity = [[UserProfileEntity alloc] init];
    entity.username = object[kPARSE_HXUSER_USERNAME];
    entity.nickname = object[kPARSE_HXUSER_NICKNAME];
    PFFile *userImageFile = object[kPARSE_HXUSER_AVATAR];
    if (userImageFile) {
        entity.imageUrl = userImageFile.url;
    }
    return entity;
}

@end
