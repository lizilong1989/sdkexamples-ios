//
//  EMBubbleView.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/29.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMBubbleView.h"

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
                            margin:(UIEdgeInsets)margin
{
    self = [super init];
    if (self) {
        _identifier = identifier;
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
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints  = NO;
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundImageView];
    
    if ([_identifier isEqualToString:EMMessageCellIdentifierSendText] || [_identifier isEqualToString:EMMessageCellIdentifierRecvText])
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self.backgroundImageView addSubview:_textLabel];
        
        [self _setupTextConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendImage] || [_identifier isEqualToString:EMMessageCellIdentifierRecvImage])
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.backgroundImageView addSubview:_imageView];
        
        [self _setupImageConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendLocation] || [_identifier isEqualToString:EMMessageCellIdentifierRecvLocation])
    {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _locationImageView.backgroundColor = [UIColor lightGrayColor];
        _locationImageView.clipsToBounds = YES;
        [self addSubview:_locationImageView];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _locationLabel.numberOfLines = 2;
        _locationLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        [_locationImageView addSubview:_locationLabel];
        
        [self _setupLocationConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendVoice] || [_identifier isEqualToString:EMMessageCellIdentifierRecvVoice])
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        [self _setupVoiceConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendVideo] || [_identifier isEqualToString:EMMessageCellIdentifierRecvVideo])
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        [self _setupVideoConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendFile] || [_identifier isEqualToString:EMMessageCellIdentifierRecvFile])
    {
        [self setupFileBubbleView];
    }
    
    [self _setupBackgroundImageViewConstraints];
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

- (void)_setupMarginConstraintsForSubview:(UIView *)forView toItem:(UIView *)toView
{
    self.marginTopConstraint = [NSLayoutConstraint constraintWithItem:forView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    self.marginBottomConstraint = [NSLayoutConstraint constraintWithItem:forView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    self.marginLeftConstraint = [NSLayoutConstraint constraintWithItem:forView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    self.marginRightConstraint = [NSLayoutConstraint constraintWithItem:forView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    
    [self addConstraint:self.marginTopConstraint];
    [self addConstraint:self.marginBottomConstraint];
    [self addConstraint:self.marginLeftConstraint];
    [self addConstraint:self.marginRightConstraint];
}

- (void)_setupTextConstraints
{
    [self _setupMarginConstraintsForSubview:self.textLabel toItem:self.backgroundImageView];
}

- (void)_setupImageConstraints
{
    [self _setupMarginConstraintsForSubview:self.imageView toItem:self.backgroundImageView];
}

- (void)_setupLocationConstraints
{
    [self _setupMarginConstraintsForSubview:self.locationImageView toItem:self.backgroundImageView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.locationImageView attribute:NSLayoutAttributeHeight multiplier:0.3 constant:0]];
}

- (void)_setupVoiceConstraints
{
    
}

- (void)_setupVideoConstraints
{
    [self _setupMarginConstraintsForSubview:self.imageView toItem:self.backgroundImageView];
}

- (void)_setupFileConstraints
{
    
}

#pragma mark - Update Constraints

- (void)_updateTextMarginConstraints
{
    [self removeConstraint:self.marginTopConstraint];
    [self removeConstraint:self.marginBottomConstraint];
    [self removeConstraint:self.marginLeftConstraint];
    [self removeConstraint:self.marginRightConstraint];
    [self _setupMarginConstraintsForSubview:self.textLabel toItem:self.backgroundImageView];
}

- (void)_updateImageMarginConstraints
{
    [self removeConstraint:self.marginTopConstraint];
    [self removeConstraint:self.marginBottomConstraint];
    [self removeConstraint:self.marginLeftConstraint];
    [self removeConstraint:self.marginRightConstraint];
    [self _setupMarginConstraintsForSubview:self.imageView toItem:self.backgroundImageView];
}

- (void)_updateLocationMarginConstraints
{
    [self removeConstraint:self.marginTopConstraint];
    [self removeConstraint:self.marginBottomConstraint];
    [self removeConstraint:self.marginLeftConstraint];
    [self removeConstraint:self.marginRightConstraint];
    [self _setupMarginConstraintsForSubview:self.locationImageView toItem:self.backgroundImageView];
}

- (void)_updateVoiceMarginConstraints
{
    
}

- (void)_updateVideoMarginConstraints
{
    [self removeConstraint:self.marginTopConstraint];
    [self removeConstraint:self.marginBottomConstraint];
    [self removeConstraint:self.marginLeftConstraint];
    [self removeConstraint:self.marginRightConstraint];
    [self _setupMarginConstraintsForSubview:self.imageView toItem:self.backgroundImageView];
}


#pragma mark - setter

- (void)setMargin:(UIEdgeInsets)margin
{
    _margin = margin;
    
    if ([_identifier isEqualToString:EMMessageCellIdentifierSendText] || [_identifier isEqualToString:EMMessageCellIdentifierRecvText])
    {
        [self _updateTextMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendImage] || [_identifier isEqualToString:EMMessageCellIdentifierRecvImage])
    {
        [self _updateImageMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendLocation] || [_identifier isEqualToString:EMMessageCellIdentifierRecvLocation])
    {
        [self _updateLocationMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendVoice] || [_identifier isEqualToString:EMMessageCellIdentifierRecvVoice])
    {
        [self _updateVoiceMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendVideo] || [_identifier isEqualToString:EMMessageCellIdentifierRecvVideo])
    {
        [self _updateVideoMarginConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierSendFile] || [_identifier isEqualToString:EMMessageCellIdentifierRecvFile])
    {
        [self updateFileMarginConstraints];
    }
}

@end
