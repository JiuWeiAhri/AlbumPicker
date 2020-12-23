//
//  YXBaseRequest.m
//  YXKitDemo
//
//  Created by zx on 2018/6/26.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import "YXBaseRequest.h"
#import "YXModel.h"
#import "YXTools.h"

@implementation YXBaseRequest

#pragma mark - Subclass Override

- (YTKRequestMethod)requestMethod {
    if (self.baseDelegate) {
        return (int)[self.baseDelegate requestMethod];
    }
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.baseDelegate) {
        return [self.baseDelegate requestUrl];
    }
    return nil;
}

- (id)requestArgument {
    if (self.baseDelegate) {
        return [self.baseDelegate requestArgument];
    }
    return nil;
}

- (void)requestCompletePreprocessor {
    if (self.baseDelegate) {
        [self.baseDelegate requestCompletePreprocessor];
    }
}

- (void)requestCompleteFilter {
    if (self.baseDelegate) {
        [self.baseDelegate requestCompleteFilter];
    }
}

- (void)requestFailedPreprocessor {
    if (self.baseDelegate) {
        [self.baseDelegate requestFailedPreprocessor];
    }
}

- (void)requestFailedFilter {
    if (self.baseDelegate) {
        [self.baseDelegate requestFailedFilter];
    }
}

- (NSString *)cdnUrl {
    if (self.baseDelegate) {
        return [self.baseDelegate cdnUrl];
    }
    return @"";
}

- (NSString *)baseUrl {
    if (self.baseDelegate) {
        return [self.baseDelegate baseUrl];
    }
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    if (self.baseDelegate) {
        return [self.baseDelegate requestTimeoutInterval];
    }
    return 30;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    if (self.baseDelegate) {
        return [self.baseDelegate cacheFileNameFilterForRequestArgument:argument];
    }
    return argument;
}

- (YTKRequestSerializerType)requestSerializerType {
    if (self.baseDelegate) {
        return (int)[self.baseDelegate requestSerializerType];
    }
    return YTKRequestSerializerTypeHTTP;
}

- (YTKResponseSerializerType)responseSerializerType {
    if (self.baseDelegate) {
        return (int)[self.baseDelegate responseSerializerType];
    }
    return YTKResponseSerializerTypeJSON;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    if (self.baseDelegate) {
        return [self.baseDelegate requestAuthorizationHeaderFieldArray];
    }
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    if (self.baseDelegate) {
        return [self.baseDelegate requestHeaderFieldValueDictionary];
    }
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    if (self.baseDelegate) {
        return [self.baseDelegate buildCustomUrlRequest];
    }
    return nil;
}

- (BOOL)useCDN {
    if (self.baseDelegate) {
        return [self.baseDelegate useCDN];
    }
    return NO;
}

- (BOOL)allowsCellularAccess {
    if (self.baseDelegate) {
        return [self.baseDelegate allowsCellularAccess];
    }
    return YES;
}

- (id)jsonValidator {
    if (self.baseDelegate) {
        return [self.baseDelegate jsonValidator];
    }
    return nil;
}

- (AFConstructingBlock)constructingBodyBlock {
    if ([self.baseDelegate constructingBodyBlock]) {
        return (AFConstructingBlock)[self.baseDelegate constructingBodyBlock];
    } else {
        return nil;
    }
}

@end
