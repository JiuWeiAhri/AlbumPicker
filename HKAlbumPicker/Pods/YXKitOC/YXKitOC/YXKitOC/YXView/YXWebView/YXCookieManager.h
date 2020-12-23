//
//  YXCookieManager.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/7/8.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCookieManager : NSObject

+ (NSString *)convertCookieStringForURLRequestWithCookie:(NSDictionary *)cookie;

+ (NSString *)convertCookieStringForWKUserScriptWithCookie:(NSDictionary *)cookie;

@end

NS_ASSUME_NONNULL_END
