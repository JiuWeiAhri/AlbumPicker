//
//  NSError+YXAdd.m
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/2/16.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "NSError+YXAdd.h"

@implementation NSError (YXAdd)

+ (NSError *)yx_errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMsg {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [userInfo setObject:[NSString stringWithFormat:@"%ld", (long)code] forKey:@"errorCode"];
    if (errorMsg) {
        [userInfo setObject:errorMsg ? errorMsg : @"" forKey:@"errorMsg"];
    }
    NSError *error = [NSError errorWithDomain:errorMsg code:code userInfo:userInfo];
    return error;
}

@end
