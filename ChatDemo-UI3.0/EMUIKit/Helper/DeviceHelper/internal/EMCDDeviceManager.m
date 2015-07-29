//
//  EMCDDeviceManager.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/7/3.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EMCDDeviceManager.h"

#import "EMCDDeviceManager+ProximitySensor.h"

static EMCDDeviceManager *dvManager = nil;

@implementation EMCDDeviceManager

+ (EMCDDeviceManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dvManager = [[EMCDDeviceManager alloc] init];
    });
    
    return dvManager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self _setupProximitySensor];
        [self registerNotifications];
    }
    return self;
}

- (void)registerNotifications
{
    [self unregisterNotifications];
    if (_isSupportProximitySensor)
    {
        static NSString *notif = @"UIDeviceProximityStateDidChangeNotification";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChanged:) name:notif object:nil];
    }
}

- (void)unregisterNotifications
{
    if (_isSupportProximitySensor)
    {
        static NSString *notif = @"UIDeviceProximityStateDidChangeNotification";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notif object:nil];
    }
}

- (void)_setupProximitySensor
{
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
    _isSupportProximitySensor = device.proximityMonitoringEnabled;
    
    if (_isSupportProximitySensor) {
        [device setProximityMonitoringEnabled:NO];
    }
}


@end
