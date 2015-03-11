//
//  SMTChatCryptor.m
//  demoApp
//
//  Created by Ji Fang on 5/12/14.
//  Copyright (c) 2014 EaseMob. All rights reserved.
//

#import "SMTChatCryptor.h"
#import "smt.h"
#import "smt_errno.h"
#import "NSString+Encryption.h"
#import "NSData+Encryption.h"
#import "IChatManager.h"

struct smt_t;
@interface SMTChatCryptor() {
    smt_t *_smt;
}

- (void)registerNotifications;
- (void)unregisterNotifications;

@end

@implementation SMTChatCryptor

- (void)registerNotifications {
    [self unregisterNotifications];
}

- (void)unregisterNotifications {
}

static SMTChatCryptor *_sharedInstance = nil;
+ (SMTChatCryptor *)sharedInstance {
    if (_sharedInstance == nil) {
        @synchronized(self) {
            _sharedInstance = [[SMTChatCryptor alloc] init];
        }
    }
    
    return _sharedInstance;
}

- (id)init {
    if(self=[super init]) {        
        [self registerNotifications];
        // todo: how to initialize smt ? 
        //_smt = smt_init(char *storagePath, char *pfxFile, char *srvCertFile, char *phoneNum, char *ip, int port, int *error);
    }
    
    return self;
}

- (void)dealloc {
    [self unregisterNotifications];
    if(_smt) {
        smt_release(_smt);
    }
}

#pragma mark - IEMChatCryptor
// it is used by sending message.
- (NSData *)encryptData:(NSData *)data args:(id)aArgs {
    NSData *ret = nil;
    if([aArgs isKindOfClass:[NSArray class]]) {
        NSArray *args = (NSArray *)aArgs;
        EMMessage *message = nil;
        for (id object in args) {
            if ([object isKindOfClass:[EMMessage class]]) {
                message = (EMMessage *)object;
                break;
            }
        }
        if (message) {
            //NSString *from = message.from;
            //NSString *to = message.to;
            // todo: how to encrypt data ? 
            //smt_getKey(smt_t *smt, int requestFlag, char *callPhoneNum, char *calledPhoneNum);
            NSUInteger dataLen = data.length;
            const void *inData = [data bytes];
            void *outData = malloc(2*dataLen);
            int outLen = 0;
            smt_encrypt(_smt, (char *)inData, dataLen, outData, &outLen);
            ret = [[NSData alloc] initWithBytes:outData length:outLen];
            free(outData);
        }
    }
    
    return ret;
}

// it is used by receiving message.
- (NSData *)decryptData:(NSData *)data args:(id)aArgs {
    NSData *ret = nil;
    if ([aArgs isKindOfClass:[NSArray class]]) {
        NSArray *args = (NSArray *)aArgs;
        EMMessage *message = nil;
        for (id object in args) {
            if ([object isKindOfClass:[EMMessage class]]) {
                message = (EMMessage *)object;
                break;
            }
        }
        if (message) {
            //NSString *from = message.from;
            //NSString *to = message.to;
            // todo: how to decrypt data ? 
            //smt_getKey(smt_t *smt, int requestFlag, char *callPhoneNum, char *calledPhoneNum);
            NSUInteger dataLen = data.length;
            const void *inData = [data bytes];
            void *outData = malloc(2*dataLen);
            int outLen = 0;
            smt_decrypt(_smt, (char *)inData, dataLen, outData, &outLen);
            ret = [[NSData alloc] initWithBytes:outData length:outLen];
            free(outData);
        }
    }
    
    return ret;
}

- (NSString *)encryptString:(NSString *)string args:(id)aArgs {
    NSString *ret = nil;
    NSData *value = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [self encryptData:value args:aArgs];
    if (encryptedData != nil) {
        ret = [encryptedData smt_base64EncodedString];
    } else {
        ret = @"";
    }
    return ret;
}

- (NSString *)decryptString:(NSString *)string args:(id)aArgs {
    NSData *encryptedData = [string smt_base64DecodedData];
    if (encryptedData != nil) {
        NSData *value = [self decryptData:encryptedData args:aArgs];
        if (value != nil && [value bytes] != NULL) {
            const char *bytes = (const char *)[value bytes];
            unsigned int length = [value length];
            int realLength;
            for (realLength = length; realLength >0; --realLength) {
                if (bytes[realLength-1] == 0)
                    continue;
                else 
                    break;
            }
            return [[NSString alloc] initWithBytes:bytes length:realLength encoding:NSUTF8StringEncoding];
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

@end
