//
//  YXBaseRequest.h
//  YXKitDemo
//
//  Created by zx on 2018/6/26.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "YXRequestHeader.h"

@protocol YXBaseRequestDelegate;

@interface YXBaseRequest : YTKRequest

@property (nonatomic, weak) id<YXBaseRequestDelegate> baseDelegate;

@end

@protocol YXBaseRequestDelegate <NSObject>

- (YXRequestMethod)requestMethod;

- (NSString *)requestUrl;

- (id)requestArgument;

- (void)requestCompletePreprocessor;

- (void)requestCompleteFilter;

- (void)requestFailedPreprocessor;

- (void)requestFailedFilter;

- (NSString *)cdnUrl;

- (NSString *)baseUrl;

- (NSTimeInterval)requestTimeoutInterval;

- (id)cacheFileNameFilterForRequestArgument:(id)argument;

- (YXRequestSerializerType)requestSerializerType;

- (YXResponseSerializerType)responseSerializerType;

- (NSArray *)requestAuthorizationHeaderFieldArray;

- (NSDictionary *)requestHeaderFieldValueDictionary;

- (NSURLRequest *)buildCustomUrlRequest;

- (BOOL)useCDN;

- (BOOL)allowsCellularAccess;

- (id)jsonValidator;

- (YXConstructingBlock)constructingBodyBlock;

@end
