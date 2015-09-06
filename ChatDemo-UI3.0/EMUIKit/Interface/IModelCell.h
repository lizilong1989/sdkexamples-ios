//
//  IModelCell.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IModelCell <NSObject>

@required

@property (strong, nonatomic) id model;

/*!
 @method
 @brief 判断是否为自定义Cell
 @discussion
 @param model 消息
 @result
 */
- (BOOL)isCustomBubbleView:(id)model;

/*!
 @method
 @brief 设置自定义Cell气泡
 @discussion
 @param model 消息
 @result
 */
- (void)setCustomBubbleView:(id)model;

/*!
 @method
 @brief 设置自定义Cell
 @discussion
 @param model 消息
 @result
 */
- (void)setCustomModel:(id)model;

/*!
 @method
 @brief 修改自定义气泡位置
 @discussion
 @param bubbleMargin 
 @param model 消息
 @result
 */
- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id)mode;

+ (NSString *)cellIdentifierWithModel:(id)model;

+ (CGFloat)cellHeightWithModel:(id)model;

@optional

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id)model;

@end
