//
//  ViewController+PressBg.m
//  demoApp
//
//  Created by dujiepeng on 14-5-7.
//  Copyright (c) 2014年 EaseMob. All rights reserved.
//

#import "ViewController+PressBg.h"

@implementation ViewController (PressBg)
- (void)addTapBgEvent{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(bgPressed)];
    [self.view addGestureRecognizer:tap];
}

- (void)bgPressed{
    [self.view endEditing:YES];
}
@end
