//
//  NSMutableArray+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (YXAdd)

#pragma mark - YXAdd

/// 安全移除某个元素
- (void)yx_removeObjectAtSafeIndex:(NSUInteger)index;

/// 移除第一个元素
- (void)yx_removeFirstObject;

/// 移除最后一个元素
- (void)yx_removeLastObject;

/// 添加NSArray到index-0
- (void)yx_addObjectsToFirst:(NSArray *)objects;

/// 添加NSArray到指定Index
- (void)yx_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/// 翻转数组 前 @[ @1, @2, @3 ], 后 @[ @3, @2, @1 ].
- (void)yx_reverse;

/// 随机排序（洗牌）
- (void)yx_shuffle;

#pragma mark - YXBlock

/// 筛选符合条件的元素
- (void)yx_saveMatchObjects:(BOOL (^)(id obj))block;

/// 筛选不符合条件的元素
- (void)yx_removeRejectObjects:(BOOL (^)(id obj))block;

/// 遍历替换元素
- (void)yx_replaceForMatch:(id (^)(id obj))block;

@end

NS_ASSUME_NONNULL_END
