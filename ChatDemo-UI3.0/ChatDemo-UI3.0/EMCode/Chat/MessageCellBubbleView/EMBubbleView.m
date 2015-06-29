//
//  EMBubbleView.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/29.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMBubbleView.h"

@interface EMBubbleView()

@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) UIButton *statusButton;

@property (strong, nonatomic) UILabel *textLabel;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation EMBubbleView

@synthesize backgroundImageView = _backgroundImageView;

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        _identifier = identifier;
        
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
    
    if ([_identifier isEqualToString:EMMessageCellIdentifierRecvText] || [_identifier isEqualToString:EMMessageCellIdentifierSendText])
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        [self _setupTextConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierRecvImage] || [_identifier isEqualToString:EMMessageCellIdentifierSendImage])
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_imageView];
        
        [self _setupImageConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierRecvLocation] || [_identifier isEqualToString:EMMessageCellIdentifierSendLocation])
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_imageView];
        
        [self _setupLocationConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierRecvVoice] || [_identifier isEqualToString:EMMessageCellIdentifierSendVoice])
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        [self _setupVoiceConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierRecvVideo] || [_identifier isEqualToString:EMMessageCellIdentifierSendVideo])
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_imageView];
        
        [self _setupVideoConstraints];
    }
    else if ([_identifier isEqualToString:EMMessageCellIdentifierRecvFile] || [_identifier isEqualToString:EMMessageCellIdentifierSendFile])
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_imageView];
        
        [self _setupFileConstraints];
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

- (void)_setupTextConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:EMMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EMMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EMMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EMMessageCellPadding]];
}

- (void)_setupImageConstraints
{
    
}

- (void)_setupLocationConstraints
{
    
}

- (void)_setupVoiceConstraints
{
    
}

- (void)_setupVideoConstraints
{
    
}

- (void)_setupFileConstraints
{
    
}

#pragma mark - setter

- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    if (![_backgroundImageName isEqualToString:backgroundImageName]) {
        _backgroundImageName = backgroundImageName;
        _backgroundImageView.image = [[UIImage imageNamed:_backgroundImageName] stretchableImageWithLeftCapWidth:EMMessageCellPadding topCapHeight:EMMessageCellPadding];
    }
}

@end
