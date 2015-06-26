//
//  EMMessageCell.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMMessageCell.h"

@implementation EMMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    
    return self;
}


+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    return @"";
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return 0;
}

@end
