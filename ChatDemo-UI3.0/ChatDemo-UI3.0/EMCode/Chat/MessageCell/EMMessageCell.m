//
//  EMMessageCell.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMMessageCell.h"

#import "EMBubbleView.h"

CGFloat const EMMessageCellPadding = 10;

NSString *const EMMessageCellIdentifierRecvText = @"EMMessageCellRecvText";
NSString *const EMMessageCellIdentifierRecvLocation = @"EMMessageCellRecvLocation";
NSString *const EMMessageCellIdentifierRecvVoice = @"EMMessageCellRecvVoice";
NSString *const EMMessageCellIdentifierRecvVideo = @"EMMessageCellRecvVideo";
NSString *const EMMessageCellIdentifierRecvImage = @"EMMessageCellRecvImage";
NSString *const EMMessageCellIdentifierRecvFile = @"EMMessageCellRecvFile";

NSString *const EMMessageCellIdentifierSendText = @"EMMessageCellSendText";
NSString *const EMMessageCellIdentifierSendLocation = @"EMMessageCellSendLocation";
NSString *const EMMessageCellIdentifierSendVoice = @"EMMessageCellSendVoice";
NSString *const EMMessageCellIdentifierSendVideo = @"EMMessageCellSendVideo";
NSString *const EMMessageCellIdentifierSendImage = @"EMMessageCellSendImage";
NSString *const EMMessageCellIdentifierSendFile = @"EMMessageCellSendFile";

@interface EMMessageCell()

@property (strong, nonatomic) UIImageView *avatarView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIButton *statusButton;

@property (strong, nonatomic) EMBubbleView *bubbleView;

@property (nonatomic) NSLayoutConstraint *avatarWidthConstraint;

@property (nonatomic) NSLayoutConstraint *statusWidthConstraint;

@end

@implementation EMMessageCell

@synthesize avatarView = _avatarView;
@synthesize nameLabel = _nameLabel;
@synthesize statusButton = _statusButton;
@synthesize bubbleView = _bubbleView;

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EMMessageCell *cell = [self appearance];
    cell.nameLabelColor = [UIColor grayColor];
    cell.nameLabelFont = [UIFont systemFontOfSize:10];
    cell.nameLabelHeight = 15;
    cell.avatarSize = 30;
    cell.statusSize = 20;
    cell.backgroundImageTheme = @"bubbleBg";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    BOOL isSender = [reuseIdentifier containsString:@"Send"];
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier isSender:isSender];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     isSender:(BOOL)isSender
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviewsWithSender:isSender];
    }
    
    return self;
}

#pragma mark - setup subviews

- (void)_setupSubviewsWithSender:(BOOL)isSender
{
    _statusButton = [[UIButton alloc] init];
    _statusButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_statusButton addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_statusButton];
    
    _bubbleView = [[EMBubbleView alloc] initWithIdentifier:self.reuseIdentifier];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    _bubbleView.backgroundColor = [UIColor clearColor];
    NSString *imageName = [NSString stringWithFormat:@"%@%@", _backgroundImageTheme, (isSender ? @"Send" : @"Recv")];
    _bubbleView.backgroundImageName = imageName;
    [self addSubview:_bubbleView];
    
    if (!isSender) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        _avatarView.backgroundColor = [UIColor clearColor];
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = _avatarCornerRadius;
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = _nameLabelFont;
        _nameLabel.textColor = _nameLabelColor;
        [self addSubview:_nameLabel];
        
        [self _setupAvatarViewConstraints];
        [self _setupNameLabelConstraints];
    }
    
    [self _setupBubbleViewConstraintsWithSender:isSender];
    [self _setupStatusButtonConstraintsWithSender:isSender];
}

#pragma mark - Setup Constraints

- (void)_setupAvatarViewConstraints
{
    self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.avatarSize];
    [self addConstraint:self.avatarWidthConstraint];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EMMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EMMessageCellPadding]];
}

- (void)_setupNameLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EMMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EMMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.nameLabelHeight]];
}

- (void)_setupStatusButtonConstraintsWithSender:(BOOL)isSender
{
    self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.statusSize];
    [self addConstraint:self.statusWidthConstraint];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.statusButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    if (isSender) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EMMessageCellPadding]];
    }
    else{
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EMMessageCellPadding]];
    }
}

