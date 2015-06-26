//
//  EMMessageCell.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/26.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IModelCell.h"
#import "IMessageModel.h"

@interface EMMessageCell : UITableViewCell<IModelCell>

@property (strong, nonatomic) id<IMessageModel> model;

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model;

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model;

@end
