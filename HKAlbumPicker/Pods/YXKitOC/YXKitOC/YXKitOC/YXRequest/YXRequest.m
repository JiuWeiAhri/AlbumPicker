//
//  YXHTTPRequest.m
//  YXKitDemo
//
//  Created by zx on 2018/10/16.
//  Copyright © 2018 a186f13. All rights reserved.
//

#import "YXRequest.h"
#import "YXBaseRequest.h"
#import "YXRequestConfig.h"
#import "YXTools.h"

typedef NS_ENUM(NSUInteger, YXRequestType) {
    YXRequestTypeGet,
    YXRequestTypePost,
    YXRequestTypeHead,
    YXRequestTypePut,
    YXRequestTypeDelete,
    YXRequestTypePatch,
};

@interface YXRequest() <YXBaseRequestDelegate> {
    YXRequestType _requestType;
    YXResponseSerializerType _responseSerializerType;
}

@property (nonatomic, copy) NSString *url; /**< 请求api地址 */
@property (nonatomic, strong) NSDictionary *parameters; /**< 请求参数 */
@property (nonatomic, strong) YXBaseRequest *baseRequest; /**< 网络请求 */

@end

@implementation YXRequest

+ (instancetype)yx_getApi:(NSString *)api parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithUrl:api parameters:parameters requestType:YXRequestTypeGet];
}

+ (instancetype)yx_postApi:(NSString *)api parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithUrl:api parameters:parameters requestType:YXRequestTypePost];
}

+ (instancetype)yx_headApi:(NSString *)api parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithUrl:api parameters:parameters requestType:YXRequestTypeHead];
}

+ (instancetype)yx_putApi:(NSString *)api parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithUrl:api parameters:parameters requestType:YXRequestTypePut];
}

+ (instancetype)yx_deleteApi:(NSString *)api parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithUrl:api parameters:parameters requestType:YXRequestTypeDelete];
}

+ (instancetype)yx_patchApi:(NSString *)api parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithUrl:api parameters:parameters requestType:YXRequestTypePatch];
}

- (instancetype)initWithUrl:(NSString *)url parameters:(NSDictionary *)parameters requestType:(YXRequestType)requestType {
    self = [super init];
    if (self) {
        _url = url;
        _parameters = parameters;
        _requestType = requestType;
        _requestTimeoutInterval = 30;
        _responseSerializerType = YXResponseSerializerTypeJSON;
    }
    return self;
}

#pragma mark - Public Func

- (NSInteger)cacheTimeInSeconds {
    return [self.baseRequest cacheTimeInSeconds];
}

- (long long)cacheVersion {
    return [self.baseRequest cacheVersion];
}

- (nullable id)cacheSensitiveData {
    return [self.baseRequest cacheSensitiveData];
}

- (BOOL)writeCacheAsynchronously {
    return [self.baseRequest writeCacheAsynchronously];
}

