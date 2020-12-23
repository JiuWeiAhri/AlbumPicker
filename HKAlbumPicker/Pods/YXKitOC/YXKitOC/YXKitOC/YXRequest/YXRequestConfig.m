//
//  YXRequestConfig.m
//  YXKitDemo
//
//  Created by zx on 2018/10/18.
//  Copyright © 2018 a186f13. All rights reserved.
//

#import "YXRequestConfig.h"
#import <YTKNetwork/YTKNetworkConfig.h>

@implementation YXRequestConfig

+ (instancetype)sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setBaseUrl:(NSString *)baseUrl {
    _baseUrl = baseUrl;
    
    [[YTKNetworkConfig sharedConfig] setBaseUrl:baseUrl];
}

@end
