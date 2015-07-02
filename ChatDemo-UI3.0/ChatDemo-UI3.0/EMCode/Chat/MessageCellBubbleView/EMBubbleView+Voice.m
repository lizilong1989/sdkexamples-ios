//
//  EMBubbleView+Voice.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/7/2.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMBubbleView+Voice.h"

@implementation EMBubbleView (Voice)

#pragma mark - private

- (void)_setupVoiceBubbleMarginConstraints
{
    [self.marginConstraints removeAllObjects];
    
    //image view
    NSLayoutConstraint *imageWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.voiceImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *imageWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.voiceImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:imageWithMarginTopConstraint];
    [self.marginConstraints addObject:imageWithMarginBottomConstraint];
    
    //duration label
    NSLayoutConstraint *durationWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *durationWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:durationWithMarginTopConstraint];
    [self.marginConstraints addObject:durationWithMarginBottomConstraint];
    
    if(self.isSender){
        NSLayoutConstraint *imageWithMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.voiceImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
        [self.marginConstraints addObject:imageWithMarginRightConstraint];
        
        NSLayoutConstraint *durationRightConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.voiceImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EMMessageCellPadding];
        [self.marginConstraints addObject:durationRightConstraint];
        
        NSLayoutConstraint *durationLeftConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
        [self.marginConstraints addObject:durationLeftConstraint];
    }
    else{
        NSLayoutConstraint *imageWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.voiceImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
        [self.marginConstraints addObject:imageWithMarginLeftConstraint];
        
        NSLayoutConstraint *durationLeftConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.voiceImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EMMessageCellPadding];
        [self.marginConstraints addObject:durationLeftConstraint];
        
        NSLayoutConstraint *durationRightConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
        [self.marginConstraints addObject:durationRightConstraint];
    }
    
    [self addConstraints:self.marginConstraints];
}

- (void)_setupVoiceBubbleConstraints
{
    [self _setupVoiceBubbleMarginConstraints];
}

#pragma mark - public

- (void)setupVoiceBubbleView
{
    self.voiceImageView = [[UIImageView alloc] init];
    self.voiceImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.voiceImageView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.voiceImageView];
    
    self.voiceDurationLabel = [[UILabel alloc] init];
    self.voiceDurationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.voiceDurationLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.voiceDurationLabel];
    
    [self _setupVoiceBubbleConstraints];
}

- (void)updateVoiceMarginConstraints
{
    [self removeConstraints:self.marginConstraints];
    
    [self _setupVoiceBubbleMarginConstraints];
}

@end
