//
//  NSString+Encryption.h
//  EaseMob
//
//  Created by Ji Fang on 3/8/13.
//  Copyright (c) 2013 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (smt_Encryption)

// Base64 encoding/decoding extension
+ (NSString *)smt_stringWithBase64EncodedString:(NSString *)string;
- (NSString *)smt_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)smt_base64EncodedString;
- (NSString *)smt_base64DecodedString;
- (NSData *)smt_base64DecodedData;

@end
