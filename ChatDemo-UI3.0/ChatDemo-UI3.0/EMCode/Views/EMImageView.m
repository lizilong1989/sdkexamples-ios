//
//  EMImageView.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMImageView.h"

@interface EMImageView()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *badgeView;

@end


@implementation EMImageView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EMImageView *imageView = [self appearance];
    imageView.badgeBackgroudColor = [UIColor redColor];
    imageView.badgeTextColor = [UIColor whiteColor];
    imageView.badgeFont = [UIFont boldSystemFontOfSize:10];
    imageView.imageCornerRadius = 3;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
    }
    
    return self;
}

#pragma mark - private

- (void)_setupSubviews
{
    self.clipsToBounds = NO;
    
    CGFloat badgeSize = self.frame.size.height / 5 * 2;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = _imageCornerRadius;
    [self addSubview:_imageView];
    
    _badgeView = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - badgeSize / 2, -3, badgeSize, badgeSize)];
    _badgeView.textAlignment = NSTextAlignmentCenter;
    _badgeView.textColor = _badgeTextColor;
    _badgeView.backgroundColor = _badgeBackgroudColor;
    _badgeView.font = _badgeFont;
    _badgeView.hidden = YES;
    _badgeView.layer.cornerRadius = badgeSize / 2;
    _badgeView.clipsToBounds = YES;
    [self addSubview:_badgeView];
}

#pragma mark - setter

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    if (badge > 99) {
        self.badgeView.text = @"N+";
    }
    else{
       self.badgeView.text = [NSString stringWithFormat:@"%ld", (long)_badge];
    }
}

- (void)setShowBadge:(BOOL)showBadge
{
    if (_showBadge != showBadge) {
        _showBadge = showBadge;
        self.badgeView.hidden = !_showBadge;
    }
}

- (void)setImageCornerRadius:(CGFloat)imageCornerRadius
{
    if (_imageCornerRadius != imageCornerRadius) {
        _imageCornerRadius = imageCornerRadius;
        self.imageView.layer.cornerRadius = _imageCornerRadius;
        
        CGRect badgeFrame = self.badgeView.frame;
        badgeFrame.origin.x -= _imageCornerRadius;
        self.badgeView.frame = badgeFrame;
    }
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    _badgeFont = badgeFont;
    self.badgeView.font = badgeFont;
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    self.badgeView.textColor = badgeTextColor;
}

- (void)setBadgeBackgroudColor:(UIColor *)badgeBackgroudColor
{
    _badgeBackgroudColor = badgeBackgroudColor;
    self.badgeView.backgroundColor = badgeBackgroudColor;
}

@end
