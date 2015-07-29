//
//  EMCDDeviceManager.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/7/3.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "EMCDDeviceManagerDelegate.h"

@interface EMCDDeviceManager : NSObject
{
    // recorder
    NSDate              *_recorderStartDate;
    NSDate              *_recorderEndDate;
    NSString            *_currCategory;
    BOOL                _currActive;
    
    // proximitySensor
    BOOL _isSupportProximitySensor;
    BOOL _isCloseToUser;
}

@property (nonatomic, assign) id <EMCDDeviceManagerDelegate> delegate;

+ (EMCDDeviceManager *)sharedInstance;

@end
