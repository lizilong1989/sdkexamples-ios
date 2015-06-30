//
//  IModelCell.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IModelCell <NSObject>

@optional

@property (strong, nonatomic) id model;

+ (NSString *)cellIdentifier;

+ (NSString *)cellIdentifierWithModel:(id)model;

+ (CGFloat)cellHeightWithModel:(id)model;

@end