/** 最基础的请求方式，可获得 requestTask 和 responseObject */
- (void)startWithResponseSerializerType:(YXResponseSerializerType)responseSerializerType
                           SuccessBlock:(void (^)(NSURLSessionTask *requestTask, id responseObject))successBlcok
                             errorBlock:(void (^)(NSInteger responseStatusCode, NSURLSessionTask *requestTask, id responseObject))errorBlock {
    
    _responseSerializerType = responseSerializerType;
    
    [self.baseRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self printLogWithRequest:request];
        
        if (successBlcok) {
            if (self->_responseSerializerType == YXResponseSerializerTypeJSON && [YXRequestConfig sharedConfig].isRemovesKeysWithNullValues) {
                successBlcok(request.requestTask, YXJSONObjectByRemovingKeysWithNullValues(request.responseJSONObject, 0));
            } else {
                successBlcok(request.requestTask, request.responseObject);
            }
        
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self printLogWithRequest:request];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSInteger errorCode = request.requestTask.error.code;
        NSString *errorMsg = @"";
        switch (errorCode) {
            case NSURLErrorUnknown:
            case NSURLErrorCancelled:
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorResourceUnavailable:
                errorMsg = @"无效的URL地址";
                break;
            case NSURLErrorTimedOut:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorCannotFindHost:
            case NSURLErrorCannotConnectToHost:
                errorMsg = @"网络不给力，请稍后再试";
                break;
            case NSURLErrorDataLengthExceedsMaximum:
                errorMsg = @"请求数据长度超出最大限度";
                break;
            case NSURLErrorDNSLookupFailed:
                errorMsg = @"DNS查询失败";
                break;
            case NSURLErrorHTTPTooManyRedirects:
                errorMsg = @"HTTP请求重定向";
                break;
            case NSURLErrorRedirectToNonExistentLocation:
                errorMsg = @"重定向到不存在的位置";
                break;
            case NSURLErrorBadServerResponse:
                errorMsg = @"服务器响应异常";
                break;
            case NSURLErrorUserCancelledAuthentication:
                errorMsg = @"用户取消授权";
                break;
            case NSURLErrorUserAuthenticationRequired:
                errorMsg = @"需要用户授权";
                break;
            case NSURLErrorZeroByteResource:
            case NSURLErrorCannotDecodeRawData:
            case NSURLErrorCannotDecodeContentData:
            case NSURLErrorCannotParseResponse:
                errorMsg = @"无法解析响应数据";
                break;
            case NSURLErrorDataNotAllowed:
                errorMsg = @"数据不被允许";
                break;
            case NSURLErrorSecureConnectionFailed:
                errorMsg = @"安全连接失败";
                break;
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
                errorMsg = @"证书验证失败";
                break;
            case NSURLErrorDownloadDecodingFailedMidStream:
            case NSURLErrorDownloadDecodingFailedToComplete:
                errorMsg = @"下载解码数据失败";
                break;
            default:
                if ([request.responseObject isKindOfClass:[NSDictionary class]] && [request.responseObject[@"errorMsg"] length] > 0) {
                    errorMsg = request.responseObject[@"errorMsg"];
                } else {
                    errorMsg = @"请求错误";
                }
                break;
        }
        
        [dict setValue:errorMsg forKey:@"msg"];
        
        [dict setValue:@(request.responseStatusCode).stringValue forKey:@"status"];
        
        if (errorBlock) {
            errorBlock(request.responseStatusCode, request.requestTask, dict);
        }
    }];
}

#pragma mark - Private Func

static id YXJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:YXJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = YXJSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    
    return JSONObject;
}

/** 打印log */
- (void)printLogWithRequest:(YTKBaseRequest *)request {
#if DEBUG
    if ([YXRequestConfig sharedConfig].isShowLog) {
        NSMutableArray *requestDatas = [NSMutableArray array];
        [requestDatas addObject:request.requestTask.originalRequest.URL.absoluteString ? : @"无"];
        [requestDatas addObject:self.requestHeaderFieldValueDictionary ? : @{}];
        [requestDatas addObject:self.requestArgument ? : @{}];
        [requestDatas addObject:request.responseString ? : @"无"];
        DLog(@"\n\n😃😃\nURL\n%@\nHead头\n%@\n参数\n%@\n结果\n%@", requestDatas[0], [requestDatas[1] yx_jsonStringEncoded], [requestDatas[2] yx_jsonStringEncoded], requestDatas[3])
    }
#endif
}

#pragma mark - YXBaseRequestDelegate

- (YXRequestMethod)requestMethod {
    return (int)_requestType;
}

- (NSString *)requestUrl {
    return _url;
}

- (id)requestArgument {
    return _parameters;
}

- (void)requestCompletePreprocessor {
}

- (void)requestCompleteFilter {
}

- (void)requestFailedPreprocessor {
}

- (void)requestFailedFilter {
}

- (NSString *)cdnUrl {
    return @"";
}

- (NSString *)baseUrl {
    return [YXRequestConfig sharedConfig].baseUrl;
}

- (NSTimeInterval)requestTimeoutInterval {
    return _requestTimeoutInterval;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}

- (YXRequestSerializerType)requestSerializerType {
    return YXRequestSerializerTypeHTTP;
}

- (YXResponseSerializerType)responseSerializerType {
    return _responseSerializerType;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

- (id)jsonValidator {
    return nil;
}

- (YXConstructingBlock)constructingBodyBlock {
    return nil;
}

#pragma mark - Getter

- (YXBaseRequest *)baseRequest {
    if (!_baseRequest) {
        _baseRequest = [[YXBaseRequest alloc] init];
        _baseRequest.baseDelegate = self;
    }
    return _baseRequest;
}

@end
