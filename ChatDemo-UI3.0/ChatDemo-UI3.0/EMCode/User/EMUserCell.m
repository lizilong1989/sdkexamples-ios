//
//  EMUserCell.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMUserCell.h"

#import "EMImageView.h"
#import "EMBuddy.h"

CGFloat const EMUserCellPadding = 10;

@interface EMUserCell()

@end

@implementation EMUserCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EMUserCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor blackColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:18];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    cellWidth:(CGFloat)cellWidth
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellWidth = cellWidth;
        [self _setupSubviewWithWidth:cellWidth];
    }
    
    return self;
}

#pragma mark - private layout subviews

- (void)_setupSubviewWithWidth:(CGFloat)cellWidth
{
    CGFloat height = [EMUserCell cellHeightWithModel:nil];
    _avatarView = [[EMImageView alloc] initWithFrame:CGRectMake(EMUserCellPadding, EMUserCellPadding, height - EMUserCellPadding * 2, height - EMUserCellPadding * 2)];
    [self.contentView addSubview:_avatarView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarView.frame) + EMUserCellPadding, EMUserCellPadding, cellWidth - EMUserCellPadding * 2 - CGRectGetMaxX(_avatarView.frame), height - EMUserCellPadding * 2)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = _titleLabelFont;
    _titleLabel.textColor = _titleLabelColor;
    [self.contentView addSubview:_titleLabel];
}

#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.avatarView.hidden = !showAvatar;
        CGRect titleFrame = self.titleLabel.frame;
        if (_showAvatar) {
            titleFrame.origin.x = CGRectGetMaxX(self.avatarView.frame) + EMUserCellPadding;
            titleFrame.size.width = _cellWidth - CGRectGetMaxX(self.avatarView.frame) - EMUserCellPadding * 2;
        }
        else{
            titleFrame.origin.x = EMUserCellPadding;
            titleFrame.size.width = _cellWidth - EMUserCellPadding * 2;
        }
        
        self.titleLabel.frame = titleFrame;
    }
}

- (void)setModel:(id<IUserModel>)model
{
    _model = model;
    
    if ([_model.nickname length] > 0) {
        self.titleLabel.text = _model.nickname;
    }
    else{
       self.titleLabel.text = _model.buddy.username;
    }
    
    if (_model.avatarImage) {
        self.avatarView.image = _model.avatarImage;
    }
    else if ([_model.avatarURLPath length] > 0){
        
    }
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}

#pragma mark - class method

+ (NSString *)cellIdentifier
{
    return @"EMUserCell";
}

+ (CGFloat)cellHeightWithModel:(id)model
{
    return EMUserCellMinHeight;
}

@end
