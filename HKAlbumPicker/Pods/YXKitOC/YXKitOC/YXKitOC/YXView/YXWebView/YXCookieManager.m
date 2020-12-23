//
//  YXCookieManager.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/7/8.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXCookieManager.h"

@implementation YXCookieManager

+ (NSString *)convertCookieStringForURLRequestWithCookie:(NSDictionary *)cookie {

    NSMutableString *cookieValue = [NSMutableString string];
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    /// 添加已有cookie
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    /// 添加当前cookie
    [cookieDic addEntriesFromDictionary:cookie];
    
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    return cookieValue;
}

+ (NSString *)convertCookieStringForWKUserScriptWithCookie:(NSDictionary *)cookie {

    NSMutableString *cookieValue = [NSMutableString string];
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    /// 添加已有cookie
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    /// 添加当前cookie
    [cookieDic addEntriesFromDictionary:cookie];
    
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"document.cookie = '%@=%@';", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    return cookieValue;
}

@end
