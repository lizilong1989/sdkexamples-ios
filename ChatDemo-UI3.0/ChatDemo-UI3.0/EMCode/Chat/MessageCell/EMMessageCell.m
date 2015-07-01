//
//  EMMessageCell.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMMessageCell.h"

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

@property (nonatomic) NSLayoutConstraint *statusWidthConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleMaxWidthConstraint;

@end

@implementation EMMessageCell

@synthesize statusButton = _statusButton;
@synthesize bubbleView = _bubbleView;

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EMMessageCell *cell = [self appearance];
    cell.messageTextFont = [UIFont systemFontOfSize:15];
    cell.messageTextColor = [UIColor blackColor];
    cell.messageLocationFont = [UIFont systemFontOfSize:12];
    cell.messageLocationColor = [UIColor whiteColor];
    cell.statusSize = 20;
    cell.bubbleMaxWidth = 230;
    cell.bubbleMargin = UIEdgeInsetsMake(8, 15, 8, 10);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
    }
    
    return self;
}

#pragma mark - setup subviews

- (void)_setupSubviews
{
    _statusButton = [[UIButton alloc] init];
    _statusButton.translatesAutoresizingMaskIntoConstraints = NO;
    _statusButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_statusButton addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.hidden = YES;
    [self.contentView addSubview:_statusButton];
    
    _bubbleView = [[EMBubbleView alloc] initWithIdentifier:self.reuseIdentifier margin:_bubbleMargin];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    _bubbleView.backgroundColor = [UIColor clearColor];
    _bubbleView.backgroundImage = _bubbleBackgroundImage;
    _bubbleView.textLabel.font = _messageTextFont;
    _bubbleView.textLabel.textColor = _messageTextColor;
    _bubbleView.locationLabel.font = _messageLocationFont;
    _bubbleView.locationLabel.textColor = _messageLocationColor;
    [self.contentView addSubview:_bubbleView];
    
    [self _setupConstraints];
}

#pragma mark - Setup Constraints

- (void)_setupConstraints
{
    //bubble view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EMMessageCellPadding]];
    
    self.bubbleMaxWidthConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.bubbleMaxWidth];
    [self addConstraint:self.bubbleMaxWidthConstraint];
    
    //status button
    self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.statusSize];
    [self addConstraint:self.statusWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.statusButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

#pragma mark - Update Constraint

- (void)_updateStatusButtonWidthConstraint
{
    if (_statusButton) {
        [self removeConstraint:self.statusWidthConstraint];
        
        self.statusWidthConstraint = [NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.statusSize];
        [self addConstraint:self.statusWidthConstraint];
    }
}

- (void)_updateBubbleMaxWidthConstraint
{
    [self removeConstraint:self.bubbleMaxWidthConstraint];
    
    self.bubbleMaxWidthConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.bubbleMaxWidth];
    [self addConstraint:self.bubbleMaxWidthConstraint];
}

#pragma mark - setter

- (void)setModel:(id<IMessageModel>)model
{
    _model = model;
    
    switch (model.contentType) {
        case eMessageBodyType_Text:
        {
            _bubbleView.textLabel.text = model.text;
        }
            break;
        case eMessageBodyType_Image:
        {
            UIImage *image = _model.thumbnailImage;
            if (!image) {
                image = _model.image;
                if (!image) {
                    image = [UIImage imageNamed:_model.failImageName];
                }
            }
            _bubbleView.imageView.image = image;
        }
            break;
        case eMessageBodyType_Video:
        {
            
        }
            break;
        case eMessageBodyType_Location:
        {
            _bubbleView.locationImageView.image = _messageLocationImage;
            _bubbleView.locationLabel.text = _model.address;
        }
            break;
        case eMessageBodyType_Voice:
        {
            
        }
            break;
        case eMessageBodyType_File:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)setStatusSize:(CGFloat)statusSize
{
    _statusSize = statusSize;
    [self _updateStatusButtonWidthConstraint];
}

- (void)setBubbleBackgroundImage:(UIImage *)bubbleBackgroundImage
{
    _bubbleBackgroundImage = bubbleBackgroundImage;
    if (_bubbleView) {
        _bubbleView.backgroundImage = _bubbleBackgroundImage;
    }
}

- (void)setBubbleMaxWidth:(CGFloat)bubbleMaxWidth
{
    _bubbleMaxWidth = bubbleMaxWidth;
    [self _updateBubbleMaxWidthConstraint];
}

- (void)setBubbleMargin:(UIEdgeInsets)bubbleMargin
{
    _bubbleMargin = bubbleMargin;
    if (_bubbleView) {
        [_bubbleView setMargin:_bubbleMargin];
    }
}

- (void)setMessageTextFont:(UIFont *)messageTextFont
{
    _messageTextFont = messageTextFont;
    if (_bubbleView) {
        _bubbleView.textLabel.font = messageTextFont;
    }
}

- (void)setMessageTextColor:(UIColor *)messageTextColor
{
    _messageTextColor = messageTextColor;
    if (_bubbleView) {
        _bubbleView.textLabel.textColor = _messageTextColor;
    }
}

- (void)setMessageLocationColor:(UIColor *)messageLocationColor
{
    _messageLocationColor = messageLocationColor;
    if (_bubbleView) {
        _bubbleView.locationLabel.textColor = _messageLocationColor;
    }
}

- (void)setMessageLocationFont:(UIFont *)messageLocationFont
{
    _messageLocationFont = messageLocationFont;
    if (_bubbleView) {
        _bubbleView.locationLabel.font = _messageLocationFont;
    }
}

- (void)setMessageLocationImage:(UIImage *)messageLocationImage
{
    _messageLocationImage = messageLocationImage;
    if (_bubbleView) {
        _bubbleView.locationImageView.image = _messageLocationImage;
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
    EMMessageCell *cell = [self appearance];
    CGFloat bubbleMaxWidth = cell.bubbleMaxWidth - cell.bubbleMargin.left - cell.bubbleMargin.right;
    
    CGFloat height = EMMessageCellPadding + cell.bubbleMargin.top + cell.bubbleMargin.bottom;
    
    switch (model.contentType) {
        case eMessageBodyType_Text:
        {
            NSString *text = model.text;
            UIFont *textFont = cell.messageTextFont;
            CGRect rect = [text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:textFont}
                                             context:nil];
            height += (rect.size.height > 20 ? rect.size.height : 20);
        }
            break;
        case eMessageBodyType_Image:
        {
            CGSize retSize = model.thumbnailSize;
            if (retSize.width == 0 || retSize.height == 0) {
                retSize.width = kEMMessageMaxImageSize;
                retSize.height = kEMMessageMaxImageSize;
            }
            else if (retSize.width > retSize.height) {
                CGFloat height =  kEMMessageMaxImageSize / retSize.width * retSize.height;
                retSize.height = height;
                retSize.width = kEMMessageMaxImageSize;
            }
            else {
                CGFloat width = kEMMessageMaxImageSize / retSize.height * retSize.width;
                retSize.width = width;
                retSize.height = kEMMessageMaxImageSize;
            }

            height += retSize.height;
        }
            break;
        case eMessageBodyType_Video:
        {
        
        }
            break;
        case eMessageBodyType_Location:
        {
            height += kEMMessageLocationSize;
        }
            break;
        case eMessageBodyType_Voice:
        {
            
        }
            break;
        case eMessageBodyType_File:
        {
            
        }
            break;
        default:
            break;
    }

    height += EMMessageCellPadding;
    
    return height;
}

@end
