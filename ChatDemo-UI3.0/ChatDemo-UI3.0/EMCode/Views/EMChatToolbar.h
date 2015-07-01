//
//  EMChatToolbar.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/7/1.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DXTextView.h"

@protocol EMChatToolbarDelegate;
@interface EMChatToolbar : UIView

@property (weak, nonatomic) id<EMChatToolbarDelegate> delegate;

@property (nonatomic) UIImage *backgroundImage;

@property (nonatomic) CGFloat inputViewMaxHeight;

@property (nonatomic) CGFloat horizontalPadding;

@property (nonatomic) CGFloat verticalPadding;

@property (strong, nonatomic) UIButton *leftButton; //default record

@property (strong, nonatomic) UIButton *rightButton; //default more

@property (strong, nonatomic) UIView *left2View; //default record view

@property (strong, nonatomic) UIView *right2View; //default more view

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) DXTextView *inputTextView;

@end

@protocol EMChatToolbarDelegate <NSObject>

//

@end
