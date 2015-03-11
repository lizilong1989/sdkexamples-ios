//
//  NSData+Encryption.h
//  EaseMob
//
//  Created by Ji Fang on 3/8/13.
//  Copyright (c) 2013 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (smt_Encryption)

// Base64 encoding/decoding extension
+ (NSData *)smt_dataWithBase64EncodedString:(NSString *)string;
- (NSString *)smt_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)smt_base64EncodedString;

@end
