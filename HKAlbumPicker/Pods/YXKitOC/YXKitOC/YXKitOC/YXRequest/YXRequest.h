//
//  YXHTTPRequest.h
//  YXKitDemo
//
//  Created by zx on 2018/10/16.
//  Copyright © 2018 a186f13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXRequestHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXRequest : NSObject

/**< 请求api地址 */
@property (nonatomic, copy, readonly) NSString *url;

/**< 请求参数 */
@property (nonatomic, strong, readonly) NSDictionary *parameters;

/** 超时时间，默认30秒（秒） */
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

/// 设置域名
- (NSString *)baseUrl;

/// 缓存时间
- (NSInteger)cacheTimeInSeconds;

/// 缓存版本
- (long long)cacheVersion;

/// 设置参数
- (id)requestArgument;

/// 设置Header
- (NSDictionary *)requestHeaderFieldValueDictionary;

/// 请求类别
- (YXRequestSerializerType)requestSerializerType;

/// 上传
- (nullable YXConstructingBlock)constructingBodyBlock;

+ (instancetype)yx_getApi:(NSString *)api parameters:(nullable NSDictionary *)parameters;
+ (instancetype)yx_postApi:(NSString *)api parameters:(nullable NSDictionary *)parameters;
+ (instancetype)yx_headApi:(NSString *)api parameters:(nullable NSDictionary *)parameters;
+ (instancetype)yx_putApi:(NSString *)api parameters:(nullable NSDictionary *)parameters;
+ (instancetype)yx_deleteApi:(NSString *)api parameters:(nullable NSDictionary *)parameters;
+ (instancetype)yx_patchApi:(NSString *)api parameters:(nullable NSDictionary *)parameters;

/** 最基础的请求方式，可获得 requestTask 和 responseObject */
- (void)startWithResponseSerializerType:(YXResponseSerializerType)responseSerializerType
                           SuccessBlock:(nullable void (^)(NSURLSessionTask *requestTask, id responseObject))successBlcok
                             errorBlock:(nullable void (^)(NSInteger responseStatusCode, NSURLSessionTask *requestTask, id responseObject))errorBlock;

@end

NS_ASSUME_NONNULL_END
