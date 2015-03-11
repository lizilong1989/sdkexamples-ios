//
//  SMTChatCryptor.h
//  demoApp
//
//  Created by Ji Fang on 5/12/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEMChatCryptor.h"

@interface SMTChatCryptor : NSObject<IEMChatCryptor>

+ (SMTChatCryptor *)sharedInstance;

@end
