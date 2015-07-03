//
//  EMChatToolbar.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/7/1.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DXTextView.h"
#import "EMChatToolbarItem.h"
#import "DXChatBarMoreView.h"
#import "DXFaceView.h"

@protocol EMChatToolbarDelegate;
@interface EMChatToolbar : UIView

@property (weak, nonatomic) id<EMChatToolbarDelegate> delegate;

@property (nonatomic) UIImage *backgroundImage;

@property (nonatomic, readonly) CGFloat inputViewMaxHeight;

@property (nonatomic, readonly) CGFloat inputViewMinHeight;

@property (nonatomic, readonly) CGFloat horizontalPadding;

@property (nonatomic, readonly) CGFloat verticalPadding;

/**
 *  输入框左侧的按钮列表：EMChatToolbarItem类型
 */
@property (strong, nonatomic) NSArray *inputViewLeftItems;

/**
 *  输入框右侧的按钮列表：EMChatToolbarItem类型
 */
@property (strong, nonatomic) NSArray *inputViewRightItems;

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) DXTextView *inputTextView;

/**
 *  初始化chat bar
 * @param horizontalPadding  default 8
 * @param verticalPadding    default 5
 * @param inputViewMinHeight default 36
 * @param inputViewMaxHeight default 150
 */
- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

@end

@protocol EMChatToolbarDelegate <NSObject>

//

@end
