//
//  EMSendMessageCell.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/30.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMSendMessageCell.h"

@interface EMSendMessageCell()

@end

@implementation EMSendMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configureLayoutConstraints];
    }
    
    return self;
}

- (void)configureLayoutConstraints
{
    //bubble view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EMMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EMMessageCellPadding]];
    
    //status button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EMMessageCellPadding]];
}

#pragma mark - setter

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
}

#pragma mark - public

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    CGFloat minHeight = EMMessageCellPadding * 2;
    CGFloat height = [EMMessageCell cellHeightWithModel:model];
    height = height > minHeight ? height : minHeight;
    
    return height;
}

@end
