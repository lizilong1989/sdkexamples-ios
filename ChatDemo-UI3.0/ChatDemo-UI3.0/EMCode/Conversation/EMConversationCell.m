//
//  EMConversationCell.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMConversationCell.h"

#import "EMConversation.h"

CGFloat const EMConversationCellPadding = 10;

@interface EMConversationCell()

@end

@implementation EMConversationCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EMConversationCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor blackColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:17];
    cell.detailLabelColor = [UIColor lightGrayColor];
    cell.detailLabelFont = [UIFont systemFontOfSize:15];
    cell.timeLabelColor = [UIColor blackColor];
    cell.timeLabelFont = [UIFont systemFontOfSize:13];
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
    CGFloat height = [EMConversationCell cellHeightWithModel:nil];
    
    _avatarView = [[EMImageView alloc] initWithFrame:CGRectMake(EMConversationCellPadding, EMConversationCellPadding, height - EMConversationCellPadding * 2, height - EMConversationCellPadding * 2)];
    [self.contentView addSubview:_avatarView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth - EMConversationCellPadding - 80, EMConversationCellPadding, 80, 20)];
    _timeLabel.font = _timeLabelFont;
    _timeLabel.textColor = _timeLabelColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarView.frame) + EMConversationCellPadding, EMConversationCellPadding, cellWidth - EMConversationCellPadding * 2 - CGRectGetMaxX(_avatarView.frame), (height - EMConversationCellPadding) / 2)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = _titleLabelFont;
    _titleLabel.textColor = _titleLabelColor;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), cellWidth - EMConversationCellPadding - CGRectGetMinX(_titleLabel.frame), (height - EMConversationCellPadding) / 2)];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = _detailLabelFont;
    _detailLabel.textColor = _detailLabelColor;
    [self.contentView addSubview:_detailLabel];
}

#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.avatarView.hidden = !showAvatar;
        CGRect titleFrame = self.titleLabel.frame;
        if (_showAvatar) {
            titleFrame.origin.x = CGRectGetMaxX(self.avatarView.frame) + EMConversationCellPadding;
            titleFrame.size.width = _cellWidth - CGRectGetMaxX(self.avatarView.frame) - EMConversationCellPadding * 2;
        }
        else{
            titleFrame.origin.x = EMConversationCellPadding;
            titleFrame.size.width = _cellWidth - EMConversationCellPadding * 2;
        }
        
        self.titleLabel.frame = titleFrame;
    }
}

- (void)setModel:(id<IConversationModel>)model
{
    _model = model;
    
    if ([_model.title length] > 0) {
        self.titleLabel.text = _model.title;
    }
    else{
        self.titleLabel.text = _model.conversation.chatter;
    }
    
    if (_model.avatarImage) {
        self.avatarView.image = _model.avatarImage;
    }
    else if ([_model.avatarURLPath length] > 0){
        
    }
    
    if (_model.conversation.unreadMessagesCount == 0) {
        _avatarView.showBadge = NO;
    }
    else{
        _avatarView.showBadge = YES;
        _avatarView.badge = _model.conversation.unreadMessagesCount;
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

- (void)setDetailLabelFont:(UIFont *)detailLabelFont
{
    _detailLabelFont = detailLabelFont;
    _detailLabel.font = _detailLabelFont;
}

- (void)setDetailLabelColor:(UIColor *)detailLabelColor
{
    _detailLabelColor = detailLabelColor;
    _detailLabel.textColor = _detailLabelColor;
}

- (void)setTimeLabelFont:(UIFont *)timeLabelFont
{
    _timeLabelFont = timeLabelFont;
    _timeLabel.font = _timeLabelFont;
}

- (void)setTimeLabelColor:(UIColor *)timeLabelColor
{
    _timeLabelColor = timeLabelColor;
    _timeLabel.textColor = _timeLabelColor;
}

#pragma mark - class method

+ (NSString *)cellIdentifier
{
    return @"EMConversationCell";
}

+ (CGFloat)cellHeightWithModel:(id)model
{
    return EMConversationCellMinHeight;
}


@end
