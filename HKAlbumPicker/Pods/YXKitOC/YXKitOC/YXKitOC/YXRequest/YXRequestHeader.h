//
//  YXRequestHeader.h
//  YXKitDemo
//
//  Created by zx on 2018/10/18.
//  Copyright © 2018 a186f13. All rights reserved.
//

#ifndef YXRequestHeader_h
#define YXRequestHeader_h

typedef NS_ENUM(NSUInteger, YXRequestSerializerType) {
    YXRequestSerializerTypeHTTP = 0,
    YXRequestSerializerTypeJSON,
};

typedef NS_ENUM(NSUInteger, YXResponseSerializerType) {
    YXResponseSerializerTypeHTTP = 0,
    YXResponseSerializerTypeJSON,
};

typedef NS_ENUM(NSInteger, YXRequestMethod) {
    YXRequestMethodGET = 0,
    YXRequestMethodPOST,
    YXRequestMethodHEAD,
    YXRequestMethodPUT,
    YXRequestMethodDELETE,
    YXRequestMethodPATCH,
};

@protocol YXMultipartFormData

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * _Nullable __autoreleasing *)error;

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;

@end

typedef void (^YXConstructingBlock)(id<YXMultipartFormData> formData);

#import "YXRequestConfig.h"
#import "YXRequest.h"

#endif /* YXRequestHeader_h */
