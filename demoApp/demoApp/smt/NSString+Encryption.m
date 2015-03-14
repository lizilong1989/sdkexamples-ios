//
//  NSString+Encryption.m
//  EaseMob
//
//  Created by Ji Fang on 3/8/13.
//  Copyright (c) 2013 Ji Fang. All rights reserved.
//

#import "NSString+Encryption.h"
#import "NSData+Encryption.h"

#define kKeyLength 32

@implementation NSString (smt_Encryption)

+ (NSString *)smt_stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData smt_dataWithBase64EncodedString:string];
    if (data) {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)smt_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data smt_base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)smt_base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data smt_base64EncodedString];
}

- (NSString *)smt_base64DecodedString
{
    return [NSString smt_stringWithBase64EncodedString:self];
}

- (NSData *)smt_base64DecodedData
{
    return [NSData smt_dataWithBase64EncodedString:self];
}

@end
