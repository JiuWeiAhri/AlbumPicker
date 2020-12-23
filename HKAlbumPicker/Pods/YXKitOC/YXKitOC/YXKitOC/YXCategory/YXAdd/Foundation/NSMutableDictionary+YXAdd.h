//
//  NSMutableDictionary+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (YXAdd)

/// 筛选符合条件的元素
- (void)bk_performSelect:(BOOL (^)(id key, id obj))block;

/// 筛选不符合条件的元素
- (void)bk_performReject:(BOOL (^)(id key, id obj))block;

/// 遍历替换元素
- (void)bk_performMap:(id (^)(id key, id obj))block;

@end

NS_ASSUME_NONNULL_END