- (void)_setupBubbleViewConstraintsWithSender:(BOOL)isSender
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EMMessageCellPadding]];
    
    if (isSender) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EMMessageCellPadding]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EMMessageCellPadding * 2 + self.statusSize]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EMMessageCellPadding]];
    }
    else{
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EMMessageCellPadding]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-(EMMessageCellPadding * 2 + self.statusSize)]];
    }
}

- (void)_updateAvatarViewWidthConstraint
{
    if (_avatarView) {
        [self removeConstraint:self.avatarWidthConstraint];
        
        self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.avatarSize];
        [self addConstraint:self.avatarWidthConstraint];
    }
}

- (void)_updateStatusButtonWidthConstraint
{
    if (_statusButton) {
        [self removeConstraint:self.statusWidthConstraint];
        
        self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.statusSize];
        [self addConstraint:self.statusWidthConstraint];
    }
}

#pragma mark - setter

- (void)setModel:(id<IMessageModel>)model
{
    _model = model;
}

- (void)setNameLabelFont:(UIFont *)nameLabelFont
{
    _nameLabelFont = nameLabelFont;
    _nameLabel.font = nameLabelFont;
}

- (void)setNameLabelColor:(UIColor *)nameLabelColor
{
    _nameLabelColor = nameLabelColor;
    _nameLabel.textColor = nameLabelColor;
}

- (void)setAvatarSize:(CGFloat)avatarSize
{
    _avatarSize = avatarSize;
    [self _updateAvatarViewWidthConstraint];
}

- (void)setAvatarCornerRadius:(CGFloat)avatarCornerRadius
{
    _avatarCornerRadius = avatarCornerRadius;
    _avatarView.layer.cornerRadius = avatarCornerRadius;
}

- (void)setStatusSize:(CGFloat)statusSize
{
    _statusSize = statusSize;
    [self _updateStatusButtonWidthConstraint];
}

- (void)setBackgroundImageTheme:(NSString *)backgroundImageTheme
{
    _backgroundImageTheme = backgroundImageTheme;
    
    if (_bubbleView) {
        BOOL isSender = [self.reuseIdentifier containsString:@"Send"];
        NSString *imageName = [NSString stringWithFormat:@"%@%@", _backgroundImageTheme, (isSender ? @"Send" : @"Recv")];
        _bubbleView.backgroundImageName = imageName;
    }
}

#pragma mark - action

- (void)statusAction
{
    
}

#pragma mark - public

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    NSString *cellIdentifier = nil;
    if (model.isSender) {
        switch (model.contentType) {
            case eMessageBodyType_Text:
                cellIdentifier = EMMessageCellIdentifierSendText;
                break;
            case eMessageBodyType_Image:
                cellIdentifier = EMMessageCellIdentifierSendImage;
                break;
            case eMessageBodyType_Video:
                cellIdentifier = EMMessageCellIdentifierSendVideo;
                break;
            case eMessageBodyType_Location:
                cellIdentifier = EMMessageCellIdentifierSendLocation;
                break;
            case eMessageBodyType_Voice:
                cellIdentifier = EMMessageCellIdentifierSendVoice;
                break;
            case eMessageBodyType_File:
                cellIdentifier = EMMessageCellIdentifierSendFile;
                break;
            default:
                break;
        }
    }
    else{
        switch (model.contentType) {
            case eMessageBodyType_Text:
                cellIdentifier = EMMessageCellIdentifierRecvText;
                break;
            case eMessageBodyType_Image:
                cellIdentifier = EMMessageCellIdentifierRecvImage;
                break;
            case eMessageBodyType_Video:
                cellIdentifier = EMMessageCellIdentifierRecvVideo;
                break;
            case eMessageBodyType_Location:
                cellIdentifier = EMMessageCellIdentifierRecvLocation;
                break;
            case eMessageBodyType_Voice:
                cellIdentifier = EMMessageCellIdentifierRecvVoice;
                break;
            case eMessageBodyType_File:
                cellIdentifier = EMMessageCellIdentifierRecvFile;
                break;
            default:
                break;
        }
    }
    
    return cellIdentifier;
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return 0;
}

@end
