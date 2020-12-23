//
//  NSData+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/17.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (YXAdd)

/// UTF-8编码
- (NSString *)yx_utf8String;

/// DES加密
+ (NSData *)yx_DESEncrypt:(NSData *)data WithKey:(NSString *)key;

// DES解密
+ (NSData *)yx_DESDecrypt:(NSData *)data WithKey:(NSString *)key;

/// base64NSString换NSData
+ (NSData *)yx_dataWithBase64String:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
