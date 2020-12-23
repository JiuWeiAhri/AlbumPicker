//
//  YXRequestConfig.h
//  YXKitDemo
//
//  Created by zx on 2018/10/18.
//  Copyright © 2018 a186f13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXRequestHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXRequestConfig : NSObject

+ (instancetype)sharedConfig;

/** 请求域名 默认空 */
@property (nonatomic, copy) NSString *baseUrl;

/** 是否删除null字段（当response为JSON格式时生效，即YXJSONRequest请求） */
@property (nonatomic, assign) BOOL isRemovesKeysWithNullValues;

/** 是否显示接口日志 */
@property (nonatomic, assign) BOOL isShowLog;

@end

NS_ASSUME_NONNULL_END
