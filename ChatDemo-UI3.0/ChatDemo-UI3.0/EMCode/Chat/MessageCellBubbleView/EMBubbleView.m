//
//  EMBubbleView.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/29.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMBubbleView.h"

#import "EMBubbleView+Text.h"
#import "EMBubbleView+Image.h"
#import "EMBubbleView+Location.h"
#import "EMBubbleView+Voice.h"
#import "EMBubbleView+Video.h"
#import "EMBubbleView+File.h"

@interface EMBubbleView()

@property (nonatomic) NSLayoutConstraint *marginTopConstraint;
@property (nonatomic) NSLayoutConstraint *marginBottomConstraint;
@property (nonatomic) NSLayoutConstraint *marginLeftConstraint;
@property (nonatomic) NSLayoutConstraint *marginRightConstraint;

@end

@implementation EMBubbleView

@synthesize backgroundImageView = _backgroundImageView;
@synthesize margin = _margin;

- (instancetype)initWithIdentifier:(NSString *)identifier
                          isSender:(BOOL)isSender
                            margin:(UIEdgeInsets)margin
{
    self = [super init];
    if (self) {
        _identifier = identifier;
        _isSender = isSender;
        _margin = margin;
        _marginConstraints = [NSMutableArray array];
        
        [self _setupSubviews];
    }
    
    return self;
}

#pragma mark - layout subviews

- (void)_setupSubviews
{
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundImageView];
    [self _setupBackgroundImageViewConstraints];
    
    if ([_identifier isEqualToString:EMMessageCellIdentifierSendText] || [_identifier isEqualToString:EMMessageCellIdentifierRecvText])
    {
        [self setupTextBubbleView];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendImage] || [_identifier isEqualToString:EMMessageCellIdentifierRecvImage])
    {
        [self setupImageBubbleView];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendLocation] || [_identifier isEqualToString:EMMessageCellIdentifierRecvLocation])
    {
        [self setupLocationBubbleView];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendVoice] || [_identifier isEqualToString:EMMessageCellIdentifierRecvVoice])
    {
        [self setupVoiceBubbleView];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendVideo] || [_identifier isEqualToString:EMMessageCellIdentifierRecvVideo])
    {
        [self setupVideoBubbleView];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendFile] || [_identifier isEqualToString:EMMessageCellIdentifierRecvFile])
    {
        [self setupFileBubbleView];
    }
}

#pragma mark - Setup Constraints

- (void)_setupBackgroundImageViewConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

#pragma mark - setter

- (void)setMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    
    _margin = margin;
    
    if ([_identifier isEqualToString:EMMessageCellIdentifierSendText] || [_identifier isEqualToString:EMMessageCellIdentifierRecvText])
    {
        [self updateTextMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendImage] || [_identifier isEqualToString:EMMessageCellIdentifierRecvImage])
    {
        [self updateImageMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendLocation] || [_identifier isEqualToString:EMMessageCellIdentifierRecvLocation])
    {
        [self updateLocationMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendVoice] || [_identifier isEqualToString:EMMessageCellIdentifierRecvVoice])
    {
        [self updateVoiceMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendVideo] || [_identifier isEqualToString:EMMessageCellIdentifierRecvVideo])
    {
        [self updateVideoMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendFile] || [_identifier isEqualToString:EMMessageCellIdentifierRecvFile])
    {
        [self updateFileMarginConstraints];
    }
}

@end
